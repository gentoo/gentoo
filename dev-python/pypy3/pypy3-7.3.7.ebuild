# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit pax-utils python-any-r1 toolchain-funcs

PYPY_PV=${PV%_p*}
MY_P=pypy3.8-v${PYPY_PV/_rc/rc}
PATCHSET="pypy3.8-gentoo-patches-${PV/_rc/rc}"

DESCRIPTION="A fast, compliant alternative implementation of the Python (3.8) language"
HOMEPAGE="https://www.pypy.org/"
SRC_URI="https://buildbot.pypy.org/pypy/${MY_P}-src.tar.bz2
	https://dev.gentoo.org/~mgorny/dist/python/${PATCHSET}.tar.xz"
S="${WORKDIR}/${MY_P}-src"

LICENSE="MIT"
# pypy3 -c 'import sysconfig; print(sysconfig.get_config_var("SOABI"))'
# also check pypy/interpreter/pycode.py -> pypy_incremental_magic
SLOT="0/pypy38-pp73"
KEYWORDS="amd64 ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 gdbm +jit ncurses sqlite test tk"
# pypy3.8 is in alpha state and many tests are failing
RESTRICT="test"

RDEPEND="
	|| (
		>=dev-python/pypy3-exe-${PYPY_PV}:${PYPY_PV}[bzip2?,ncurses?]
		>=dev-python/pypy3-exe-bin-${PYPY_PV}:${PYPY_PV}
	)
	dev-libs/openssl:0=
	gdbm? ( sys-libs/gdbm:0= )
	sqlite? ( dev-db/sqlite:3= )
	tk? (
		dev-lang/tk:0=
		dev-tcltk/tix:0=
	)
	!<dev-python/pypy3-bin-7.3.0:0"
DEPEND="${RDEPEND}
	test? (
		${PYTHON_DEPS}
		!!dev-python/pytest-forked
	)"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	local PATCHES=(
		"${WORKDIR}/${PATCHSET}"
	)
	default

	eapply_user
}

src_configure() {
	tc-export CC
}

src_compile() {
	mkdir bin || die
	# switch to the layout expected for cffi module builds
	mkdir include/pypy3.8 || die
	cp include/*.h include/pypy3.8/ || die
	# copy over to make sys.prefix happy
	cp -p "${BROOT}"/usr/bin/pypy3-c-${PYPY_PV} pypy3-c || die
	cp -p "${BROOT}"/usr/include/pypy3.8/${PYPY_PV}/* include/pypy3.8/ || die
	# (not installed by pypy-exe)
	rm pypy/module/cpyext/include/_numpypy/numpy/README || die
	mv pypy/module/cpyext/include/* include/pypy3.8/ || die
	mv pypy/module/cpyext/parse/*.h include/pypy3.8/ || die
	pax-mark m pypy3-c

	# verify the subslot
	local soabi=$(./pypy3-c -c 'import sysconfig; print(sysconfig.get_config_var("SOABI"))')
	[[ ${soabi} == ${SLOT#*/} ]] || die "update subslot to ${soabi}"

	einfo "Generating caches and CFFI modules ..."

	# Generate Grammar and PatternGrammar pickles.
	./pypy3-c -c "import lib2to3.pygram, lib2to3.patcomp; lib2to3.patcomp.PatternCompiler()" \
		|| die "Generation of Grammar and PatternGrammar pickles failed"

	# Generate cffi modules
	# Please keep in sync with pypy/tool/build_cffi_imports.py!
	# (NB: we build CFFI modules first to avoid error log when importing
	# build_cffi_imports).
	cffi_targets=( pypy_util blake2/_blake2 sha3/_sha3 ssl
		audioop syslog pwdgrp resource lzma posixshmem )
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

	# Verify that CFFI module list is up-to-date
	local expected_cksum=63d4659f
	local local_cksum=$(../pypy3-c -c '
from pypy_tools.build_cffi_imports import cffi_build_scripts as x;
import binascii, json;
print("%08x" % (binascii.crc32(json.dumps(x).encode()),))')
	if [[ ${local_cksum} != ${expected_cksum} ]]; then
		die "Please verify cffi_targets and update checksum to ${local_cksum}"
	fi

	# Cleanup temporary objects
	find -name "*_cffi.[co]" -delete || die
	find -type d -empty -delete || die
}

src_test() {
	# (unset)
	local -x PYTHONDONTWRITEBYTECODE=
	local -x COLUMNS=80

	# Test runner requires Python 2 too. However, it spawns PyPy3
	# internally so that we end up testing the correct interpreter.
	# (--deselect for failing doctests)
	"${EPYTHON}" ./pypy/test_all.py --pypy=./pypy3-c -vv lib-python || die
}

src_install() {
	einfo "Installing PyPy ..."
	dodir /usr/bin
	dosym pypy3-c-${PYPY_PV} /usr/bin/pypy3
	insinto /usr/lib/pypy3.8
	# preserve mtimes to avoid obsoleting caches
	insopts -p
	doins -r lib-python/3/. lib_pypy/.
	insinto /usr/include
	doins -r include/pypy3.8

	# replace copied headers with symlinks
	for x in "${BROOT}"/usr/include/pypy3.8/${PYPY_PV}/*; do
		dosym "${PYPY_PV}/${x##*/}" "/usr/include/pypy3.8/${x##*/}"
	done

	dodoc README.rst

	local dest=/usr/lib/pypy3.8
	if ! use gdbm; then
		rm -r "${ED}${dest}"/_gdbm* || die
	fi
	if ! use sqlite; then
		rm -r "${ED}${dest}"/sqlite3 \
			"${ED}${dest}"/_sqlite3* \
			"${ED}${dest}"/test/test_sqlite.py || die
	fi
	if ! use tk; then
		rm -r "${ED}${dest}"/{idlelib,tkinter} \
			"${ED}${dest}"/_tkinter \
			"${ED}${dest}"/test/test_{tcl,tk,ttk*}.py || die
	fi

	local -x EPYTHON=pypy3
	local -x PYTHON=${ED}/usr/bin/pypy3-c-${PYPY_PV}
	# temporarily copy to build tree to facilitate module builds
	cp -p "${BROOT}/usr/bin/pypy3-c-${PYPY_PV}" "${PYTHON}" || die

	echo "EPYTHON='${EPYTHON}'" > epython.py || die
	python_moduleinto "${dest}"/site-packages
	python_domodule epython.py

	einfo "Byte-compiling Python standard library..."
	python_optimize "${ED}${dest}"

	# remove to avoid collisions
	rm "${PYTHON}" || die
}
