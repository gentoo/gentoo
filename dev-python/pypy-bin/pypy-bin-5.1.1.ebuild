# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )
inherit eutils multilib pax-utils python-any-r1 unpacker versionator

BINHOST="https://dev.gentoo.org/~mgorny/dist/pypy-bin/${PV}"
CPY_PATCHSET_VERSION="2.7.11-0"

DESCRIPTION="Pre-built version of PyPy"
HOMEPAGE="http://pypy.org/"
SRC_URI="https://bitbucket.org/pypy/pypy/downloads/pypy-${PV}-src.tar.bz2
	https://dev.gentoo.org/~djc/python-gentoo-patches-${CPY_PATCHSET_VERSION}.tar.xz
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
IUSE="doc gdbm +jit +shadowstack sqlite cpu_flags_x86_sse2 test tk"

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
	!dev-python/pypy:0"
DEPEND="${RDEPEND}
	app-arch/lzip
	app-arch/xz-utils
	doc? ( ${PYTHON_DEPS}
		dev-python/sphinx )"
PDEPEND="app-admin/python-updater"

S=${WORKDIR}/pypy-${PV}-src

QA_PREBUILT="
	usr/lib*/pypy/pypy-c
	usr/lib*/pypy/libpypy-c.so"

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		use doc && python-any-r1_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}/4.0.0-gentoo-path.patch" \
		"${FILESDIR}/1.9-distutils.unixccompiler.UnixCCompiler.runtime_library_dir_option.patch"

	sed -e "s^@EPREFIX@^${EPREFIX}^" \
		-e "s^@libdir@^$(get_libdir)^" \
		-i lib-python/2.7/distutils/command/install.py || die

	# apply CPython stdlib patches
	pushd lib-python/2.7 > /dev/null || die
	epatch "${FILESDIR}"/2.5.0_all_distutils_cxx.patch \
		"${WORKDIR}"/patches/22_all_turkish_locale.patch \
		"${WORKDIR}"/patches/62_all_xml.use_pyxml.patch
	popd > /dev/null || die

	epatch_user
}

src_compile() {
	# Tadaam! PyPy compiled!
	mv "${WORKDIR}"/${P}*/{libpypy-c.so,pypy-c} . || die
	mv "${WORKDIR}"/${P}*/include/*.h include/ || die
	mv pypy/module/cpyext/include/*.h include/ || die
	mv pypy/module/cpyext/include/numpy include/ || die

	use doc && emake -C pypy/doc/ html
	#needed even without jit :( also needed in both compile and install phases
	pax-mark m pypy-c libpypy-c.so
}

src_test() {
	# (unset)
	local -x PYTHONDONTWRITEBYTECODE

	./pypy-c ./pypy/test_all.py --pypy=./pypy-c lib-python || die
}

src_install() {
	local dest=/usr/$(get_libdir)/pypy
	einfo "Installing PyPy ..."
	insinto "${dest}"
	doins -r include lib_pypy lib-python pypy-c libpypy-c.so
	fperms a+x ${dest}/pypy-c ${dest}/libpypy-c.so
	pax-mark m "${ED%/}${dest}/pypy-c" "${ED%/}${dest}/libpypy-c.so"
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
	use doc && dohtml -r pypy/doc/_build/html/

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
	cffi_targets=( audioop curses syslog gdbm pwdgrp resource )
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
