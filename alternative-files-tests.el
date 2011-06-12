(require 'el-expectations)
(require 'alternative-files)

(expectations
 (desc "alternative-files--singularize-string")

 (desc "should try to call singularize-string")
 (expect
  "bar"
  (with-mock
   (mock (singularize-string "foo") => "bar")
   (alternative-files--singularize-string "foo")))

 (desc "should remove trailing char if singularize-string is not available")
 (expect
  "fo"
  (alternative-files--singularize-string "foo"))
 )

(expectations
 (desc "alternative-files--pluralize-string")

 (desc "should try to call pluralize-string")
 (expect
  "bar"
  (with-mock
   (mock (pluralize-string "foo") => "bar")
   (alternative-files--pluralize-string "foo")))

 (desc "should append trailing s if pluralize-string is not available")
 (expect
  "foos"
  (alternative-files--pluralize-string "foo"))
 )

(expectations
 (desc "alternative-files--detect-file-name")

 (desc "should use buffer-file-name for buffer visiting files")
 (expect
  "file-name"
  (with-mock
   (mock (buffer-file-name) => "file-name")
   (alternative-files--detect-file-name)))

 (desc "should use buffer-file-name of the org src marker buffer")
 (expect
  "file-name"
  (let ((org-src-mode t)
        (org-edit-src-beg-marker 'marker))
    (with-mock
     (mock (marker-buffer 'marker) => 'buffer)
     (mock (buffer-file-name 'buffer) => "file-name")
     (alternative-files--detect-file-name))))

 (desc "should use default-directory in magit-mode")
 (expect
  "/tmp/"
  (let ((major-mode 'magit-mode)
        (default-directory "/tmp/"))
    (alternative-files--detect-file-name)))

 (desc "should use default-directory in term-mode")
 (expect
  "/tmp/"
  (let ((major-mode 'term-mode)
        (default-directory "/tmp/"))
    (alternative-files--detect-file-name)))

 (desc "should use dired-directory in dired-mode")
 (expect
  "/tmp/"
  (let ((major-mode 'dired-mode)
        (dired-directory "/tmp/"))
    (alternative-files--detect-file-name)))
 )

(expectations
 (desc "alternative-files--relative-name")

 (desc "should return name relative to dir if filename is in the dir")
 (expect
  "bar/test.txt"
  (alternative-files--relative-name "/tmp/foo/bar/test.txt" "/tmp/foo/"))

 (desc "should return absolute name if filename is not in the dir")
 (expect
  "/tmp/foo/bar/test.txt"
  (alternative-files--relative-name "/tmp/foo/bar/test.txt" "/home/"))
 )

(expectations
 (desc "alternative-files-ffap-finder")
 
 (expect
  (mock (alternative-files-ffap-finder) => nil)
  (alternative-files-ffap-finder))
 )

(expectations
 (desc "alternative-files-rails-finder")

 (desc "should call alternative-files--detect-file-name if no file is specified")
 (expect
  (mock (alternative-files--detect-file-name) => "/tmp")
  (alternative-files-rails-finder))

 (desc "should not call alternative-files--detect-file-name if file is specified")
 (expect
  (not-called alternative-files--detect-file-name)
  (alternative-files-rails-finder "/tmp"))

 (desc "top level model")
 (expect
  '("/root/app/controllers/users_controller.rb"
    "/root/app/controllers/user_controller.rb"
    "/root/app/helpers/users_helper.rb"
    "/root/app/helpers/user_helper.rb"
    "/root/app/views/users/"
    "/root/app/views/user/")
  (alternative-files-rails-finder "/root/app/models/user.rb"))

 (desc "child model")
 (expect
  '("/root/app/controllers/admin/users_controller.rb"
    "/root/app/controllers/admin/user_controller.rb"
    "/root/app/helpers/admin/users_helper.rb"
    "/root/app/helpers/admin/user_helper.rb"
    "/root/app/views/admin/users/"
    "/root/app/views/admin/user/")
  (alternative-files-rails-finder "/root/app/models/admin/user.rb"))


 (desc "top level controller")
 (expect
  '("/root/app/models/user.rb"
    "/root/app/models/users.rb"
    "/root/app/helpers/users_helper.rb"
    "/root/app/views/users/")
  (alternative-files-rails-finder "/root/app/controllers/users_controller.rb"))

 (desc "child controller")
 (expect
  '("/root/app/models/admin/user.rb"
    "/root/app/models/admin/users.rb"
    "/root/app/helpers/admin/users_helper.rb"
    "/root/app/views/admin/users/")
  (alternative-files-rails-finder "/root/app/controllers/admin/users_controller.rb"))

 (desc "top level helper")
 (expect
  '("/root/app/models/user.rb"
    "/root/app/models/users.rb"
    "/root/app/controllers/users_controller.rb"
    "/root/app/views/users/")
  (alternative-files-rails-finder "/root/app/helpers/users_helper.rb"))

 (desc "child helper")
 (expect
  '("/root/app/models/admin/user.rb"
    "/root/app/models/admin/users.rb"
    "/root/app/controllers/admin/users_controller.rb"
    "/root/app/views/admin/users/")
  (alternative-files-rails-finder "/root/app/helpers/admin/users_helper.rb"))

 (desc "top level view")
 (expect
  '("/root/app/models/user.rb"
    "/root/app/models/users.rb"
    "/root/app/controllers/users_controller.rb"
    "/root/app/helpers/users_helper.rb")
  (alternative-files-rails-finder "/root/app/views/users/show.erb.html"))

 (desc "child view")
 (expect
  '("/root/app/models/admin/user.rb"
    "/root/app/models/admin/users.rb"
    "/root/app/controllers/admin/users_controller.rb"
    "/root/app/helpers/admin/users_helper.rb")
  (alternative-files-rails-finder "/root/app/views/admin/users/show.erb.html"))
 )

(expectations
 (desc "alternative-files")
 
 (desc "should call all functions in alternative-files-functions")
 (expect
  '("file1" "file2" "file3")
  (mock (finder1) => '("file1"))
  (mock (finder2) => '("file2" "file3"))
  (let ((alternative-files-executed nil)
        (alternative-files-functions '(finder1 finder2)))
    (alternative-files)))

 (desc "should remove duplicates")
 (expect
  '("file1" "file2")
  (mock (finder1) => '("file1"))
  (mock (finder2) => '("file2" "file1"))
  (let ((alternative-files-executed nil)
        (alternative-files-functions '(finder1 finder2)))
    (alternative-files)))

 (desc "should cache result")
 (expect
  '("file1" "file2")
  (not-called finder1)
  (not-called finder2)
  (let ((alternative-files-executed t)
        (alternative-files '("file1" "file2"))
        (alternative-files-functions '(finder1 finder2)))
    (alternative-files))))