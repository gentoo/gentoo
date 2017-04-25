# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 pypy )
EHG_REPO_URI="https://bitbucket.org/pypy/pypy"
inherit check-reqs mercurial pax-utils python-any-r1 toolchain-funcs versionator

# note: remember to update this to newest dev-lang/python:2.7 on bump
CPY_PATCHSET_VERSION="2.7.13-0"
MY_P=pypy2-v${PV}

DESCRIPTION="A fast, compliant alternative implementation of the Python language"
HOMEPAGE="http://pypy.org/"
SRC_URI="
	https://dev.gentoo.org/~floppym/python/python-gentoo-patches-${CPY_PATCHSET_VERSION}.tar.xz"

LICENSE="MIT"
# pypy -c 'import sysconfig; print sysconfig.get_config_var("SOABI")'
SLOT="0/41"
KEYWORDS=""
IUSE="bzip2 doc gdbm +jit libressl low-memory ncurses sandbox sqlite cpu_flags_x86_sse2 test tk"

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
	!dev-python/pypy-bin:0"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	${PYTHON_DEPS}
	test? ( dev-python/pytest )"

S="${WORKDIR}/${MY_P}-src"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if use low-memory; then
			if ! python_is_installed pypy; then
				eerror "USE=low-memory requires a (possibly old) version of dev-python/pypy"
				eerror "or dev-python/pypy-bin being installed. Please install it using e.g.:"
				eerror
				eerror "  $ emerge -1v dev-python/pypy-bin"
				eerror
				eerror "before attempting to build dev-python/pypy[low-memory]."
				die "dev-python/pypy-bin (or dev-python/pypy) needs to be installed for USE=low-memory"
			fi

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

		if python_is_installed pypy; then
			if [[ ! ${EPYTHON} || ${EPYTHON} == pypy ]] || use low-memory; then
				einfo "Using already-installed PyPy to perform the translation."
				local EPYTHON=pypy
			else
				einfo "Using ${EPYTHON} to perform the translation. Please note that upstream"
				einfo "recommends using PyPy for that. If you wish to do so, please unset"
				einfo "the EPYTHON variable."
			fi
		fi

		python-any-r1_pkg_setup
	fi
}

src_unpack() {
	default
	mercurial_src_unpack
}

src_prepare() {
	eapply "${FILESDIR}/4.0.0-gentoo-path.patch"
	eapply "${FILESDIR}/1.9-distutils.unixccompiler.UnixCCompiler.runtime_library_dir_option.patch"
	eapply "${FILESDIR}"/2.5.0-shared-lib.patch	# 517002
	# disarm implicit -flto
	eapply "${FILESDIR}"/5.7.1-kill-flto.patch

	sed -e "s^@EPREFIX@^${EPREFIX}^" \
		-e "s^@libdir@^$(get_libdir)^" \
		-i lib-python/2.7/distutils/command/install.py || die

	# apply CPython stdlib patches
	pushd lib-python/2.7 > /dev/null || die
	# TODO: cpy turkish locale patch now fixes C code
	# probably needs better port to pypy, if it is broken there
	eapply "${FILESDIR}"/5.7.1_all_distutils_cxx.patch
	eapply "${WORKDIR}"/patches/62_all_xml.use_pyxml.patch
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
	cp -p "${T}"/usession*-0/testing_1/{pypy-c,libpypy-c.so} . || die
	pax-mark m pypy-c libpypy-c.so

	use doc && emake -C pypy/doc html
}

src_test() {
	# (unset)
	local -x PYTHONDONTWRITEBYTECODE

	./pypy-c ./pypy/test_all.py --pypy=./pypy-c lib-python || die
}

src_install() {
	local dest=/usr/$(get_libdir)/pypy
	einfo "Installing PyPy ..."
	exeinto "${dest}"
	doexe pypy-c libpypy-c.so
	pax-mark m "${ED%/}${dest}/pypy-c" "${ED%/}${dest}/libpypy-c.so"
	insinto "${dest}"
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

	# Install docs
	use doc && dodoc -r pypy/doc/_build/html

	einfo "Generating caches and byte-compiling ..."

	local -x PYTHON=${ED%/}${dest}/pypy-c
	local -x LD_LIBRARY_PATH="${ED%/}${dest}"
	# we can't use eclass function since PyPy is dumb and always gives
	# paths relative to the interpreter
	local PYTHON_SITEDIR=${EPREFIX}/usr/$(get_libdir)/pypy/site-packages
	python_export pypy EPYTHON

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
#    "gdbm": "_gdbm_build.py"  if sys.platform != "win32" else None,
#    "pwdgrp": "_pwdgrp_build.py" if sys.platform != "win32" else None,
#    "resource": "_resource_build.py" if sys.platform != "win32" else None,
	cffi_targets=( audioop syslog pwdgrp resource )
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
