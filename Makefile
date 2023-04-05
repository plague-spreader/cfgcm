XDG_DATA_HOME ?= ~/.local/
PREFIX ?= /usr/
	
.DEFAULT: choose_one
.PHONY: choose_one localinstall install

choose_one:
	$(error You have to put either "localinstall" or "install")

localinstall:
	env target_dir=${XDG_DATA_HOME} make -f Makefile.prefix

install:
	env target_dir=${PREFIX} make -f Makefile.prefix
