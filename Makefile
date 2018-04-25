TARGS := $(shell sed -rn 's/^([-a-z]+):.*/\1/p' ./Makefile|sort -u|xargs)
.PHONY: $(TARGS)
.SILENT:

all: test

test:
	./test

travis:
	./test -v

clean:
	rm -rf $${TMPDIR:-/tmp}/vader.vim

tags:
	$${EDITOR:-vim} -u NONE -c 'helptags doc | qa!'
