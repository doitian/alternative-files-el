OSTYPE=$(shell echo $$OSTYPE)
ifeq (,$(findstring darwin,$(OSTYPE)))
  EMACS=emacs
else
  EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
endif

test:
	@rm -f .test_results
	$(EMACS) -batch -q -no-site-file -L . -l el-expectations -f batch-expectations .test_results alternative-files-tests.el
	-cat .test_results
	@rm .test_results
