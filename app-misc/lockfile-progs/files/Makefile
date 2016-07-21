all: lockfile-create

lockfile-create: lockfile-progs.o
	${CC} -o $@ ${CFLAGS} ${LDFLAGS} $^ -llockfile

install: all
	install -d $(DESTDIR)/usr/bin

	install --mode=755 lockfile-create $(DESTDIR)/usr/bin/lockfile-create
	ln -s lockfile-create $(DESTDIR)/usr/bin/lockfile-remove
	ln -s lockfile-create $(DESTDIR)/usr/bin/lockfile-touch
	ln -s lockfile-create $(DESTDIR)/usr/bin/lockfile-check

	install --mode=755 lockfile-create $(DESTDIR)/usr/bin/mail-lock
	ln -s mail-lock $(DESTDIR)/usr/bin/mail-unlock
	ln -s mail-unlock $(DESTDIR)/usr/bin/mail-touchlock

	install -d $(DESTDIR)/usr/share/man/man1

	install --mode=644 lockfile-progs.1 $(DESTDIR)/usr/share/man/man1
	ln -s lockfile-progs.1 $(DESTDIR)/usr/share/man/man1/lockfile-create.1
	ln -s lockfile-progs.1 $(DESTDIR)/usr/share/man/man1/lockfile-remove.1
	ln -s lockfile-progs.1 $(DESTDIR)/usr/share/man/man1/lockfile-touch.1
	ln -s lockfile-progs.1 $(DESTDIR)/usr/share/man/man1/lockfile-check.1

	ln -s lockfile-progs.1 $(DESTDIR)/usr/share/man/man1/mail-lock.1
	ln -s lockfile-progs.1 $(DESTDIR)/usr/share/man/man1/mail-unlock.1
	ln -s lockfile-progs.1 $(DESTDIR)/usr/share/man/man1/mail-touchlock.1

test: all
	ln -s lockfile-create ./lockfile-remove
	ln -s lockfile-create ./lockfile-touch
	ln -s lockfile-create ./lockfile-check

	./lockfile-create testfile
	./lockfile-check testfile
	./lockfile-touch --oneshot testfile
	./lockfile-check testfile
	./lockfile-remove testfile
	! test -e testfile
	! ./lockfile-check testfile

	./lockfile-create --lock-name test.lock
	./lockfile-check --lock-name test.lock
	! ./lockfile-check test.lock
	! test -e test.lock.lock
	./lockfile-touch --oneshot --lock-name test.lock
	./lockfile-check --lock-name test.lock
	! ./lockfile-check test.lock
	./lockfile-remove --lock-name test.lock
	! test -e test.lock
	! ./lockfile-check --lock-name test.lock
	! ./lockfile-check test.lock

.PHONY: install test
