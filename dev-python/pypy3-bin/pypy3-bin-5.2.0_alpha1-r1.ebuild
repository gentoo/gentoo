# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# some random parts need python 2...
PYTHON_COMPAT=( python2_7 pypy )
inherit eutils multilib pax-utils python-any-r1 unpacker versionator

CPY_PATCHSET_VERSION="3.3.5-0"
MY_P=pypy3.3-v${PV/_/-}
BINHOST="https://dev.gentoo.org/~mgorny/dist/pypy3-bin/${PV}"

DESCRIPTION="A fast, compliant alternative implementation of Python 3.3 (binary package)"
HOMEPAGE="http://pypy.org/"
SRC_URI="https://bitbucket.org/pypy/pypy/downloads/${MY_P}-src.tar.bz2
	https://dev.gentoo.org/~floppym/python-gentoo-patches-${CPY_PATCHSET_VERSION}.tar.xz
	amd64? (
		jit? ( shadowstack? (
			${BINHOST}/${P}-amd64+bzip2+jit+ncurses+shadowstack.tar.lz
		) )
		jit? ( !shadowstack? (
			${BINHOST}/${P}-amd64+bzip2+jit+ncurses.tar.lz
		) )
		!jit? ( !shadowstack? (
			${BINHOST}/${P}-amd64+bzip2+ncurses.tar.lz
		) )
	)
	x86? (
		cpu_flags_x86_sse2? (
			jit? ( shadowstack? (
				${BINHOST}/${P}-x86+bzip2+jit+ncurses+shadowstack+sse2.tar.lz
			) )
			jit? ( !shadowstack? (
				${BINHOST}/${P}-x86+bzip2+jit+ncurses+sse2.tar.lz
			) )
			!jit? ( !shadowstack? (
				${BINHOST}/${P}-x86+bzip2+ncurses+sse2.tar.lz
			) )
		)
		!cpu_flags_x86_sse2? (
			!jit? ( !shadowstack? (
				${BINHOST}/${P}-x86+bzip2+ncurses.tar.lz
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

S=${WORKDIR}/${MY_P}-src

QA_PREBUILT="
	usr/lib*/pypy3/pypy-c
	usr/lib*/pypy3/libpypy-c.so"

src_prepare() {
	epatch "${FILESDIR}/4.0.0-gentoo-path.patch" \
		"${FILESDIR}/1.9-distutils.unixccompiler.UnixCCompiler.runtime_library_dir_option.patch"

	sed -e "s^@EPREFIX@^${EPREFIX}^" \
		-e "s^@libdir@^$(get_libdir)^" \
		-i lib-python/3/distutils/command/install.py || die

	# apply CPython stdlib patches
	pushd lib-python/3 > /dev/null || die
	epatch "${FILESDIR}"/5.2.0-distutils-c++.patch \
		"${WORKDIR}"/patches/24_all_sqlite-3.8.4.patch
	popd > /dev/null || die

	epatch_user
}

src_compile() {
	# Tadaam! PyPy compiled!
	mv "${WORKDIR}"/${P}*/{libpypy-c.so,pypy-c} . || die
	mv "${WORKDIR}"/${P}*/include/*.h include/ || die
	mv pypy/module/cpyext/include/*.h include/ || die

	#use doc && emake -C pypy/doc/ html
	#needed even without jit :( also needed in both compile and install phases
	pax-mark m pypy-c libpypy-c.so
}

src_test() {
	# (unset)
	local -x PYTHONDONTWRITEBYTECODE

	# Test runner requires Python 2 too. However, it spawns PyPy3
	# internally so that we end up testing the correct interpreter.
	"${PYTHON}" ./pypy/test_all.py --pypy=./pypy-c lib-python || die
}

src_install() {
	local dest=/usr/$(get_libdir)/pypy3
	einfo "Installing PyPy ..."
	insinto "${dest}"
	doins -r include lib_pypy lib-python pypy-c libpypy-c.so
	fperms a+x ${dest}/pypy-c ${dest}/libpypy-c.so
	pax-mark m "${ED%/}${dest}/pypy-c" "${ED%/}${dest}/libpypy-c.so"
	dosym ../$(get_libdir)/pypy3/pypy-c /usr/bin/pypy3
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
	#use doc && dohtml -r pypy/doc/_build/html/

	einfo "Generating caches and byte-compiling ..."

	local -x PYTHON=${ED%/}${dest}/pypy-c
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
	cffi_targets=( audioop curses syslog pwdgrp resource lzma decimal )
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
