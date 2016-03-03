# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# some random parts need python 2...
PYTHON_COMPAT=( python2_7 pypy )
inherit eutils multilib pax-utils python-any-r1 unpacker versionator

BINHOST="https://dev.gentoo.org/~mgorny/dist/pypy-bin/${PV}-nossl2"

DESCRIPTION="A fast, compliant alternative implementation of Python 3 (binary package)"
HOMEPAGE="http://pypy.org/"
SRC_URI="https://bitbucket.org/pypy/pypy/downloads/pypy3-${PV}-src.tar.bz2
	amd64? (
		jit? ( shadowstack? (
			${BINHOST}/${P}-nossl2-amd64+bzip2+jit+ncurses+shadowstack.tar.lz
		) )
		jit? ( !shadowstack? (
			${BINHOST}/${P}-nossl2-amd64+bzip2+jit+ncurses.tar.lz
		) )
		!jit? ( !shadowstack? (
			${BINHOST}/${P}-nossl2-amd64+bzip2+ncurses.tar.lz
		) )
	)
	x86? (
		cpu_flags_x86_sse2? (
			jit? ( shadowstack? (
				${BINHOST}/${P}-nossl2-x86+bzip2+jit+ncurses+shadowstack+sse2.tar.lz
			) )
			jit? ( !shadowstack? (
				${BINHOST}/${P}-nossl2-x86+bzip2+jit+ncurses+sse2.tar.lz
			) )
			!jit? ( !shadowstack? (
				${BINHOST}/${P}-nossl2-x86+bzip2+ncurses+sse2.tar.lz
			) )
		)
		!cpu_flags_x86_sse2? (
			!jit? ( !shadowstack? (
				${BINHOST}/${P}-nossl2-x86+bzip2+ncurses.tar.lz
			) )
		)
	)"

# Supported variants
REQUIRED_USE="!jit? ( !shadowstack )
	x86? ( !cpu_flags_x86_sse2? ( !jit !shadowstack ) )"

LICENSE="MIT"
SLOT="0/$(get_version_component_range 1-2 ${PV})"
KEYWORDS="~amd64 ~x86"
IUSE="gdbm +jit +shadowstack sqlite cpu_flags_x86_sse2 test tk"

# yep, world would be easier if people started filling subslots...
RDEPEND="
	app-arch/bzip2:0=
	dev-libs/expat:0=
	dev-libs/libffi:0=
	dev-libs/openssl:0=
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
	test? ( ${PYTHON_DEPS} )"
#	doc? ( ${PYTHON_DEPS}
#		dev-python/sphinx )
PDEPEND="app-admin/python-updater"

S=${WORKDIR}/pypy3-${PV}-src

QA_PREBUILT="
	usr/lib*/pypy3/pypy-c
	usr/lib*/pypy3/libpypy-c.so"

src_prepare() {
	epatch \
		"${FILESDIR}/4.0.0-gentoo-path.patch" \
		"${FILESDIR}/1.9-distutils.unixccompiler.UnixCCompiler.runtime_library_dir_option.patch"
	epatch "${FILESDIR}/2.4.0-ncurses6.patch"
	epatch "${FILESDIR}"/pypy3-2.4.0-libressl.patch

	sed -e "s^@EPREFIX@^${EPREFIX}^" \
		-e "s^@libdir@^$(get_libdir)^" \
		-i lib-python/3/distutils/command/install.py || die

	# apply CPython stdlib patches
	pushd lib-python/3 > /dev/null || die
	epatch "${FILESDIR}"/2.4.0-21_all_distutils_c++.patch
	popd > /dev/null || die

	epatch_user
}

src_compile() {
	# Tadaam! PyPy compiled!
	mv "${WORKDIR}"/${P}*/{libpypy-c.so,pypy-c} . || die
	mv "${WORKDIR}"/${P}*/include/*.h include/ || die
	mv pypy/module/cpyext/include/*.h include/ || die
	mv pypy/module/cpyext/include/numpy include/ || die

	#use doc && emake -C pypy/doc/ html
	#needed even without jit :( also needed in both compile and install phases
	pax-mark m pypy-c

	# ctypes config cache
	# this one we need to do with python2 too...
	"${PYTHON}" lib_pypy/ctypes_config_cache/rebuild.py \
		|| die "Failed to rebuild ctypes config cache"
}

src_test() {
	# (unset)
	local -x PYTHONDONTWRITEBYTECODE

	# Test runner requires Python 2 too. However, it spawns PyPy3
	# internally so that we end up testing the correct interpreter.
	"${PYTHON}" ./pypy/test_all.py --pypy=./pypy-c lib-python || die
}

src_install() {
	einfo "Installing PyPy ..."
	insinto "/usr/$(get_libdir)/pypy3"
	doins -r include lib_pypy lib-python pypy-c libpypy-c.so
	fperms a+x ${INSDESTTREE}/pypy-c ${INSDESTTREE}/libpypy-c.so
	pax-mark m "${ED%/}${INSDESTTREE}/pypy-c" "${ED%/}${INSDESTTREE}/libpypy-c.so"
	dosym ../$(get_libdir)/pypy3/pypy-c /usr/bin/pypy3
	dodoc README.rst

	if ! use gdbm; then
		rm -r "${ED%/}${INSDESTTREE}"/lib_pypy/gdbm.py \
			"${ED%/}${INSDESTTREE}"/lib-python/*3/test/test_gdbm.py || die
	fi
	if ! use sqlite; then
		rm -r "${ED%/}${INSDESTTREE}"/lib-python/*3/sqlite3 \
			"${ED%/}${INSDESTTREE}"/lib_pypy/_sqlite3.py \
			"${ED%/}${INSDESTTREE}"/lib-python/*3/test/test_sqlite.py || die
	fi
	if ! use tk; then
		rm -r "${ED%/}${INSDESTTREE}"/lib-python/*3/{idlelib,tkinter} \
			"${ED%/}${INSDESTTREE}"/lib_pypy/_tkinter \
			"${ED%/}${INSDESTTREE}"/lib-python/*3/test/test_{tcl,tk,ttk*}.py || die
	fi

	# Install docs
	#use doc && dohtml -r pypy/doc/_build/html/

	einfo "Generating caches and byte-compiling ..."

	local -x PYTHON=${ED%/}${INSDESTTREE}/pypy-c
	local -x LD_LIBRARY_PATH="${ED%/}${INSDESTTREE}"
	# we can't use eclass function since PyPy is dumb and always gives
	# paths relative to the interpreter
	local PYTHON_SITEDIR=${EPREFIX}/usr/$(get_libdir)/pypy3/site-packages
	python_export pypy3 EPYTHON

	echo "EPYTHON='${EPYTHON}'" > epython.py || die
	python_domodule epython.py

	# Generate Grammar and PatternGrammar pickles.
	"${PYTHON}" -c "import lib2to3.pygram, lib2to3.patcomp; lib2to3.patcomp.PatternCompiler()" \
		|| die "Generation of Grammar and PatternGrammar pickles failed"

	# Generate cffi cache
	# Please keep in sync with pypy/tool/release/package.py!
	"${PYTHON}" -c "import _curses" || die "Failed to import _curses (cffi)"
	"${PYTHON}" -c "import syslog" || die "Failed to import syslog (cffi)"
	if use gdbm; then
		"${PYTHON}" -c "import _gdbm" || die "Failed to import gdbm (cffi)"
	fi
	if use sqlite; then
		"${PYTHON}" -c "import _sqlite3" || die "Failed to import _sqlite3 (cffi)"
	fi
	if use tk; then
		"${PYTHON}" -c "import _tkinter" || die "Failed to import _tkinter (cffi)"
	fi

	# Cleanup temporary objects
	find "${ED%/}${INSDESTTREE}" -name "_cffi_*.[co]" -delete || die
	find "${ED%/}${INSDESTTREE}" -type d -empty -delete || die

	# compile the installed modules
	python_optimize "${ED%/}${INSDESTTREE}"
}
