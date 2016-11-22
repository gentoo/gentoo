# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# pypy3 needs to be built using python 2
PYTHON_COMPAT=( python2_7 pypy )
inherit check-reqs eutils multilib multiprocessing pax-utils python-any-r1 toolchain-funcs versionator

CPY_PATCHSET_VERSION="3.3.5-0"

DESCRIPTION="A fast, compliant alternative implementation of the Python (3.3) language"
HOMEPAGE="http://pypy.org/"
SRC_URI="https://bitbucket.org/pypy/pypy/downloads/pypy3.3-v${PV/_/-}-src.tar.bz2
	https://dev.gentoo.org/~floppym/python-gentoo-patches-${CPY_PATCHSET_VERSION}.tar.xz"

LICENSE="MIT"
# XX from pypy3-XX.so module suffix
SLOT="0/55"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 gdbm +jit libressl low-memory ncurses sandbox +shadowstack sqlite cpu_flags_x86_sse2 tk"

RDEPEND=">=sys-libs/zlib-1.1.3:0=
	virtual/libffi:0=
	virtual/libintl:0=
	dev-libs/expat:0=
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	bzip2? ( app-arch/bzip2:0= )
	gdbm? ( sys-libs/gdbm:0= )
	ncurses? ( sys-libs/ncurses:0= )
	sqlite? ( dev-db/sqlite:3= )
	tk? (
		dev-lang/tk:0=
		dev-tcltk/tix:0=
	)
	!dev-python/pypy3-bin:0"
DEPEND="${RDEPEND}
	low-memory? ( virtual/pypy:0 )
	!low-memory? ( ${PYTHON_DEPS} )"
#	doc? ( dev-python/sphinx )

# Who would care about predictable directory names?
S="${WORKDIR}/pypy3-v${PV%_*}-src"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if use low-memory; then
			CHECKREQS_MEMORY="1750M"
			use amd64 && CHECKREQS_MEMORY="3500M"
		else
			CHECKREQS_MEMORY="3G"
			use amd64 && CHECKREQS_MEMORY="6G"
		fi

		check-reqs_pkg_pretend
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		pkg_pretend

		# unset to allow forcing pypy below :)
		use low-memory && local EPYTHON=
		if python_is_installed pypy && [[ ! ${EPYTHON} || ${EPYTHON} == pypy ]]; then
			einfo "Using PyPy to perform the translation."
			local EPYTHON=pypy
		else
			einfo "Using ${EPYTHON:-python2} to perform the translation. Please note that upstream"
			einfo "recommends using PyPy for that. If you wish to do so, please install"
			einfo "virtual/pypy and ensure that EPYTHON variable is unset."
		fi

		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}/4.0.0-gentoo-path.patch" \
		"${FILESDIR}/1.9-distutils.unixccompiler.UnixCCompiler.runtime_library_dir_option.patch" \
		"${FILESDIR}"/2.5.0-shared-lib.patch	# 517002

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
	tc-export CC

	local jit_backend
	if use jit; then
		jit_backend='--jit-backend='

		# We only need the explicit sse2 switch for x86.
		# On other arches we can rely on autodetection which uses
		# compiler macros. Plus, --jit-backend= doesn't accept all
		# the modern values...

		if use x86; then
			if use cpu_flags_x86_sse2; then
				jit_backend+=x86
			else
				jit_backend+=x86-without-sse2
			fi
		else
			jit_backend+=auto
		fi
	fi

	local args=(
		--shared
		$(usex jit -Ojit -O2)
		$(usex shadowstack --gcrootfinder=shadowstack '')
		$(usex sandbox --sandbox '')

		${jit_backend}
		--make-jobs=$(makeopts_jobs)

		pypy/goal/targetpypystandalone
	)

	# Avoid linking against libraries disabled by use flags
	local opts=(
		bzip2:bz2
		ncurses:_minimal_curses
	)

	local opt
	for opt in "${opts[@]}"; do
		local flag=${opt%:*}
		local mod=${opt#*:}

		args+=(
			$(usex ${flag} --withmod --withoutmod)-${mod}
		)
	done

	local interp=( "${PYTHON}" )
	if use low-memory; then
		interp=( env PYPY_GC_MAX_DELTA=200MB
			"${PYTHON}" --jit loop_longevity=300 )
	fi

	set -- "${interp[@]}" rpython/bin/rpython --batch "${args[@]}"
	echo -e "\033[1m${@}\033[0m"
	"${@}" || die "compile error"

	# Exception occurred:
	#  File "/tmp/1/pypy3-2.4.0-src/pypy/config/makerestdoc.py", line 199, in config_role
	#    assert txt.check()
	# AssertionError
	#use doc && emake -C pypy/doc/ html
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
	cffi_targets=( audioop syslog pwdgrp resource lzma decimal )
	use gdbm && cffi_targets+=( gdbm )
	use ncurses && cffi_targets+=( curses )
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
