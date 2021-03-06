Alternative Files
-----------------

Find alternative files in Emacs according to customizable rules.

Usage
=====

1.  Put the file in `load-path` and load it using

        (require 'alternative-files)

2.  Bind keys to functions

        (global-set-key (kbd "M-s a") 'alternative-files-find-file)
        (global-set-key (kbd "M-s A") 'alternative-files-create-file)

3.  User rules can be setup using directory local variables, for example,
    create a file `.dir-locals.el`, and following rules:
    
    Every rule is a list. The first element (`car`) is a regular
    expression. The rest elements (`cdr`) are replacements. If a file path
    match the regular expression, all the replacements are used as alternative
    files. In following example, `spec/hello_spec.coffee` has alternative file
    `assets/test.coffee`.
    
        ((nil
          (alternative-files-rules . (("spec/\\(.*\\)_spec.coffee" "assets/\\1.coffee")
                                      ("assets/\\(.*\\).coffee" "spec/\\1_spec.coffee")))))

Customization
=============

See `M-x customize-group <RET> alternative-files <RET>`

- `alternative-files-functions`

  A list of functions to find alternative files. The function takes no argument
  and should return a list of alternative files as **absolute** path for current
  buffer. The functions can return directory name in list, then all files in
  that directory are used.

- `alternative-files-completing-read`

  Completion function used to read user choice minibuffer
  
- `alternative-files-root-dir-function`

  A function to return the root directory of current buffer. If alternative
  file is in this root directory, the relative file name is used. It can make
  completion list shorter and cleaner.
