# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python2_7 )
inherit pax-utils python-any-r1 toolchain-funcs

PYPY_PV=${PV%_p*}
MY_P=pypy3.9-v${PYPY_PV/_rc/rc}
PATCHSET="pypy3.9-gentoo-patches-${PV/_rc/rc}"

DESCRIPTION="A fast, compliant alternative implementation of the Python (3.9) language"
HOMEPAGE="
	https://www.pypy.org/
	https://foss.heptapod.net/pypy/pypy/
"
SRC_URI="
	https://buildbot.pypy.org/pypy/${MY_P}-src.tar.bz2
	https://dev.gentoo.org/~mgorny/dist/python/${PATCHSET}.tar.xz
"
S="${WORKDIR}/${MY_P}-src"

LICENSE="MIT"
# pypy3 -c 'import sysconfig; print(sysconfig.get_config_var("SOABI"))'
# also check pypy/interpreter/pycode.py -> pypy_incremental_magic
SLOT="0/pypy39-pp73-336"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 +ensurepip gdbm +jit ncurses sqlite test tk"
# many tests are failing upstream
# see https://buildbot.pypy.org/summary?branch=py3.9
RESTRICT="test"

RDEPEND="
	|| (
		>=dev-python/pypy3-exe-${PYPY_PV}_p3:3.9-${PYPY_PV}[bzip2?,ncurses?]
		>=dev-python/pypy3-exe-bin-${PYPY_PV}_p3:3.9-${PYPY_PV}
	)
	dev-lang/python-exec[python_targets_pypy3(-)]
	dev-libs/openssl:0=
	ensurepip? ( dev-python/ensurepip-wheels )
	gdbm? ( sys-libs/gdbm:0= )
	sqlite? ( dev-db/sqlite:3= )
	tk? (
		dev-lang/tk:0=
		dev-tcltk/tix:0=
	)
	!<dev-python/pypy3-bin-7.3.0:0
"
DEPEND="
	${RDEPEND}
	test? (
		${PYTHON_DEPS}
		!!dev-python/pytest-forked
	)
"

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
	mkdir include/pypy3.9 || die
	# copy over to make sys.prefix happy
	cp -p "${BROOT}"/usr/bin/pypy3.9-c-${PYPY_PV} pypy3.9-c || die
	cp -p "${BROOT}"/usr/include/pypy3.9/${PYPY_PV}/* include/pypy3.9/ || die
	# (not installed by pypy-exe)
	rm pypy/module/cpyext/include/_numpypy/numpy/README || die
	mv pypy/module/cpyext/include/* include/pypy3.9/ || die
	mv pypy/module/cpyext/parse/*.h include/pypy3.9/ || die
	pax-mark m pypy3.9-c

	# verify the subslot
	local soabi=$(
		./pypy3.9-c - <<-EOF
			import importlib.util
			import sysconfig
			soabi = sysconfig.get_config_var("SOABI")
			magic = importlib.util._RAW_MAGIC_NUMBER & 0xffff
			print(f"{soabi}-{magic}")
		EOF
	)
	[[ ${soabi} == ${SLOT#*/} ]] || die "update subslot to ${soabi}"

	# Add epython.py to the distribution
	echo "EPYTHON='${EPYTHON}'" > lib-python/3/epython.py || die

	einfo "Generating caches and CFFI modules ..."

	# Generate Grammar and PatternGrammar pickles.
	./pypy3.9-c - <<-EOF || die "Generation of Grammar and PatternGrammar pickles failed"
		import lib2to3.pygram
		import lib2to3.patcomp
		lib2to3.patcomp.PatternCompiler()
	EOF

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
		../pypy3.9-c "_${t}_build.py" || die "Failed to build CFFI bindings for ${t}"
	done

	# Verify that CFFI module list is up-to-date
	local expected_cksum=63d4659f
	local local_cksum=$(
		../pypy3.9-c - <<-EOF
			import binascii
			import json
			from pypy_tools.build_cffi_imports import cffi_build_scripts as x
			print("%08x" % (binascii.crc32(json.dumps(x).encode()),))
		EOF
	)
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
	"${EPYTHON}" ./pypy/test_all.py --pypy=./pypy3.9-c -vv lib-python || die
}

src_install() {
	einfo "Installing PyPy ..."
	dodir /usr/bin
	dosym pypy3.9-c-${PYPY_PV} /usr/bin/pypy3.9
	dosym pypy3.9 /usr/bin/pypy3
	insinto /usr/lib/pypy3.9
	# preserve mtimes to avoid obsoleting caches
	insopts -p
	doins -r lib-python/3/. lib_pypy/.
	insinto /usr/include
	doins -r include/pypy3.9

	# replace copied headers with symlinks
	for x in "${BROOT}"/usr/include/pypy3.9/${PYPY_PV}/*; do
		dosym "${PYPY_PV}/${x##*/}" "/usr/include/pypy3.9/${x##*/}"
	done

	dodoc README.rst

	local dest=/usr/lib/pypy3.9
	rm -r "${ED}${dest}"/ensurepip/_bundled || die
	if ! use ensurepip; then
		rm -r "${ED}${dest}"/ensurepip || die
	fi
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
	local -x PYTHON=${ED}/usr/bin/pypy3.9-c-${PYPY_PV}
	# temporarily copy to build tree to facilitate module builds
	cp -p "${BROOT}/usr/bin/pypy3.9-c-${PYPY_PV}" "${PYTHON}" || die

	einfo "Byte-compiling Python standard library..."
	python_optimize "${ED}${dest}"

	# remove to avoid collisions
	rm "${PYTHON}" || die
}
