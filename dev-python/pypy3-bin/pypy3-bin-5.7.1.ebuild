# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# some random parts need python 2...
PYTHON_COMPAT=( python2_7 pypy )
inherit pax-utils python-any-r1 unpacker versionator

BINHOST="https://dev.gentoo.org/~mgorny/dist/pypy3-bin/${PV}"
MY_P=pypy3-v${PV}

DESCRIPTION="A fast, compliant alternative implementation of Python 3.3 (binary package)"
HOMEPAGE="http://pypy.org/"
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
		!cpu_flags_x86_sse2? (
			!jit? ( ${BINHOST}/${P}-x86+bzip2+ncurses.tar.lz )
		)
	)"

# Supported variants
REQUIRED_USE="x86? ( !cpu_flags_x86_sse2? ( !jit ) )"

LICENSE="MIT"
# XX from pypy3-XX.so module suffix
SLOT="0/57"
KEYWORDS="~amd64 ~x86"
IUSE="gdbm +jit sqlite cpu_flags_x86_sse2 test tk"

# yep, world would be easier if people started filling subslots...
RDEPEND="
	app-arch/bzip2:0=
	dev-libs/expat:0=
	dev-libs/libffi:0=
	dev-libs/openssl:0=[-bindist]
	sys-libs/glibc:2.2=
	sys-libs/ncurses:0/6
	sys-libs/zlib:0=
	gdbm? ( sys-libs/gdbm:0= )
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
#	doc? ( ${PYTHON_DEPS}
#		dev-python/sphinx )

S=${WORKDIR}/${MY_P}-src

QA_PREBUILT="
	usr/lib*/pypy3/pypy3-c
	usr/lib*/pypy3/libpypy3-c.so"

src_prepare() {
	eapply "${FILESDIR}/4.0.0-gentoo-path.patch"
	eapply "${FILESDIR}/1.9-distutils.unixccompiler.UnixCCompiler.runtime_library_dir_option.patch"

	sed -e "s^@EPREFIX@^${EPREFIX}^" \
		-e "s^@libdir@^$(get_libdir)^" \
		-i lib-python/3/distutils/command/install.py || die

	# apply CPython stdlib patches
	pushd lib-python/3 > /dev/null || die
	eapply "${FILESDIR}"/5.7.1_all_distutils_cxx.patch
	popd > /dev/null || die

	eapply_user
}

src_compile() {
	# Tadaam! PyPy compiled!
	mv "${WORKDIR}"/${P}*/{libpypy3-c.so,pypy3-c} . || die
	mv "${WORKDIR}"/${P}*/include/*.h include/ || die
	mv pypy/module/cpyext/include/*.h include/ || die
	mv pypy/module/cpyext/parse/*.h include/ || die

	#use doc && emake -C pypy/doc/ html
	#needed even without jit :( also needed in both compile and install phases
	pax-mark m pypy3-c libpypy3-c.so
}

src_test() {
	# (unset)
	local -x PYTHONDONTWRITEBYTECODE

	# Test runner requires Python 2 too. However, it spawns PyPy3
	# internally so that we end up testing the correct interpreter.
	"${PYTHON}" ./pypy/test_all.py --pypy=./pypy3-c lib-python || die
}

src_install() {
	local dest=/usr/$(get_libdir)/pypy3
	einfo "Installing PyPy ..."
	insinto "${dest}"
	doins -r include lib_pypy lib-python pypy3-c libpypy3-c.so
	fperms a+x ${dest}/pypy3-c ${dest}/libpypy3-c.so
	pax-mark m "${ED%/}${dest}/pypy3-c" "${ED%/}${dest}/libpypy3-c.so"
	dosym ../$(get_libdir)/pypy3/pypy3-c /usr/bin/pypy3
	dodoc README.rst

	if ! use gdbm; then
		rm -r "${ED%/}${dest}"/lib_pypy/gdbm.py \
			"${ED%/}${dest}"/lib-python/*3/test/test_gdbm.py || die
	fi
	if ! use sqlite; then
		rm -r "${ED%/}${dest}"/lib-python/*3/sqlite3 \
			"${ED%/}${dest}"/lib_pypy/_sqlite3.py \
			"${ED%/}${dest}"/lib-python/*3/test/test_sqlite.py || die
	fi
	if ! use tk; then
		rm -r "${ED%/}${dest}"/lib-python/*3/{idlelib,tkinter} \
			"${ED%/}${dest}"/lib_pypy/_tkinter \
			"${ED%/}${dest}"/lib-python/*3/test/test_{tcl,tk,ttk*}.py || die
	fi

	# Install docs
	#use doc && dodoc -r pypy/doc/_build/html

	einfo "Generating caches and byte-compiling ..."

	local -x PYTHON=${ED%/}${dest}/pypy3-c
	local -x LD_LIBRARY_PATH="${ED%/}${dest}"
	# we can't use eclass function since PyPy is dumb and always gives
	# paths relative to the interpreter
	local PYTHON_SITEDIR=${EPREFIX}/usr/$(get_libdir)/pypy3/site-packages
	python_export pypy3 EPYTHON

	echo "EPYTHON='${EPYTHON}'" > epython.py || die
	python_domodule epython.py

	# Generate Grammar and PatternGrammar pickles.
	"${PYTHON}" -c "import lib2to3.pygram, lib2to3.patcomp; lib2to3.patcomp.PatternCompiler()" \
		|| die "Generation of Grammar and PatternGrammar pickles failed"

	# Generate cffi modules
	# Please keep in sync with pypy/tool/build_cffi_imports.py!
#cffi_build_scripts = {
#    "sqlite3": "_sqlite3_build.py",
#    "audioop": "_audioop_build.py",
#    "tk": "_tkinter/tklib_build.py",
#    "curses": "_curses_build.py" if sys.platform != "win32" else None,
#    "syslog": "_syslog_build.py" if sys.platform != "win32" else None,
#    "_gdbm": "_gdbm_build.py"  if sys.platform != "win32" else None,
#    "pwdgrp": "_pwdgrp_build.py" if sys.platform != "win32" else None,
#    "resource": "_resource_build.py" if sys.platform != "win32" else None,
#    "lzma": "_lzma_build.py",
#    "_decimal": "_decimal_build.py",
#    "ssl": "_ssl_build.py",
	cffi_targets=( audioop curses syslog pwdgrp resource lzma decimal ssl )
	use gdbm && cffi_targets+=( gdbm )
	use sqlite && cffi_targets+=( sqlite3 )
	use tk && cffi_targets+=( tkinter/tklib )

	local t
	# all modules except tkinter output to .
	# tkinter outputs to the correct dir ...
	cd "${ED%/}${dest}"/lib_pypy || die
	for t in "${cffi_targets[@]}"; do
		# tkinter doesn't work via -m
		"${PYTHON}" "_${t}_build.py" || die "Failed to build CFFI bindings for ${t}"
	done

	# Cleanup temporary objects
	find "${ED%/}${dest}" -name "_cffi_*.[co]" -delete || die
	find "${ED%/}${dest}" -type d -empty -delete || die

	# compile the installed modules
	python_optimize "${ED%/}${dest}"
}
