# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 pypy )
inherit pax-utils python-any-r1

MY_P=pypy3.6-v${PV/_/}

DESCRIPTION="A fast, compliant alternative implementation of the Python (3.6) language"
HOMEPAGE="https://pypy.org/"
SRC_URI="https://bitbucket.org/pypy/pypy/downloads/${MY_P}-src.tar.bz2"
S="${WORKDIR}/${MY_P}-src"

LICENSE="MIT"
# pypy3 -c 'import sysconfig; print(sysconfig.get_config_var("SOABI"))'
SLOT="0/pypy36-pp73"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 gdbm +jit libressl ncurses sqlite test tk"
RESTRICT="!test? ( test )"

RDEPEND="
	|| (
		dev-python/pypy3-exe:${PV}[bzip2?,ncurses?]
		dev-python/pypy3-exe-bin:${PV}
	)
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	gdbm? ( sys-libs/gdbm:0= )
	sqlite? ( dev-db/sqlite:3= )
	tk? (
		dev-lang/tk:0=
		dev-tcltk/tix:0=
	)
	!<dev-python/pypy3-bin-7.3.0:0"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

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
	# copy over to make sys.prefix happy
	cp -p "${BROOT}"/usr/lib/pypy3.6/pypy3-c-${PV} pypy3-c || die
	cp -p "${BROOT}"/usr/lib/pypy3.6/include/${PV}/* include/ || die
	# (not installed by pypy)
	rm pypy/module/cpyext/include/_numpypy/numpy/README || die
	mv pypy/module/cpyext/include/* include/ || die
	mv pypy/module/cpyext/parse/*.h include/ || die
	pax-mark m pypy3-c

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
#    "_sha3": "_sha3/_sha3_build.py",
	cffi_targets=( blake2/_blake2 sha3/_sha3 ssl
		audioop syslog pwdgrp resource lzma decimal )
	use gdbm && cffi_targets+=( gdbm )
	use ncurses && cffi_targets+=( curses )
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
	dosym pypy3-c-${PV} "${dest}/pypy3-c"
	insinto "${dest}"
	# preserve mtimes to avoid obsoleting caches
	insopts -p
	doins -r include lib_pypy lib-python

	# replace copied headers with symlinks
	for x in "${BROOT}"/usr/lib/pypy3.6/include/${PV}/*; do
		dosym "${PV}/${x##*/}" "${dest}/include/${x##*/}"
	done

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
