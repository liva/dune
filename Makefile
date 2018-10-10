LIBC	= eglibc-2.14/eglibc-build/libc.so
SUBDIRS	= kern libdune

all: kern/imported.h $(SUBDIRS)
libc: $(LIBC)

kern/imported.h: kern/imported.h.in
	sh -c "sudo python kern/import-kernel-symbols.py kern/imported.h.in /boot/System.map-$(shell uname -r)" > kern/imported.h

$(SUBDIRS):
	$(MAKE) -C $(@)

$(LIBC):
	sh build-eglibc.sh

clean:
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir $(@); \
	done

distclean: clean
	rm -fr eglibc-2.14

.PHONY: $(SUBDIRS) clean distclean
