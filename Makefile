

all:
	python	bin/make.py

clean:
	rm -rf .gen/ dist/*.js models.js processes.js is-sim.js;

.PHONY: all clean
