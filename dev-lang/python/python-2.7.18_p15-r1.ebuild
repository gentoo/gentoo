# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
WANT_LIBTOOL="none"

inherit autotools flag-o-matic pax-utils toolchain-funcs verify-sig

MY_P="Python-${PV%_p*}"
PYVER=$(ver_cut 1-2)
PATCHSET="python-gentoo-patches-${PV}"

DESCRIPTION="An interpreted, interactive, object-oriented programming language"
HOMEPAGE="
	https://www.python.org/
	https://github.com/python/cpython/
	https://gitweb.gentoo.org/fork/cpython.git/
"
SRC_URI="
	https://www.python.org/ftp/python/${PV%_*}/${MY_P}.tar.xz
	https://dev.gentoo.org/~mgorny/dist/python/${PATCHSET}.tar.xz
	verify-sig? (
		https://www.python.org/ftp/python/${PV%_*}/${MY_P}.tar.xz.asc
	)
"
S="${WORKDIR}/${MY_P}"

LICENSE="PSF-2"
SLOT="${PYVER}"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="
	berkdb bluetooth build examples gdbm hardened +ncurses +readline
	+sqlite +ssl tk wininst +xml
"

# Do not add a dependency on dev-lang/python to this ebuild.
# If you need to apply a patch which requires python for bootstrapping, please
# run the bootstrap code on your dev box and include the results in the
# patchset. See bug 447752.

RDEPEND="
	app-arch/bzip2:=
	dev-libs/libffi:=
	>=sys-libs/zlib-1.1.3:=
	virtual/libcrypt:=
	virtual/libintl
	berkdb? ( || (
		sys-libs/db:5.3
		sys-libs/db:4.8
	) )
	gdbm? ( sys-libs/gdbm:=[berkdb] )
	ncurses? ( >=sys-libs/ncurses-5.2:= )
	readline? ( >=sys-libs/readline-4.1:= )
	sqlite? ( >=dev-db/sqlite-3.3.8:3= )
	ssl? ( dev-libs/openssl:= )
	tk? (
		>=dev-lang/tcl-8.0:=
		>=dev-lang/tk-8.0:=
		dev-tcltk/blt:=
		dev-tcltk/tix
	)
	xml? ( >=dev-libs/expat-2.1:= )
"
# bluetooth requires headers from bluez
DEPEND="
	${RDEPEND}
	bluetooth? ( net-wireless/bluez )
"
BDEPEND="
	virtual/awk
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-python )
"
RDEPEND+="
	!build? ( app-misc/mime-types )
"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/python.org.asc

QA_PKGCONFIG_VERSION=${PYVER}

pkg_setup() {
	if use berkdb; then
		ewarn "'bsddb' module is out-of-date and no longer maintained inside"
		ewarn "dev-lang/python. 'bsddb' and 'dbhash' modules have been additionally"
		ewarn "removed in Python 3. A maintained alternative of 'bsddb3' module"
		ewarn "is provided by dev-python/bsddb3."
	fi
}

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.xz{,.asc}
	fi
	default
}

src_prepare() {
	# Ensure that internal copies of expat, libffi and zlib are not used.
	rm -r Modules/expat || die
	rm -r Modules/_ctypes/libffi* || die
	rm -r Modules/zlib || die

	local PATCHES=(
		"${WORKDIR}/${PATCHSET}"
	)

	default

	sed -i -e "s:@@GENTOO_LIBDIR@@:$(get_libdir):g" \
		Lib/distutils/command/install.py \
		Lib/distutils/sysconfig.py \
		Lib/site.py \
		Lib/sysconfig.py \
		Lib/test/test_site.py \
		Makefile.pre.in \
		Modules/Setup.dist \
		Modules/getpath.c \
		setup.py || die "sed failed to replace @@GENTOO_LIBDIR@@"

	eautoreconf
}

src_configure() {
	# dbm module can be linked against berkdb or gdbm.
	# Defaults to gdbm when both are enabled, #204343.
	local disable
	use berkdb    || use gdbm || disable+=" dbm"
	use berkdb    || disable+=" _bsddb"
	# disable automagic bluetooth headers detection
	use bluetooth || export ac_cv_header_bluetooth_bluetooth_h=no
	use gdbm      || disable+=" gdbm"
	use ncurses   || disable+=" _curses _curses_panel"
	use readline  || disable+=" readline"
	use sqlite    || disable+=" _sqlite3"
	use ssl       || export PYTHON_DISABLE_SSL="1"
	use tk        || disable+=" _tkinter"
	use xml       || disable+=" _elementtree pyexpat" # _elementtree uses pyexpat.
	export PYTHON_DISABLE_MODULES="${disable}"

	if ! use xml; then
		ewarn "You have configured Python without XML support."
		ewarn "This is NOT a recommended configuration as you"
		ewarn "may face problems parsing any XML documents."
	fi

	if [[ -n "${PYTHON_DISABLE_MODULES}" ]]; then
		einfo "Disabled modules: ${PYTHON_DISABLE_MODULES}"
	fi

	append-flags -fwrapv

	filter-flags -malign-double

	if tc-is-cross-compiler; then
		# Force some tests that try to poke fs paths.
		export ac_cv_file__dev_ptc=no
		export ac_cv_file__dev_ptmx=yes
	fi

	# Export CXX so it ends up in /usr/lib/python2.X/config/Makefile.
	tc-export CXX
	# The configure script fails to use pkg-config correctly.
	# http://bugs.python.org/issue15506
	export ac_cv_path_PKG_CONFIG=$(tc-getPKG_CONFIG)

	local dbmliborder=
	if use gdbm; then
		dbmliborder+="${dbmliborder:+:}gdbm"
	fi
	if use berkdb; then
		dbmliborder+="${dbmliborder:+:}bdb"
	fi

	local myeconfargs=(
		# The check is broken on clang, and gives false positive:
		# https://bugs.gentoo.org/596798
		# (upstream dropped this flag in 3.2a4 anyway)
		ac_cv_opt_olimit_ok=no
		# glibc-2.30 removes it; since we can't cleanly force-rebuild
		# Python on glibc upgrade, remove it proactively to give
		# a chance for users rebuilding python before glibc
		ac_cv_header_stropts_h=no

		--with-fpectl
		--enable-shared
		--enable-ipv6
		--with-threads
		--enable-unicode=ucs4
		--infodir='${prefix}/share/info'
		--mandir='${prefix}/share/man'
		--with-computed-gotos
		--with-dbmliborder="${dbmliborder}"
		--with-libc=
		--enable-loadable-sqlite-extensions
		--without-ensurepip
		--with-system-expat
		--with-system-ffi
	)

	# disable implicit optimization/debugging flags
	local -x OPT=
	econf "${myeconfargs[@]}"

	if grep -q "#define POSIX_SEMAPHORES_NOT_ENABLED 1" pyconfig.h; then
		eerror "configure has detected that the sem_open function is broken."
		eerror "Please ensure that /dev/shm is mounted as a tmpfs with mode 1777."
		die "Broken sem_open function (bug 496328)"
	fi

	# install epython.py as part of stdlib
	echo "EPYTHON='python${PYVER}'" > Lib/epython.py || die
}

src_compile() {
	# Ensure sed works as expected
	# https://bugs.gentoo.org/594768
	local -x LC_ALL=C

	# Avoid invoking pgen for cross-compiles.
	touch Include/graminit.h Python/graminit.c || die

	emake

	# Work around bug 329499. See also bug 413751 and 457194.
	if has_version dev-libs/libffi[pax-kernel]; then
		pax-mark E python
	else
		pax-mark m python
	fi
}

src_test() {
	# Tests will not work when cross compiling.
	if tc-is-cross-compiler; then
		elog "Disabling tests due to crosscompiling."
		return
	fi

	# Skip failing tests.
	local skipped_tests=( distutils gdb )

	for test in "${skipped_tests[@]}"; do
		mv Lib/test/test_${test}.py "${T}"/ || die
	done

	# bug 660358
	local -x COLUMNS=80

	# Daylight saving time problem
	# https://bugs.python.org/issue22067
	# https://bugs.gentoo.org/610628
	local -x TZ=UTC

	# Rerun failed tests in verbose mode (regrtest -w).
	emake test EXTRATESTOPTS="-w" < /dev/tty

	for test in "${skipped_tests[@]}"; do
		mv "${T}/test_${test}.py" Lib/test/ || die
	done
}

src_install() {
	local libdir=${ED}/usr/$(get_libdir)/python${PYVER}

	emake DESTDIR="${D}" altinstall

	sed -e "s/\(LDFLAGS=\).*/\1/" -i "${libdir}/config/Makefile" || die

	# Remove static library
	rm "${ED}"/usr/$(get_libdir)/libpython*.a || die

	# Fix collisions between different slots of Python.
	mv "${ED}/usr/bin/2to3" "${ED}/usr/bin/2to3-${PYVER}" || die
	mv "${ED}/usr/bin/pydoc" "${ED}/usr/bin/pydoc${PYVER}" || die
	mv "${ED}/usr/bin/idle" "${ED}/usr/bin/idle${PYVER}" || die
	rm "${ED}/usr/bin/smtpd.py" || die

	if ! use berkdb; then
		rm -r "${libdir}/"{bsddb,dbhash.py*,test/test_bsddb*} || die
	fi
	if ! use sqlite; then
		rm -r "${libdir}/"{sqlite3,test/test_sqlite*} || die
	fi
	if ! use tk; then
		rm -r "${ED}/usr/bin/idle${PYVER}" || die
		rm -r "${libdir}/"{idlelib,lib-tk} || die
	fi
	if ! use wininst; then
		rm "${libdir}/distutils/command/"wininst-*.exe || die
	fi

	dodoc Misc/{ACKS,HISTORY,NEWS}

	if use examples; then
		docinto examples
		dodoc -r Tools
	fi

	newconfd "${FILESDIR}/pydoc.conf" pydoc-${PYVER}
	newinitd "${FILESDIR}/pydoc.init" pydoc-${PYVER}
	sed \
		-e "s:@PYDOC_PORT_VARIABLE@:PYDOC${PYVER/./_}_PORT:" \
		-e "s:@PYDOC@:pydoc${PYVER}:" \
		-i "${ED}/etc/conf.d/pydoc-${PYVER}" \
		"${ED}/etc/init.d/pydoc-${PYVER}" || die "sed failed"

	# python2* is no longer wrapped, so just symlink it
	local pymajor=${PYVER%.*}
	dosym "python${PYVER}" "/usr/bin/python${pymajor}"
	dosym "python${PYVER}-config" "/usr/bin/python${pymajor}-config"
}
