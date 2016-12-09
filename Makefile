

all:
	@echo "Compiling lib_smart-building..."
	@python	bin/make.py
	@echo "\n\033[0;32m[OK] Compiling lib_smart-building : Done\033[m\n"

clean:
	@! test -e .gen || rm -rf .gen/ dist/*.js models.js processes.js is-sim.js;
	@echo "\033[0;32m[OK] cleaning lib_smart-building : Done\033[m"

.PHONY: all clean
