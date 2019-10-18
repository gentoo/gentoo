# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Test runner needs Python 2.
PYTHON_COMPAT=( python2_7 pypy )
inherit pax-utils python-any-r1 unpacker

BINHOST="https://dev.gentoo.org/~mgorny/dist/pypy3-bin/${PV}"
MY_P=pypy3.6-v${PV}

DESCRIPTION="Pre-built version of PyPy3"
HOMEPAGE="https://pypy.org/"
SRC_URI="https://bitbucket.org/pypy/pypy/downloads/${MY_P}-src.tar.bz2
	amd64? (
		jit? ( ${BINHOST}/${P}-amd64+bzip2+jit+ncurses.tar.lz )
		!jit? ( ${BINHOST}/${P}-amd64+bzip2+ncurses.tar.lz )
	)
	x86? (
		cpu_flags_x86_sse2? (
			jit? ( ${BINHOST}/${P}-x86+bzip2+jit+ncurses+sse2.tar.lz )
			!jit? ( ${BINHOST}/${P}-x86+bzip2+ncurses+sse2.tar.lz )
		)
	)"

LICENSE="MIT"
# pypy3 -c 'import sysconfig; print(sysconfig.get_config_var("SOABI"))'
SLOT="0/72-py36"
KEYWORDS="~amd64 ~x86"
IUSE="gdbm +jit libressl sqlite cpu_flags_x86_sse2 test tk"
RESTRICT="!test? ( test )"
# Supported variants
REQUIRED_USE="x86? ( cpu_flags_x86_sse2 )"

RDEPEND="
	app-arch/bzip2:0/1
	dev-libs/expat:0/0
	dev-libs/libffi:0/7
	sys-devel/gcc:*
	>=sys-libs/glibc-2.28
	sys-libs/ncurses:0/6
	sys-libs/zlib:0/1
	gdbm? ( sys-libs/gdbm:0= )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	sqlite? ( dev-db/sqlite:3= )
	tk? (
		dev-lang/tk:0=
		dev-tcltk/tix:0=
	)
	!dev-python/pypy3:0"
DEPEND="${RDEPEND}
	app-arch/lzip
	app-arch/xz-utils
	test? ( ${PYTHON_DEPS} )"

S=${WORKDIR}/${MY_P}-src

QA_PREBUILT="
	usr/lib/pypy3.6/pypy3-c
	usr/lib/pypy3.6/libpypy3-c.so"

src_prepare() {
	eapply "${FILESDIR}/7.0.0-gentoo-path.patch"
	eapply "${FILESDIR}/1.9-distutils.unixccompiler.UnixCCompiler.runtime_library_dir_option.patch"
	eapply "${FILESDIR}"/7.2.0-distutils-cxx.patch

	sed -e "s^@EPREFIX@^${EPREFIX}^" \
		-i lib-python/3/distutils/command/install.py || die

	# apply CPython stdlib patches
	pushd lib-python/3 > /dev/null || die
	eapply "${FILESDIR}"/python-3.5-distutils-OO-build.patch
	popd > /dev/null || die

	eapply_user
}

src_compile() {
	# Tadaam! PyPy compiled!
	mv "${WORKDIR}"/${P}*/{libpypy3-c.so,pypy3-c} . || die
	mv "${WORKDIR}"/${P}*/include/*.h include/ || die
	mv pypy/module/cpyext/include/*.h include/ || die
	mv pypy/module/cpyext/parse/*.h include/ || die

	pax-mark m pypy3-c libpypy3-c.so

	einfo "Generating caches and CFFI modules ..."

	# Generate Grammar and PatternGrammar pickles.
	./pypy3-c -c "import lib2to3.pygram, lib2to3.patcomp; lib2to3.patcomp.PatternCompiler()" \
		|| die "Generation of Grammar and PatternGrammar pickles failed"

	# Generate cffi modules
	# Please keep in sync with pypy/tool/build_cffi_imports.py!
#cffi_build_scripts = {
#    "_blake2": "_blake2/_blake2_build.py",
#    "_ssl": "_ssl_build.py",
#    "sqlite3": "_sqlite3_build.py",
#    "audioop": "_audioop_build.py",
#    "tk": "_tkinter/tklib_build.py",
#    "curses": "_curses_build.py" if sys.platform != "win32" else None,
#    "syslog": "_syslog_build.py" if sys.platform != "win32" else None,
#    "gdbm": "_gdbm_build.py"  if sys.platform != "win32" else None,
#    "pwdgrp": "_pwdgrp_build.py" if sys.platform != "win32" else None,
#    "resource": "_resource_build.py" if sys.platform != "win32" else None,
#    "lzma": "_lzma_build.py",
#    "_decimal": "_decimal_build.py",
#    "ssl": "_ssl_build.py",
#    "_blake2": "_blake2/_blake2_build.py",
#    "_sha3": "_sha3/_sha3_build.py",
	cffi_targets=( blake2/_blake2 sha3/_sha3 ssl
		audioop curses syslog pwdgrp resource lzma decimal )
	use gdbm && cffi_targets+=( gdbm )
	use sqlite && cffi_targets+=( sqlite3 )
	use tk && cffi_targets+=( tkinter/tklib )

	local t
	# all modules except tkinter output to .
	# tkinter outputs to the correct dir ...
	cd lib_pypy || die
	for t in "${cffi_targets[@]}"; do
		# tkinter doesn't work via -m
		../pypy3-c "_${t}_build.py" || die "Failed to build CFFI bindings for ${t}"
	done

	# Cleanup temporary objects
	find -name "_cffi_*.[co]" -delete || die
	find -type d -empty -delete || die
}

src_test() {
	# (unset)
	local -x PYTHONDONTWRITEBYTECODE=

	# Test runner requires Python 2 too. However, it spawns PyPy3
	# internally so that we end up testing the correct interpreter.
	"${PYTHON}" ./pypy/test_all.py --pypy=./pypy3-c -vv lib-python || die
}

src_install() {
	local dest=/usr/lib/pypy3.6
	einfo "Installing PyPy ..."
	exeinto "${dest}"
	doexe pypy3-c libpypy3-c.so
	pax-mark m "${ED}${dest}/pypy3-c" "${ED}${dest}/libpypy3-c.so"
	insinto "${dest}"
	# preserve mtimes to avoid obsoleting caches
	insopts -p
	doins -r include lib_pypy lib-python
	dosym ../lib/pypy3.6/pypy3-c /usr/bin/pypy3
	dodoc README.rst

	if ! use gdbm; then
		rm -r "${ED}${dest}"/lib_pypy/_gdbm* || die
	fi
	if ! use sqlite; then
		rm -r "${ED}${dest}"/lib-python/*3/sqlite3 \
			"${ED}${dest}"/lib_pypy/_sqlite3* \
			"${ED}${dest}"/lib-python/*3/test/test_sqlite.py || die
	fi
	if ! use tk; then
		rm -r "${ED}${dest}"/lib-python/*3/{idlelib,tkinter} \
			"${ED}${dest}"/lib_pypy/_tkinter \
			"${ED}${dest}"/lib-python/*3/test/test_{tcl,tk,ttk*}.py || die
	fi

	einfo "Generating caches and byte-compiling ..."

	local -x PYTHON=${ED}${dest}/pypy3-c
	# we can't use eclass function since PyPy is dumb and always gives
	# paths relative to the interpreter
	local PYTHON_SITEDIR=${EPREFIX}/usr/lib/pypy3.6/site-packages
	python_export pypy3 EPYTHON

	echo "EPYTHON='${EPYTHON}'" > epython.py || die
	python_domodule epython.py

	einfo "Byte-compiling Python standard library..."

	# compile the installed modules
	python_optimize "${ED}${dest}"
}
