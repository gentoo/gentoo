# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
WANT_LIBTOOL="none"

inherit autotools check-reqs flag-o-matic multiprocessing pax-utils \
	python-utils-r1 toolchain-funcs verify-sig

MY_PV=${PV/_beta/b}
MY_P="Python-${MY_PV%_p*}"
PYVER=$(ver_cut 1-2)
PATCHSET="python-gentoo-patches-${MY_PV}"

DESCRIPTION="An interpreted, interactive, object-oriented programming language"
HOMEPAGE="
	https://www.python.org/
	https://github.com/python/cpython/
"
SRC_URI="
	https://www.python.org/ftp/python/${PV%%_*}/${MY_P}.tar.xz
	https://dev.gentoo.org/~mgorny/dist/python/${PATCHSET}.tar.xz
	verify-sig? (
		https://www.python.org/ftp/python/${PV%%_*}/${MY_P}.tar.xz.asc
	)
"
S="${WORKDIR}/${MY_P}"

LICENSE="PSF-2"
SLOT="${PYVER}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="bluetooth build examples gdbm hardened libedit lto +ncurses pgo +readline +sqlite +ssl test tk wininst"
RESTRICT="!test? ( test )"

# Do not add a dependency on dev-lang/python to this ebuild.
# If you need to apply a patch which requires python for bootstrapping, please
# run the bootstrap code on your dev box and include the results in the
# patchset. See bug 447752.

RDEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	app-crypt/libb2
	>=dev-libs/expat-2.1:=
	dev-libs/libffi:=
	sys-apps/util-linux:=
	>=sys-libs/zlib-1.1.3:=
	virtual/libcrypt:=
	virtual/libintl
	gdbm? ( sys-libs/gdbm:=[berkdb] )
	ncurses? ( >=sys-libs/ncurses-5.2:= )
	readline? (
		!libedit? ( >=sys-libs/readline-4.1:= )
		libedit? ( dev-libs/libedit:= )
	)
	sqlite? ( >=dev-db/sqlite-3.3.8:3= )
	ssl? ( >=dev-libs/openssl-1.1.1:= )
	tk? (
		>=dev-lang/tcl-8.0:=
		>=dev-lang/tk-8.0:=
		dev-tcltk/blt:=
		dev-tcltk/tix
	)
	!!<sys-apps/sandbox-2.21
"
# bluetooth requires headers from bluez
DEPEND="
	${RDEPEND}
	bluetooth? ( net-wireless/bluez )
	test? ( app-arch/xz-utils[extra-filters(+)] )
"
# autoconf-archive needed to eautoreconf
BDEPEND="
	sys-devel/autoconf-archive
	virtual/awk
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-python )
	!sys-devel/gcc[libffi(-)]
"
RDEPEND+="
	!build? ( app-misc/mime-types )
"
if [[ ${PV} != *_alpha* ]]; then
	RDEPEND+="
		dev-lang/python-exec[python_targets_python${PYVER/./_}(-)]
	"
fi

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/python.org.asc

# large file tests involve a 2.5G file being copied (duplicated)
CHECKREQS_DISK_BUILD=5500M

QA_PKGCONFIG_VERSION=${PYVER}

pkg_pretend() {
	use test && check-reqs_pkg_pretend
}

pkg_setup() {
	use test && check-reqs_pkg_setup
}

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.xz{,.asc}
	fi
	default
}

src_prepare() {
	# Ensure that internal copies of expat, libffi and zlib are not used.
	rm -fr Modules/expat || die
	rm -fr Modules/_ctypes/libffi* || die
	rm -fr Modules/zlib || die

	local PATCHES=(
		"${WORKDIR}/${PATCHSET}"
	)

	default

	# https://bugs.gentoo.org/850151
	sed -i -e "s:@@GENTOO_LIBDIR@@:$(get_libdir):g" setup.py || die

	# force correct number of jobs
	# https://bugs.gentoo.org/737660
	local jobs=$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")
	sed -i -e "s:-j0:-j${jobs}:" Makefile.pre.in || die
	sed -i -e "/self\.parallel/s:True:${jobs}:" setup.py || die

	eautoreconf
}

src_configure() {
	local disable
	# disable automagic bluetooth headers detection
	use bluetooth || export ac_cv_header_bluetooth_bluetooth_h=no

	append-flags -fwrapv

	filter-flags -malign-double

	# https://bugs.gentoo.org/700012
	if is-flagq -flto || is-flagq '-flto=*'; then
		append-cflags $(test-flags-CC -ffat-lto-objects)
	fi

	# Export CXX so it ends up in /usr/lib/python3.X/config/Makefile.
	# PKG_CONFIG needed for cross.
	tc-export CXX PKG_CONFIG

	# Fix implicit declarations on cross and prefix builds. Bug #674070.
	use ncurses && append-cppflags -I"${ESYSROOT}"/usr/include/ncursesw

	local dbmliborder
	if use gdbm; then
		dbmliborder+="${dbmliborder:+:}gdbm"
	fi

	if use pgo; then
		local jobs=$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")
		export PROFILE_TASK="-m test -j${jobs} --pgo-extended -x test_gdb -u-network"

		# All of these seem to occasionally hang for PGO inconsistently
		# They'll even hang here but be fine in src_test sometimes.
		# bug #828535 (and related: bug #788022)
		PROFILE_TASK+=" -x test_socket -x test_asyncio -x test_httpservers -x test_logging -x test_multiprocessing_fork -x test_xmlrpc"

		if has_version "app-arch/rpm" ; then
			# Avoid sandbox failure (attempts to write to /var/lib/rpm)
			PROFILE_TASK+=" -x test_distutils"
		fi
	fi

	local myeconfargs=(
		# glibc-2.30 removes it; since we can't cleanly force-rebuild
		# Python on glibc upgrade, remove it proactively to give
		# a chance for users rebuilding python before glibc
		ac_cv_header_stropts_h=no

		--enable-shared
		--without-static-libpython
		--enable-ipv6
		--infodir='${prefix}/share/info'
		--mandir='${prefix}/share/man'
		--with-computed-gotos
		--with-dbmliborder="${dbmliborder}"
		--with-libc=
		--enable-loadable-sqlite-extensions
		--without-ensurepip
		--with-system-expat
		--with-system-ffi
		--with-platlibdir=lib
		--with-pkg-config=yes

		$(use_with lto)
		$(use_enable pgo optimizations)
		$(use_with readline readline "$(usex libedit editline readline)")
	)

	# disable implicit optimization/debugging flags
	local -x OPT=
	# pass system CFLAGS & LDFLAGS as _NODIST, otherwise they'll get
	# propagated to sysconfig for built extensions
	local -x CFLAGS_NODIST=${CFLAGS}
	local -x LDFLAGS_NODIST=${LDFLAGS}
	local -x CFLAGS= LDFLAGS=

	if tc-is-cross-compiler ; then
		# We need to build our own Python on CBUILD first, and feed it in.
		# bug #847910
		local myeconfargs_cbuild=(
			"${myeconfargs[@]}"

			# As minimal as possible for the mini CBUILD Python
			# we build just for cross to satisfy --with-build-python.
			--without-lto
			--without-readline
			--disable-optimizations
		)

		myeconfargs+=(
			# Point the imminent CHOST build to the Python we just
			# built for CBUILD.
			--with-build-python="${WORKDIR}"/${P}-${CBUILD}/python
		)

		mkdir "${WORKDIR}"/${P}-${CBUILD} || die
		pushd "${WORKDIR}"/${P}-${CBUILD} &> /dev/null || die
		ECONF_SOURCE="${S}" econf_build "${myeconfargs_cbuild[@]}"

		# Avoid as many dependencies as possible for the cross build.
		cat >> Makefile <<-EOF || die
		MODULE_NIS_STATE=disabled
		MODULE__DBM_STATE=disabled
		MODULE__GDBM_STATE=disabled
		MODULE__DBM_STATE=disabled
		MODULE__SQLITE3_STATE=disabled
		MODULE__HASHLIB_STATE=disabled
		MODULE__SSL_STATE=disabled
		MODULE__CURSES_STATE=disabled
		MODULE__CURSES_PANEL_STATE=disabled
		MODULE_READLINE_STATE=disabled
		MODULE__TKINTER_STATE=disabled
		MODULE_PYEXPAT_STATE=disabled
		MODULE_ZLIB_STATE=disabled
		EOF

		# Unfortunately, we do have to build this immediately, and
		# not in src_compile, because CHOST configure for Python
		# will check the existence of the --with-build-python value
		# immediately.
		emake
		popd &> /dev/null || die
	fi

	econf "${myeconfargs[@]}"

	if grep -q "#define POSIX_SEMAPHORES_NOT_ENABLED 1" pyconfig.h; then
		eerror "configure has detected that the sem_open function is broken."
		eerror "Please ensure that /dev/shm is mounted as a tmpfs with mode 1777."
		die "Broken sem_open function (bug 496328)"
	fi

	# force-disable modules we don't want built
	local disable_modules=(
		NIS
	)
	use gdbm || disable_modules+=( _GDBM _DBM )
	use sqlite || disable_modules+=( _SQLITE3 )
	use ssl || disable_modules+=( _HASHLIB _SSL )
	use ncurses || disable_modules+=( _CURSES _CURSES_PANEL )
	use readline || disable_modules+=( READLINE )
	use tk || disable_modules+=( _TKINTER )

	local mod
	for mod in "${disable_modules[@]}"; do
		echo "MODULE_${mod}_STATE=disabled"
	done >> Makefile || die

	# install epython.py as part of stdlib
	echo "EPYTHON='python${PYVER}'" > Lib/epython.py || die
}

src_compile() {
	# Ensure sed works as expected
	# https://bugs.gentoo.org/594768
	local -x LC_ALL=C
	# Prevent using distutils bundled by setuptools.
	# https://bugs.gentoo.org/823728
	export SETUPTOOLS_USE_DISTUTILS=stdlib
	export PYTHONSTRICTEXTENSIONBUILD=1

	# Save PYTHONDONTWRITEBYTECODE so that 'has_version' doesn't
	# end up writing bytecode & violating sandbox.
	# bug #831897
	local -x _PYTHONDONTWRITEBYTECODE=${PYTHONDONTWRITEBYTECODE}

	if use pgo ; then
		# bug 660358
		local -x COLUMNS=80
		local -x PYTHONDONTWRITEBYTECODE=

		addpredict /usr/lib/python3.11/site-packages
	fi

	# also need to clear the flags explicitly here or they end up
	# in _sysconfigdata*
	emake CPPFLAGS= CFLAGS= LDFLAGS=

	# Restore saved value from above.
	local -x PYTHONDONTWRITEBYTECODE=${_PYTHONDONTWRITEBYTECODE}

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
	local skipped_tests="gdb"

	if use sparc ; then
		# bug #788022
		skipped_tests+=" multiprocessing_fork"
		skipped_tests+=" multiprocessing_forkserver"
	fi

	for test in ${skipped_tests}; do
		mv "${S}"/Lib/test/test_${test}.py "${T}"
	done

	# Expects to find skipped tests and fails
	mv "${S}"/Lib/test/test_tools/test_freeze.py "${T}" || die

	# bug 660358
	local -x COLUMNS=80
	local -x PYTHONDONTWRITEBYTECODE=
	# workaround https://bugs.gentoo.org/775416
	addwrite /usr/lib/python3.11/site-packages

	local jobs=$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")

	emake test EXTRATESTOPTS="-u-network -j${jobs}" \
		CPPFLAGS= CFLAGS= LDFLAGS= < /dev/tty
	local result=$?

	for test in ${skipped_tests}; do
		mv "${T}/test_${test}.py" "${S}"/Lib/test
	done

	mv "${T}"/test_freeze.py "${S}"/Lib/test/test_tools/test_freeze.py || die

	elog "The following tests have been skipped:"
	for test in ${skipped_tests}; do
		elog "test_${test}.py"
	done

	elog "If you would like to run them, you may:"
	elog "cd '${EPREFIX}/usr/lib/python${PYVER}/test'"
	elog "and run the tests separately."

	if [[ ${result} -ne 0 ]]; then
		die "emake test failed"
	fi
}

src_install() {
	local libdir=${ED}/usr/lib/python${PYVER}

	# -j1 hack for now for bug #843458
	emake -j1 DESTDIR="${D}" altinstall

	# Fix collisions between different slots of Python.
	rm "${ED}/usr/$(get_libdir)/libpython3.so" || die

	# Cheap hack to get version with ABIFLAGS
	local abiver=$(cd "${ED}/usr/include"; echo python*)
	if [[ ${abiver} != python${PYVER} ]]; then
		# Replace python3.X with a symlink to python3.Xm
		rm "${ED}/usr/bin/python${PYVER}" || die
		dosym "${abiver}" "/usr/bin/python${PYVER}"
		# Create python3.X-config symlink
		dosym "${abiver}-config" "/usr/bin/python${PYVER}-config"
		# Create python-3.5m.pc symlink
		dosym "python-${PYVER}.pc" "/usr/$(get_libdir)/pkgconfig/${abiver/${PYVER}/-${PYVER}}.pc"
	fi

	# python seems to get rebuilt in src_install (bug 569908)
	# Work around it for now.
	if has_version dev-libs/libffi[pax-kernel]; then
		pax-mark E "${ED}/usr/bin/${abiver}"
	else
		pax-mark m "${ED}/usr/bin/${abiver}"
	fi

	use sqlite || rm -r "${libdir}/"sqlite3 || die
	use tk || rm -r "${ED}/usr/bin/idle${PYVER}" "${libdir}/"{idlelib,tkinter,test/test_tk*} || die

	dodoc Misc/{ACKS,HISTORY,NEWS}

	if use examples; then
		docinto examples
		find Tools -name __pycache__ -exec rm -fr {} + || die
		dodoc -r Tools
	fi
	insinto /usr/share/gdb/auto-load/usr/$(get_libdir) #443510
	local libname=$(printf 'e:\n\t@echo $(INSTSONAME)\ninclude Makefile\n' | \
		emake --no-print-directory -s -f - 2>/dev/null)
	newins "${S}"/Tools/gdb/libpython.py "${libname}"-gdb.py

	newconfd "${FILESDIR}/pydoc.conf" pydoc-${PYVER}
	newinitd "${FILESDIR}/pydoc.init" pydoc-${PYVER}
	sed \
		-e "s:@PYDOC_PORT_VARIABLE@:PYDOC${PYVER/./_}_PORT:" \
		-e "s:@PYDOC@:pydoc${PYVER}:" \
		-i "${ED}/etc/conf.d/pydoc-${PYVER}" \
		"${ED}/etc/init.d/pydoc-${PYVER}" || die "sed failed"

	# python-exec wrapping support
	local pymajor=${PYVER%.*}
	local EPYTHON=python${PYVER}
	local scriptdir=${D}$(python_get_scriptdir)
	mkdir -p "${scriptdir}" || die
	# python and pythonX
	ln -s "../../../bin/${abiver}" \
		"${scriptdir}/python${pymajor}" || die
	ln -s "python${pymajor}" "${scriptdir}/python" || die
	# python-config and pythonX-config
	# note: we need to create a wrapper rather than symlinking it due
	# to some random dirname(argv[0]) magic performed by python-config
	cat > "${scriptdir}/python${pymajor}-config" <<-EOF || die
		#!/bin/sh
		exec "${abiver}-config" "\${@}"
	EOF
	chmod +x "${scriptdir}/python${pymajor}-config" || die
	ln -s "python${pymajor}-config" \
		"${scriptdir}/python-config" || die
	# 2to3, pydoc
	ln -s "../../../bin/2to3-${PYVER}" \
		"${scriptdir}/2to3" || die
	ln -s "../../../bin/pydoc${PYVER}" \
		"${scriptdir}/pydoc" || die
	# idle
	if use tk; then
		ln -s "../../../bin/idle${PYVER}" \
			"${scriptdir}/idle" || die
	fi
}

pkg_postinst() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		if ver_test "${v}" -lt 3.11.0_beta4-r2; then
			ewarn "Python 3.11.0b4 has changed its module ABI.  The .pyc files"
			ewarn "installed previously are no longer valid and will be regenerated"
			ewarn "(or ignored) on the next import.  This may cause sandbox failures"
			ewarn "when installing some packages and checksum mismatches when removing"
			ewarn "old versions.  To actively prevent this, rebuild all packages"
			ewarn "installing Python 3.11 modules, e.g. using:"
			ewarn
			ewarn "  emerge -1v /usr/lib/python3.11/site-packages"
		fi
	done
}
