# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pax-utils python-utils-r1 unpacker versionator

BINHOST="https://dev.gentoo.org/~mgorny/dist/pypy-bin/${PV}.ffi7.ossl11"
BINHOST_LIBRESSL="https://dev.gentoo.org/~mgorny/dist/pypy-bin/${PV}.ffi7"
CPY_PATCHSET_VERSION="2.7.14-0"
MY_P=pypy2-v${PV}

DESCRIPTION="Pre-built version of PyPy"
HOMEPAGE="http://pypy.org/"
SRC_URI="https://bitbucket.org/pypy/pypy/downloads/${MY_P}-src.tar.bz2
	https://dev.gentoo.org/~floppym/python-gentoo-patches-${CPY_PATCHSET_VERSION}.tar.xz
	amd64? (
		!libressl? (
			jit? ( ${BINHOST}/${P}-amd64+bzip2+jit+ncurses.ffi7.ossl11.tar.lz )
			!jit? ( ${BINHOST}/${P}-amd64+bzip2+ncurses.ffi7.ossl11.tar.lz )
		)
		libressl? (
			jit? ( ${BINHOST_LIBRESSL}/${P}-amd64+bzip2+jit+libressl+ncurses.ffi7.tar.lz )
			!jit? ( ${BINHOST_LIBRESSL}/${P}-amd64+bzip2+libressl+ncurses.ffi7.tar.lz )
		)
	)
	x86? (
		!libressl? (
			cpu_flags_x86_sse2? (
				jit? ( ${BINHOST}/${P}-x86+bzip2+jit+ncurses+sse2.ffi7.ossl11.tar.lz )
				!jit? ( ${BINHOST}/${P}-x86+bzip2+ncurses+sse2.ffi7.ossl11.tar.lz )
			)
			!cpu_flags_x86_sse2? (
				!jit? ( ${BINHOST}/${P}-x86+bzip2+ncurses.ffi7.ossl11.tar.lz )
			)
		)
		libressl? (
			cpu_flags_x86_sse2? (
				jit? ( ${BINHOST_LIBRESSL}/${P}-x86+bzip2+jit+libressl+ncurses+sse2.ffi7.tar.lz )
				!jit? ( ${BINHOST_LIBRESSL}/${P}-x86+bzip2+libressl+ncurses+sse2.ffi7.tar.lz )
			)
			!cpu_flags_x86_sse2? (
				!jit? ( ${BINHOST_LIBRESSL}/${P}-x86+bzip2+libressl+ncurses.ffi7.tar.lz )
			)
		)
	)"

# Supported variants
REQUIRED_USE="x86? ( !cpu_flags_x86_sse2? ( !jit ) )"

LICENSE="MIT"
# pypy -c 'import sysconfig; print sysconfig.get_config_var("SOABI")'
SLOT="0/41"
KEYWORDS="~amd64 ~x86"
IUSE="gdbm +jit libressl sqlite cpu_flags_x86_sse2 test tk"

RDEPEND="
	app-arch/bzip2:0/1
	dev-libs/expat:0/0
	dev-libs/libffi:0/7
	sys-devel/gcc:*
	sys-libs/glibc
	sys-libs/ncurses:0/6
	sys-libs/zlib:0/1
	gdbm? ( sys-libs/gdbm:0= )
	!libressl? ( dev-libs/openssl:0/1.1[-bindist] )
	libressl? ( dev-libs/libressl:0/44 )
	sqlite? ( dev-db/sqlite:3= )
	tk? (
		dev-lang/tk:0=
		dev-tcltk/tix:0=
	)
	!dev-python/pypy:0"
DEPEND="${RDEPEND}
	app-arch/lzip
	app-arch/xz-utils"

S=${WORKDIR}/${MY_P}-src

QA_PREBUILT="
	usr/lib*/pypy/pypy-c
	usr/lib*/pypy/libpypy-c.so"

src_prepare() {
	eapply "${FILESDIR}/4.0.0-gentoo-path.patch"
	eapply "${FILESDIR}/1.9-distutils.unixccompiler.UnixCCompiler.runtime_library_dir_option.patch"

	sed -e "s^@EPREFIX@^${EPREFIX}^" \
		-e "s^@libdir@^$(get_libdir)^" \
		-i lib-python/2.7/distutils/command/install.py || die

	# apply CPython stdlib patches
	pushd lib-python/2.7 > /dev/null || die
	# TODO: cpy turkish locale patch now fixes C code
	# probably needs better port to pypy, if it is broken there
	eapply "${FILESDIR}"/5.8.0_all_distutils_cxx.patch
	eapply "${WORKDIR}"/patches/62_all_xml.use_pyxml.patch
	popd > /dev/null || die

	eapply_user
}

src_compile() {
	# Tadaam! PyPy compiled!
	mv "${WORKDIR}"/${P}*/{libpypy-c.so,pypy-c} . || die
	mv "${WORKDIR}"/${P}*/include/*.h include/ || die
	# (not installed by pypy)
	rm pypy/module/cpyext/include/_numpypy/numpy/README || die
	mv pypy/module/cpyext/include/* include/ || die
	mv pypy/module/cpyext/parse/*.h include/ || die

	pax-mark m pypy-c libpypy-c.so

	einfo "Generating caches and CFFI modules ..."

	# Generate Grammar and PatternGrammar pickles.
	./pypy-c -c "import lib2to3.pygram, lib2to3.patcomp; lib2to3.patcomp.PatternCompiler()" \
		|| die "Generation of Grammar and PatternGrammar pickles failed"

	# Generate cffi modules
	# Please keep in sync with pypy/tool/build_cffi_imports.py!
#cffi_build_scripts = {
#    "sqlite3": "_sqlite3_build.py",
#    "audioop": "_audioop_build.py",
#    "tk": "_tkinter/tklib_build.py",
#    "curses": "_curses_build.py" if sys.platform != "win32" else None,
#    "syslog": "_syslog_build.py" if sys.platform != "win32" else None,
#    "gdbm": "_gdbm_build.py"  if sys.platform != "win32" else None,
#    "pwdgrp": "_pwdgrp_build.py" if sys.platform != "win32" else None,
#    "resource": "_resource_build.py" if sys.platform != "win32" else None,
	cffi_targets=( audioop curses syslog pwdgrp resource )
	use gdbm && cffi_targets+=( gdbm )
	use sqlite && cffi_targets+=( sqlite3 )
	use tk && cffi_targets+=( tkinter/tklib )

	local t
	# all modules except tkinter output to .
	# tkinter outputs to the correct dir ...
	cd lib_pypy || die
	for t in "${cffi_targets[@]}"; do
		# tkinter doesn't work via -m
		../pypy-c "_${t}_build.py" || die "Failed to build CFFI bindings for ${t}"
	done

	# Cleanup temporary objects
	find -name "_cffi_*.[co]" -delete || die
	find -type d -empty -delete || die
}

src_test() {
	# (unset)
	local -x PYTHONDONTWRITEBYTECODE=

	local ignored_tests=(
		# network
		--ignore=lib-python/2.7/test/test_urllibnet.py
		--ignore=lib-python/2.7/test/test_urllib2net.py
		# lots of free space
		--ignore=lib-python/2.7/test/test_zipfile64.py
		# no module named 'worker' -- a lot
		--ignore=lib-python/2.7/test/test_xpickle.py
	)

	./pypy-c ./pypy/test_all.py --pypy=./pypy-c -vv \
		"${ignored_tests[@]}" lib-python || die
}

src_install() {
	local dest=/usr/$(get_libdir)/pypy
	einfo "Installing PyPy ..."
	exeinto "${dest}"
	doexe pypy-c libpypy-c.so
	pax-mark m "${ED%/}${dest}/pypy-c" "${ED%/}${dest}/libpypy-c.so"
	insinto "${dest}"
	# preserve mtimes to avoid obsoleting caches
	insopts -p
	doins -r include lib_pypy lib-python
	dosym ../$(get_libdir)/pypy/pypy-c /usr/bin/pypy
	dodoc README.rst

	if ! use gdbm; then
		rm -r "${ED%/}${dest}"/lib_pypy/gdbm.py \
			"${ED%/}${dest}"/lib-python/*2.7/test/test_gdbm.py || die
	fi
	if ! use sqlite; then
		rm -r "${ED%/}${dest}"/lib-python/*2.7/sqlite3 \
			"${ED%/}${dest}"/lib_pypy/_sqlite3.py \
			"${ED%/}${dest}"/lib-python/*2.7/test/test_sqlite.py || die
	fi
	if ! use tk; then
		rm -r "${ED%/}${dest}"/lib-python/*2.7/{idlelib,lib-tk} \
			"${ED%/}${dest}"/lib_pypy/_tkinter \
			"${ED%/}${dest}"/lib-python/*2.7/test/test_{tcl,tk,ttk*}.py || die
	fi

	local -x PYTHON=${ED%/}${dest}/pypy-c
	# we can't use eclass function since PyPy is dumb and always gives
	# paths relative to the interpreter
	local PYTHON_SITEDIR=${EPREFIX}/usr/$(get_libdir)/pypy/site-packages
	python_export pypy EPYTHON

	echo "EPYTHON='${EPYTHON}'" > epython.py || die
	python_domodule epython.py

	einfo "Byte-compiling Python standard library..."

	# compile the installed modules
	python_optimize "${ED%/}${dest}"
}
