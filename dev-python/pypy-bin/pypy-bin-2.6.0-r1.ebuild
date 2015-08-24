# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )
inherit eutils multilib pax-utils python-any-r1 versionator

BINHOST="https://dev.gentoo.org/~mgorny/dist/pypy-bin/${PV}"
CPY_PATCHSET_VERSION="2.7.10-0"

DESCRIPTION="A fast, compliant alternative implementation of the Python language (binary package)"
HOMEPAGE="http://pypy.org/"
SRC_URI="https://bitbucket.org/pypy/pypy/downloads/pypy-${PV}-src.tar.bz2
	https://dev.gentoo.org/~floppym/python/python-gentoo-patches-${CPY_PATCHSET_VERSION}.tar.xz
	amd64? (
		jit? ( shadowstack? (
			${BINHOST}/${P}-amd64+bzip2+jit+ncurses+shadowstack.tar.xz
		) )
		jit? ( !shadowstack? (
			${BINHOST}/${P}-amd64+bzip2+jit+ncurses.tar.xz
		) )
		!jit? ( !shadowstack? (
			${BINHOST}/${P}-amd64+bzip2+ncurses.tar.xz
		) )
	)
	x86? (
		cpu_flags_x86_sse2? (
			jit? ( shadowstack? (
				${BINHOST}/${P}-x86+bzip2+jit+ncurses+shadowstack+sse2.tar.xz
			) )
			jit? ( !shadowstack? (
				${BINHOST}/${P}-x86+bzip2+jit+ncurses+sse2.tar.xz
			) )
			!jit? ( !shadowstack? (
				${BINHOST}/${P}-x86+bzip2+ncurses+sse2.tar.xz
			) )
		)
		!cpu_flags_x86_sse2? (
			!jit? ( !shadowstack? (
				${BINHOST}/${P}-x86+bzip2+ncurses.tar.xz
			) )
		)
	)"

# Supported variants
REQUIRED_USE="!jit? ( !shadowstack )
	x86? ( !cpu_flags_x86_sse2? ( !jit !shadowstack ) )"

LICENSE="MIT"
SLOT="0/$(get_version_component_range 1-2 ${PV})"
KEYWORDS="~amd64 ~x86"
IUSE="doc gdbm +jit shadowstack sqlite cpu_flags_x86_sse2 test tk"

# yep, world would be easier if people started filling subslots...
RDEPEND="
	app-arch/bzip2:0
	dev-libs/expat:0
	dev-libs/libffi:0
	dev-libs/openssl:0[-bindist]
	sys-libs/glibc:2.2
	sys-libs/ncurses:5/5
	sys-libs/zlib:0
	gdbm? ( sys-libs/gdbm:0= )
	sqlite? ( dev-db/sqlite:3= )
	tk? (
		dev-lang/tk:0=
		dev-tcltk/tix:0=
	)
	!dev-python/pypy:0"
DEPEND="app-arch/xz-utils
	doc? ( ${PYTHON_DEPS}
		dev-python/sphinx )
	test? ( ${RDEPEND} )"
PDEPEND="app-admin/python-updater"

S=${WORKDIR}/pypy-${PV}-src

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		use doc && python-any-r1_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}/1.9-scripts-location.patch" \
		"${FILESDIR}/1.9-distutils.unixccompiler.UnixCCompiler.runtime_library_dir_option.patch"

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
	pax-mark m pypy-c

	# ctypes config cache
	# this one we need to do with python2 too...
	./pypy-c lib_pypy/ctypes_config_cache/rebuild.py \
		|| die "Failed to rebuild ctypes config cache"
}

src_test() {
	# (unset)
	local -x PYTHONDONTWRITEBYTECODE

	./pypy-c ./pypy/test_all.py --pypy=./pypy-c lib-python || die
}

src_install() {
	einfo "Installing PyPy ..."
	insinto "/usr/$(get_libdir)/pypy"
	doins -r include lib_pypy lib-python pypy-c libpypy-c.so
	fperms a+x ${INSDESTTREE}/pypy-c ${INSDESTTREE}/libpypy-c.so
	pax-mark m "${ED%/}${INSDESTTREE}/pypy-c" "${ED%/}${INSDESTTREE}/libpypy-c.so"
	dosym ../$(get_libdir)/pypy/pypy-c /usr/bin/pypy
	dodoc README.rst

	if ! use gdbm; then
		rm -r "${ED%/}${INSDESTTREE}"/lib_pypy/gdbm.py \
			"${ED%/}${INSDESTTREE}"/lib-python/*2.7/test/test_gdbm.py || die
	fi
	if ! use sqlite; then
		rm -r "${ED%/}${INSDESTTREE}"/lib-python/*2.7/sqlite3 \
			"${ED%/}${INSDESTTREE}"/lib_pypy/_sqlite3.py \
			"${ED%/}${INSDESTTREE}"/lib-python/*2.7/test/test_sqlite.py || die
	fi
	if ! use tk; then
		rm -r "${ED%/}${INSDESTTREE}"/lib-python/*2.7/{idlelib,lib-tk} \
			"${ED%/}${INSDESTTREE}"/lib_pypy/_tkinter \
			"${ED%/}${INSDESTTREE}"/lib-python/*2.7/test/test_{tcl,tk,ttk*}.py || die
	fi

	# Install docs
	use doc && dohtml -r pypy/doc/_build/html/

	einfo "Generating caches and byte-compiling ..."

	python_export pypy EPYTHON PYTHON PYTHON_SITEDIR
	local PYTHON=${ED%/}${INSDESTTREE}/pypy-c
	local -x LD_LIBRARY_PATH="${ED%/}${INSDESTTREE}"

	echo "EPYTHON='${EPYTHON}'" > epython.py
	python_domodule epython.py

	# Generate Grammar and PatternGrammar pickles.
	"${PYTHON}" -c "import lib2to3.pygram, lib2to3.patcomp; lib2to3.patcomp.PatternCompiler()" \
		|| die "Generation of Grammar and PatternGrammar pickles failed"

	# Generate cffi modules
	# Please keep in sync with pypy/tool/release/package.py!
#cffi_build_scripts = {
#    "sqlite3": "_sqlite3_build.py",
#    "audioop": "_audioop_build.py",
#    "tk": "_tkinter/tklib_build.py",
#    "curses": "_curses_build.py" if sys.platform != "win32" else None,
#    "syslog": "_syslog_build.py" if sys.platform != "win32" else None,
#    "gdbm": "_gdbm_build.py"  if sys.platform != "win32" else None,
#    "pwdgrp": "_pwdgrp_build.py" if sys.platform != "win32" else None,
	cffi_targets=( audioop curses syslog gdbm pwdgrp )
	use gdbm && cffi_targets+=( gdbm )
	use sqlite && cffi_targets+=( sqlite3 )
	use tk && cffi_targets+=( tkinter/tklib )

	local t
	# all modules except tkinter output to .
	# tkinter outputs to the correct dir ...
	cd "${ED%/}${INSDESTTREE}"/lib_pypy || die
	for t in "${cffi_targets[@]}"; do
		# tkinter doesn't work via -m
		"${PYTHON}" "_${t}_build.py" || die "Failed to build CFFI bindings for ${t}"
	done

	# Cleanup temporary objects
	find "${ED%/}${INSDESTTREE}" -name "_cffi_*.[co]" -delete || die
	find "${ED%/}${INSDESTTREE}" -type d -empty -delete || die

	# compile the installed modules
	python_optimize "${ED%/}${INSDESTTREE}"
}
