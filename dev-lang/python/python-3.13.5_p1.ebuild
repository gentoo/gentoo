# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

LLVM_COMPAT=( 18 )
LLVM_OPTIONAL=1
WANT_LIBTOOL="none"

inherit autotools check-reqs flag-o-matic linux-info llvm-r1
inherit multiprocessing pax-utils python-utils-r1 toolchain-funcs
inherit verify-sig

MY_PV=${PV}
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
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="
	bluetooth debug +ensurepip examples gdbm jit libedit +ncurses pgo
	+readline +sqlite +ssl test tk valgrind
"
REQUIRED_USE="jit? ( ${LLVM_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

# Do not add a dependency on dev-lang/python to this ebuild.
# If you need to apply a patch which requires python for bootstrapping, please
# run the bootstrap code on your dev box and include the results in the
# patchset. See bug 447752.

RDEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	app-crypt/libb2
	app-misc/mime-types
	>=dev-libs/expat-2.1:=
	dev-libs/libffi:=
	dev-libs/mpdecimal:=
	dev-python/gentoo-common
	>=sys-libs/zlib-1.1.3:=
	virtual/libintl
	gdbm? ( sys-libs/gdbm:=[berkdb] )
	kernel_linux? ( sys-apps/util-linux:= )
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
"
# bluetooth requires headers from bluez
DEPEND="
	${RDEPEND}
	bluetooth? ( net-wireless/bluez )
	test? (
		dev-python/ensurepip-pip
		dev-python/ensurepip-setuptools
	)
	valgrind? ( dev-debug/valgrind )
"
# autoconf-archive needed to eautoreconf
BDEPEND="
	dev-build/autoconf-archive
	app-alternatives/awk
	virtual/pkgconfig
	jit? (
		$(llvm_gen_dep '
			llvm-core/clang:${LLVM_SLOT}
			llvm-core/llvm:${LLVM_SLOT}
		')
	)
	verify-sig? ( >=sec-keys/openpgp-keys-python-20221025 )
"
if [[ ${PV} != *_alpha* ]]; then
	RDEPEND+="
		dev-lang/python-exec[python_targets_python${PYVER/./_}(-)]
	"
fi
PDEPEND="
	ensurepip? ( dev-python/ensurepip-pip )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/python.org.asc

# large file tests involve a 2.5G file being copied (duplicated)
CHECKREQS_DISK_BUILD=5500M

QA_PKGCONFIG_VERSION=${PYVER}
# false positives -- functions specific to *BSD
QA_CONFIG_IMPL_DECL_SKIP=( chflags lchflags )

declare -rgA PYTHON_KERNEL_CHECKS=(
	["CROSS_MEMORY_ATTACH"]="test_external_inspection" #bug 938589
	["DNOTIFY"]="test_fcntl" # bug 938662
)

pkg_pretend() {
	if use pgo || use test; then
		check-reqs_pkg_pretend
	fi

	if use jit; then
		ewarn "USE=jit is considered experimental upstream.  Using it"
		ewarn "could lead to unexpected breakage, including race conditions"
		ewarn "and crashes, respectively.  Please do not file Gentoo bugs, unless"
		ewarn "you can reproduce the problem with dev-lang/python[-jit].  Instead,"
		ewarn "please consider reporting JIT problems upstream."
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		use jit && llvm-r1_pkg_setup
		if use test || use pgo; then
			check-reqs_pkg_setup

			local CONFIG_CHECK
			for f in "${!PYTHON_KERNEL_CHECKS[@]}"; do
				CONFIG_CHECK+="~${f} "
			done
			linux-info_pkg_setup
		fi
	fi
}

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.xz{,.asc}
	fi
	default
}

src_prepare() {
	# Ensure that internal copies of expat and libffi are not used.
	# TODO: Makefile has annoying deps on expat headers
	#rm -r Modules/expat || die

	local PATCHES=(
		"${WORKDIR}/${PATCHSET}"
	)

	default

	# force the correct number of jobs
	# https://bugs.gentoo.org/737660
	sed -i -e "s:-j0:-j$(makeopts_jobs):" Makefile.pre.in || die

	# breaks tests when using --with-wheel-pkg-dir
	rm -r Lib/test/wheeldata || die

	eautoreconf
}

build_cbuild_python() {
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
	# bug #847910
	local myeconfargs_cbuild=(
		"${myeconfargs[@]}"

		--prefix="${BROOT}"/usr
		--libdir="${cbuild_libdir:2}"

		# Avoid needing to load the right libpython.so.
		--disable-shared

		# As minimal as possible for the mini CBUILD Python
		# we build just for cross to satisfy --with-build-python.
		--without-lto
		--without-readline
		--disable-optimizations
	)

	mkdir "${WORKDIR}"/${P}-${CBUILD} || die
	pushd "${WORKDIR}"/${P}-${CBUILD} &> /dev/null || die

	# Avoid as many dependencies as possible for the cross build.
	mkdir Modules || die
	cat > Modules/Setup.local <<-EOF || die
		*disabled*
		nis
		_dbm _gdbm
		_sqlite3
		_hashlib _ssl
		_curses _curses_panel
		readline
		_tkinter
		pyexpat
		zlib
		# We disabled these for CBUILD because Python's setup.py can't handle locating
		# libdir correctly for cross. This should be rechecked for the pure Makefile approach,
		# and uncommented if needed.
		#_ctypes
	EOF

	ECONF_SOURCE="${S}" econf_build "${myeconfargs_cbuild[@]}"

	# Unfortunately, we do have to build this immediately, and
	# not in src_compile, because CHOST configure for Python
	# will check the existence of the --with-build-python value
	# immediately.
	emake
	popd &> /dev/null || die
}

src_configure() {
	# disable automagic bluetooth headers detection
	if ! use bluetooth; then
		local -x ac_cv_header_bluetooth_bluetooth_h=no
	fi

	filter-flags -malign-double

	# Export CXX so it ends up in /usr/lib/python3.X/config/Makefile.
	# PKG_CONFIG needed for cross.
	tc-export CXX PKG_CONFIG

	local dbmliborder=
	if use gdbm; then
		dbmliborder+="${dbmliborder:+:}gdbm"
	fi

	# Set baseline test skip flags.
	COMMON_TEST_SKIPS=(
		# this is actually test_gdb.test_pretty_print
		-x test_pretty_print
		# https://bugs.gentoo.org/933840
		-x test_perf_profiler
	)

	# Arch-specific skips.  See #931888 for a collection of these.
	case ${CHOST} in
		alpha*)
			COMMON_TEST_SKIPS+=(
				-x test_builtin
				-x test_capi
				-x test_cmath
				-x test_float
				# timeout
				-x test_free_threading
				-x test_math
				-x test_numeric_tower
				-x test_random
				-x test_statistics
				# bug 653850
				-x test_resource
				-x test_strtod
			)
			;;
		arm*)
			COMMON_TEST_SKIPS+=(
				-x test_gdb
			)
			;;
		hppa*)
			COMMON_TEST_SKIPS+=(
				-x test_gdb
			)
			;;
		mips*)
			COMMON_TEST_SKIPS+=(
				-x test_ctypes
				-x test_external_inspection
				-x test_statistics
			)
			;;
		powerpc64-*) # big endian
			COMMON_TEST_SKIPS+=(
				-x test_gdb
			)
			;;
		riscv*)
			COMMON_TEST_SKIPS+=(
				-x test_urllib2
			)
			;;
		sparc*)
			COMMON_TEST_SKIPS+=(
				# bug 788022
				-x test_multiprocessing_fork
				-x test_multiprocessing_forkserver
				-x test_multiprocessing_spawn

				-x test_ctypes
				-x test_gdb
				# bug 931908
				-x test_exceptions
			)
			;;
	esac

	# Kernel-config specific skips
	for option in "${!PYTHON_KERNEL_CHECKS[@]}"; do
		if ! linux_config_exists || ! linux_chkconfig_present "${option}"
		then
			COMMON_TEST_SKIPS+=( -x "${PYTHON_KERNEL_CHECKS[${option}]}" )
		fi
	done

	# musl-specific skips
	use elibc_musl && COMMON_TEST_SKIPS+=(
		# various musl locale deficiencies
		-x test__locale
		-x test_c_locale_coercion
		-x test_locale
		-x test_re

		# known issues with find_library on musl
		# https://bugs.python.org/issue21622
		-x test_ctypes

		# fpathconf, ttyname errno values
		-x test_os
	)

	if use pgo; then
		local profile_task_flags=(
			-m test
			"-j$(makeopts_jobs)"
			--pgo-extended
			--verbose3
			-u-network

			# We use a timeout because of how often we've had hang issues
			# here. It also matches the default upstream PROFILE_TASK.
			--timeout 1200

			"${COMMON_TEST_SKIPS[@]}"

			-x test_dtrace

			# All of these seem to occasionally hang for PGO inconsistently
			# They'll even hang here but be fine in src_test sometimes.
			# bug #828535 (and related: bug #788022)
			-x test_asyncio
			-x test_httpservers
			-x test_logging
			-x test_multiprocessing_fork
			-x test_socket
			-x test_xmlrpc

			# Hangs (actually runs indefinitely executing itself w/ many cpython builds)
			# bug #900429
			-x test_tools
		)

		if has_version "app-arch/rpm" ; then
			# Avoid sandbox failure (attempts to write to /var/lib/rpm)
			profile_task_flags+=(
				-x test_distutils
			)
		fi
		# PGO sometimes fails randomly
		local -x PROFILE_TASK="${profile_task_flags[*]} || true"
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
		--with-dbmliborder="${dbmliborder}"
		--with-libc=
		--enable-loadable-sqlite-extensions
		--without-ensurepip
		--without-lto
		--with-system-expat
		--with-system-libmpdec
		--with-platlibdir=lib
		--with-pkg-config=yes
		--with-wheel-pkg-dir="${EPREFIX}"/usr/lib/python/ensurepip
		--enable-gil

		$(use_with debug assertions)
		$(use_enable jit experimental-jit)
		$(use_enable pgo optimizations)
		$(use_with readline readline "$(usex libedit editline readline)")
		$(use_with valgrind)
	)

	if tc-is-lto; then
		myeconfargs+=(
			--with-lto
		)
	fi

	# Force-disable modules we don't want built.
	# See Modules/Setup for docs on how this works. Setup.local contains our local deviations.
	cat > Modules/Setup.local <<-EOF || die
		*disabled*
		nis
		$(usev !gdbm '_gdbm _dbm')
		$(usev !sqlite '_sqlite3')
		$(usev !ssl '_hashlib _ssl')
		$(usev !ncurses '_curses _curses_panel')
		$(usev !readline 'readline')
		$(usev !tk '_tkinter')
	EOF

	# disable implicit optimization/debugging flags
	local -x OPT=

	if tc-is-cross-compiler ; then
		build_cbuild_python
		myeconfargs+=(
			# Point the imminent CHOST build to the Python we just
			# built for CBUILD.
			--with-build-python="${WORKDIR}"/${P}-${CBUILD}/python
		)
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
	export PYTHONSTRICTEXTENSIONBUILD=1

	# Save PYTHONDONTWRITEBYTECODE so that 'has_version' doesn't
	# end up writing bytecode & violating sandbox.
	# bug #831897
	local -x _PYTHONDONTWRITEBYTECODE=${PYTHONDONTWRITEBYTECODE}

	# Gentoo hack to disable accessing system site-packages
	export GENTOO_CPYTHON_BUILD=1

	if use pgo ; then
		# bug 660358
		local -x COLUMNS=80
		local -x PYTHONDONTWRITEBYTECODE=
		local -x TMPDIR=/var/tmp
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

	# this just happens to skip test_support.test_freeze that is broken
	# without bundled expat
	# TODO: get a proper skip for it upstream
	local -x LOGNAME=buildbot

	local test_opts=(
		--verbose3
		-u-network
		-j "$(makeopts_jobs)"
		"${COMMON_TEST_SKIPS[@]}"
	)

	# bug 660358
	local -x COLUMNS=80
	local -x PYTHONDONTWRITEBYTECODE=
	local -x TMPDIR=/var/tmp

	nonfatal emake -Onone test EXTRATESTOPTS="${test_opts[*]}" \
		CPPFLAGS= CFLAGS= LDFLAGS= < /dev/tty
	local ret=${?}

	[[ ${ret} -eq 0 ]] || die "emake test failed"
}

src_install() {
	local libdir=${ED}/usr/lib/python${PYVER}

	# -j1 hack for now for bug #843458
	emake -j1 DESTDIR="${D}" TEST_MODULES=no altinstall

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
	if ! use sqlite; then
		rm -r "${libdir}/"sqlite3 || die
	fi
	if ! use tk; then
		rm -r "${ED}/usr/bin/idle${PYVER}" || die
		rm -r "${libdir}/"{idlelib,tkinter} || die
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
	# pydoc
	ln -s "../../../bin/pydoc${PYVER}" "${scriptdir}/pydoc" || die
	# idle
	if use tk; then
		ln -s "../../../bin/idle${PYVER}" "${scriptdir}/idle" || die
	fi
}
