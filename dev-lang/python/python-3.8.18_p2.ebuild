# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
WANT_LIBTOOL="none"

inherit autotools flag-o-matic multiprocessing pax-utils
inherit prefix python-utils-r1 toolchain-funcs verify-sig

MY_PV=${PV/_rc/rc}
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
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="
	bluetooth build debug +ensurepip examples gdbm +ncurses pgo
	+readline +sqlite +ssl test tk valgrind
"
RESTRICT="!test? ( test )"

# Do not add a dependency on dev-lang/python to this ebuild.
# If you need to apply a patch which requires python for bootstrapping, please
# run the bootstrap code on your dev box and include the results in the
# patchset. See bug 447752.

RDEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	>=dev-libs/expat-2.1:=
	dev-libs/libffi:=
	dev-python/gentoo-common
	>=sys-libs/zlib-1.1.3:=
	virtual/libcrypt:=
	virtual/libintl
	ensurepip? ( dev-python/ensurepip-wheels )
	gdbm? ( sys-libs/gdbm:=[berkdb] )
	kernel_linux? ( sys-apps/util-linux:= )
	ncurses? ( >=sys-libs/ncurses-5.2:= )
	readline? ( >=sys-libs/readline-4.1:= )
	sqlite? ( >=dev-db/sqlite-3.3.8:3= )
	ssl? ( >=dev-libs/openssl-1.1.1:= )
	tk? (
		>=dev-lang/tcl-8.0:=
		>=dev-lang/tk-8.0:=
		dev-tcltk/blt:=
		dev-tcltk/tix
	)
"
# bluetooth requires headers from bluez
DEPEND="
	${RDEPEND}
	bluetooth? ( net-wireless/bluez )
	test? ( app-arch/xz-utils )
	valgrind? ( dev-debug/valgrind )
"
# autoconf-archive needed to eautoreconf
BDEPEND="
	dev-build/autoconf-archive
	app-alternatives/awk
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-python )
"
RDEPEND+="
	!build? ( app-misc/mime-types )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/python.org.asc

QA_PKGCONFIG_VERSION=${PYVER}
# false positives -- functions specific to *BSD
QA_CONFIG_IMPL_DECL_SKIP=( chflags lchflags )

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.xz{,.asc}
	fi
	default
}

src_prepare() {
	# Ensure that internal copies of expat and libffi are not used.
	rm -r Modules/expat || die
	rm -r Modules/_ctypes/libffi* || die

	local PATCHES=(
		"${WORKDIR}/${PATCHSET}"
	)

	default

	# https://bugs.gentoo.org/850151
	sed -i -e "s:@@GENTOO_LIBDIR@@:$(get_libdir):g" setup.py || die

	# force the correct number of jobs
	# https://bugs.gentoo.org/737660
	local jobs=$(makeopts_jobs)
	sed -i -e "s:-j0:-j${jobs}:" Makefile.pre.in || die
	sed -i -e "/self\.parallel/s:True:${jobs}:" setup.py || die

	rm Lib/distutils/command/wininst*.exe || die

	eautoreconf
}

src_configure() {
	# disable automagic bluetooth headers detection
	if ! use bluetooth; then
		local -x ac_cv_header_bluetooth_bluetooth_h=no
	fi
	local disable
	use gdbm      || disable+=" gdbm"
	use ncurses   || disable+=" _curses _curses_panel"
	use readline  || disable+=" readline"
	use sqlite    || disable+=" _sqlite3"
	use ssl       || export PYTHON_DISABLE_SSL="1"
	use tk        || disable+=" _tkinter"
	export PYTHON_DISABLE_MODULES="${disable}"

	if [[ -n "${PYTHON_DISABLE_MODULES}" ]]; then
		einfo "Disabled modules: ${PYTHON_DISABLE_MODULES}"
	fi

	append-flags -fwrapv
	filter-flags -malign-double

	# Export CXX so it ends up in /usr/lib/python3.X/config/Makefile.
	# PKG_CONFIG needed for cross.
	tc-export CXX PKG_CONFIG

	local dbmliborder=
	if use gdbm; then
		dbmliborder+="${dbmliborder:+:}gdbm"
	fi

	local myeconfargs=(
		# glibc-2.30 removes it; since we can't cleanly force-rebuild
		# Python on glibc upgrade, remove it proactively to give
		# a chance for users rebuilding python before glibc
		ac_cv_header_stropts_h=no

		--enable-shared
		--enable-ipv6
		--infodir='${prefix}/share/info'
		--mandir='${prefix}/share/man'
		--with-computed-gotos
		--with-dbmliborder="${dbmliborder}"
		--with-libc=
		--enable-loadable-sqlite-extensions
		--without-ensurepip
		--without-lto
		--with-system-expat
		--with-system-ffi
		--with-wheel-pkg-dir="${EPREFIX}"/usr/lib/python/ensurepip

		$(use_with debug assertions)
		$(use_with valgrind)
	)

	# disable implicit optimization/debugging flags
	local -x OPT=

	# https://bugs.gentoo.org/700012
	if tc-is-lto; then
		append-cflags $(test-flags-CC -ffat-lto-objects)
		myeconfargs+=(
			--with-lto
		)
	fi

	if tc-is-cross-compiler ; then
		# Hack to workaround get_libdir not being able to handle CBUILD, bug #794181
		local cbuild_libdir=$(unset PKG_CONFIG_PATH ; $(tc-getBUILD_PKG_CONFIG) --keep-system-libs --libs-only-L libffi)

		# pass system CFLAGS & LDFLAGS as _NODIST, otherwise they'll get
		# propagated to sysconfig for built extensions
		#
		# -fno-lto to avoid bug #700012 (not like it matters for mini-CBUILD Python anyway)
		local -x CFLAGS_NODIST="${BUILD_CFLAGS} -fno-lto"
		local -x LDFLAGS_NODIST=${BUILD_LDFLAGS}
		local -x CFLAGS= LDFLAGS=
		local -x BUILD_CFLAGS="${CFLAGS_NODIST}"
		local -x BUILD_LDFLAGS=${LDFLAGS_NODIST}

		# We need to build our own Python on CBUILD first, and feed it in.
		# bug #847910 and bug #864911.
		local myeconfargs_cbuild=(
			"${myeconfargs[@]}"

			--libdir="${cbuild_libdir:2}"

			# Avoid needing to load the right libpython.so.
			--disable-shared

			# As minimal as possible for the mini CBUILD Python
			# we build just for cross.
			--without-lto
			--disable-optimizations
		)

		# Point the imminent CHOST build to the Python we just
		# built for CBUILD.
		export PATH="${WORKDIR}/${P}-${CBUILD}:${PATH}"

		mkdir "${WORKDIR}"/${P}-${CBUILD} || die
		pushd "${WORKDIR}"/${P}-${CBUILD} &> /dev/null || die
		# We disable _ctypes and _crypt for CBUILD because Python's setup.py can't handle locating
		# libdir correctly for cross.
		PYTHON_DISABLE_MODULES="${PYTHON_DISABLE_MODULES} _ctypes _crypt" \
			ECONF_SOURCE="${S}" econf_build "${myeconfargs_cbuild[@]}"

		# Avoid as many dependencies as possible for the cross build.
		cat >> Makefile <<-EOF || die
			MODULE_NIS=disabled
			MODULE__DBM=disabled
			MODULE__GDBM=disabled
			MODULE__DBM=disabled
			MODULE__SQLITE3=disabled
			MODULE__HASHLIB=disabled
			MODULE__SSL=disabled
			MODULE__CURSES=disabled
			MODULE__CURSES_PANEL=disabled
			MODULE_READLINE=disabled
			MODULE__TKINTER=disabled
			MODULE_PYEXPAT=disabled
			MODULE_ZLIB=disabled
		EOF

		# Unfortunately, we do have to build this immediately, and
		# not in src_compile, because CHOST configure for Python
		# will check the existence of the Python it was pointed to
		# immediately.
		PYTHON_DISABLE_MODULES="${PYTHON_DISABLE_MODULES} _ctypes _crypt" emake
		popd &> /dev/null || die
	fi

	# pass system CFLAGS & LDFLAGS as _NODIST, otherwise they'll get
	# propagated to sysconfig for built extensions
	local -x CFLAGS_NODIST=${CFLAGS}
	local -x LDFLAGS_NODIST=${LDFLAGS}
	local -x CFLAGS= LDFLAGS=

	# Fix implicit declarations on cross and prefix builds. Bug #674070.
	if use ncurses; then
		append-cppflags -I"${ESYSROOT}"/usr/include/ncursesw
	fi

	hprefixify setup.py
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
	# Prevent using distutils bundled by setuptools.
	# https://bugs.gentoo.org/823728
	export SETUPTOOLS_USE_DISTUTILS=stdlib

	# also need to clear the flags explicitly here or they end up
	# in _sysconfigdata*
	emake CPPFLAGS= CFLAGS= LDFLAGS=

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

	local test_opts=(
		-u-network
		-j "$(makeopts_jobs)"

		# fails
		-x test_gdb
	)

	if use sparc ; then
		# bug #788022
		test_opts+=(
			-x test_multiprocessing_fork
			-x test_multiprocessing_forkserver
		)
	fi

	# workaround docutils breaking tests
	cat > Lib/docutils.py <<-EOF || die
		raise ImportError("Thou shalt not import!")
	EOF

	# bug 660358
	local -x COLUMNS=80
	local -x PYTHONDONTWRITEBYTECODE=

	nonfatal emake -Onone test EXTRATESTOPTS="${test_opts[*]}" \
		CPPFLAGS= CFLAGS= LDFLAGS= < /dev/tty
	local ret=${?}

	rm Lib/docutils.py || die

	[[ ${ret} -eq 0 ]] || die "emake test failed"
}

src_install() {
	local libdir=${ED}/usr/lib/python${PYVER}

	emake DESTDIR="${D}" altinstall

	# Remove static library
	rm "${ED}"/usr/$(get_libdir)/libpython*.a || die

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

	rm -r "${libdir}"/ensurepip/_bundled || die
	if ! use ensurepip; then
		rm -r "${libdir}"/ensurepip || die
	fi
	if ! use sqlite; then
		rm -r "${libdir}/"{sqlite3,test/test_sqlite*} || die
	fi
	if ! use tk; then
		rm -r "${ED}/usr/bin/idle${PYVER}" || die
		rm -r "${libdir}/"{idlelib,tkinter,test/test_tk*} || die
	fi

	ln -s ../python/EXTERNALLY-MANAGED "${libdir}/EXTERNALLY-MANAGED" || die

	dodoc Misc/{ACKS,HISTORY,NEWS}

	if use examples; then
		docinto examples
		find Tools -name __pycache__ -exec rm -fr {} + || die
		dodoc -r Tools
	fi
	insinto /usr/share/gdb/auto-load/usr/$(get_libdir) #443510
	local libname=$(
		printf 'e:\n\t@echo $(INSTSONAME)\ninclude Makefile\n' |
		emake --no-print-directory -s -f - 2>/dev/null
	)
	newins Tools/gdb/libpython.py "${libname}"-gdb.py

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
	ln -s "../../../bin/${abiver}" "${scriptdir}/python${pymajor}" || die
	ln -s "python${pymajor}" "${scriptdir}/python" || die
	# python-config and pythonX-config
	# note: we need to create a wrapper rather than symlinking it due
	# to some random dirname(argv[0]) magic performed by python-config
	cat > "${scriptdir}/python${pymajor}-config" <<-EOF || die
		#!/bin/sh
		exec "${abiver}-config" "\${@}"
	EOF
	chmod +x "${scriptdir}/python${pymajor}-config" || die
	ln -s "python${pymajor}-config" "${scriptdir}/python-config" || die
	# 2to3, pydoc
	ln -s "../../../bin/2to3-${PYVER}" "${scriptdir}/2to3" || die
	ln -s "../../../bin/pydoc${PYVER}" "${scriptdir}/pydoc" || die
	# idle
	if use tk; then
		ln -s "../../../bin/idle${PYVER}" "${scriptdir}/idle" || die
	fi
}
