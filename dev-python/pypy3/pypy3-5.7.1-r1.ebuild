# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# pypy3 needs to be built using python 2
PYTHON_COMPAT=( python2_7 pypy )
inherit check-reqs pax-utils python-any-r1 toolchain-funcs versionator

MY_P=pypy3-v${PV}

DESCRIPTION="A fast, compliant alternative implementation of the Python (3.3) language"
HOMEPAGE="http://pypy.org/"
SRC_URI="https://bitbucket.org/pypy/pypy/downloads/${MY_P}-src.tar.bz2"

LICENSE="MIT"
# XX from pypy3-XX.so module suffix
SLOT="0/57"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 gdbm +jit libressl low-memory ncurses sandbox sqlite cpu_flags_x86_sse2 tk"

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

S="${WORKDIR}/${MY_P}-src"

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
	eapply "${FILESDIR}/4.0.0-gentoo-path.patch"
	eapply "${FILESDIR}/1.9-distutils.unixccompiler.UnixCCompiler.runtime_library_dir_option.patch"
	eapply "${FILESDIR}"/2.5.0-shared-lib.patch	# 517002
	# disarm implicit -flto
	eapply "${FILESDIR}"/5.7.1-kill-flto.patch

	sed -e "s^@EPREFIX@^${EPREFIX}^" \
		-e "s^@libdir@^$(get_libdir)^" \
		-i lib-python/3/distutils/command/install.py || die

	# apply CPython stdlib patches
	pushd lib-python/3 > /dev/null || die
	eapply "${FILESDIR}"/5.7.1_all_distutils_cxx.patch
	eapply "${FILESDIR}"/python-3.5-distutils-OO-build.patch
	popd > /dev/null || die

	eapply_user
}

src_configure() {
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
		$(usex sandbox --sandbox '')

		${jit_backend}

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

	# translate into the C sources
	# we're going to make them ourselves since otherwise pypy does not
	# free up the unneeded memory before spawning the compiler
	set -- "${interp[@]}" rpython/bin/rpython --batch --source "${args[@]}"
	echo -e "\033[1m${@}\033[0m"
	"${@}" || die "translation failed"
}

src_compile() {
	emake -C "${T}"/usession*-0/testing_1

	# copy back to make sys.prefix happy
	cp -p "${T}"/usession*-0/testing_1/{pypy3-c,libpypy3-c.so} . || die
	pax-mark m pypy3-c libpypy3-c.so

	#use doc && emake -C pypy/doc html
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
	exeinto "${dest}"
	doexe pypy3-c libpypy3-c.so
	pax-mark m "${ED%/}${dest}/pypy3-c" "${ED%/}${dest}/libpypy3-c.so"
	insinto "${dest}"
	doins -r include lib_pypy lib-python
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
	#use doc && dohtml -r pypy/doc/_build/html/

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
