# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing pax-utils toolchain-funcs

PYPY_PV=${PV%_p*}
PYVER=3.10
MY_P="pypy${PYVER}-v${PYPY_PV/_}"
PATCHSET="pypy${PYVER}-gentoo-patches-${PV/_rc/rc}"

DESCRIPTION="A fast, compliant alternative implementation of the Python (${PYVER}) language"
HOMEPAGE="
	https://www.pypy.org/
	https://github.com/pypy/pypy/
"
SRC_URI="
	https://downloads.python.org/pypy/${MY_P}-src.tar.bz2
	https://buildbot.pypy.org/pypy/${MY_P}-src.tar.bz2
	https://dev.gentoo.org/~mgorny/dist/python/${PATCHSET}.tar.xz
"
S="${WORKDIR}/${MY_P}-src"

LICENSE="MIT"
# pypy3 -c 'import sysconfig; print(sysconfig.get_config_var("SOABI"))'
# also check pypy/interpreter/pycode.py -> pypy_incremental_magic
SLOT="0/pypy310-pp73-384"
KEYWORDS="~amd64 ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+ensurepip gdbm +jit ncurses sqlite tk"
# many tests are failing upstream
# see https://buildbot.pypy.org/summary?branch=py${PYVER}
RESTRICT="test"

RDEPEND="
	|| (
		>=dev-python/${PN}-exe-${PYPY_PV}:${PYPY_PV}[bzip2(+),ncurses?]
		>=dev-python/${PN}-exe-bin-${PYPY_PV}:${PYPY_PV}
	)
	dev-lang/python-exec[python_targets_pypy3(-)]
	dev-libs/openssl:0=
	dev-python/gentoo-common
	ensurepip? ( dev-python/ensurepip-wheels )
	gdbm? ( sys-libs/gdbm:0= )
	sqlite? ( dev-db/sqlite:3= )
	tk? (
		dev-lang/tk:0=
		dev-tcltk/tix:0=
	)
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	local PATCHES=(
		"${WORKDIR}/${PATCHSET}"
	)

	default
}

src_configure() {
	tc-export CC
}

src_compile() {
	mkdir bin || die
	# switch to the layout expected for cffi module builds
	mkdir include/pypy${PYVER} || die
	# copy over to make sys.prefix happy
	cp -p "${BROOT}"/usr/bin/pypy${PYVER}-c-${PYPY_PV} pypy${PYVER}-c || die
	cp -p "${BROOT}"/usr/include/pypy${PYVER}/${PYPY_PV}/* include/pypy${PYVER}/ || die
	# (not installed by pypy-exe)
	rm pypy/module/cpyext/include/_numpypy/numpy/README || die
	mv pypy/module/cpyext/include/* include/pypy${PYVER}/ || die
	mv pypy/module/cpyext/parse/*.h include/pypy${PYVER}/ || die
	pax-mark m pypy${PYVER}-c

	# verify the subslot
	local soabi=$(
		./pypy${PYVER}-c - <<-EOF
			import importlib.util
			import sysconfig
			soabi = sysconfig.get_config_var("SOABI")
			magic = importlib.util._RAW_MAGIC_NUMBER & 0xffff
			print(f"{soabi}-{magic}")
		EOF
	)
	[[ ${soabi} == ${SLOT#*/} ]] || die "update subslot to ${soabi}"

	# Add epython.py to the distribution
	echo 'EPYTHON="pypy3"' > lib-python/3/epython.py || die

	einfo "Generating caches and CFFI modules ..."

	# Generate sysconfig data
	local host_gnu_type=$(sh pypy/tool/release/config.guess)
	local overrides=(
		HOST_GNU_TYPE "${host_gnu_type:-unknown}"
		INCLUDEPY "${EPREFIX}/usr/include/pypy${PYVER}"
		LIBDIR "${EPREFIX}/usr/$(get_libdir)"
		TZPATH "${EPREFIX}/usr/share/zoneinfo"
		WHEEL_PKG_DIR "${EPREFIX}/usr/lib/python/ensurepip"
	)
	./pypy${PYVER}-c -m sysconfig --generate-posix-vars "${overrides[@]}" || die
	local outdir
	outdir=$(<pybuilddir.txt) || die
	cp "${outdir}"/_sysconfigdata__*.py lib-python/3/ || die

	# Generate Grammar and PatternGrammar pickles.
	./pypy${PYVER}-c - <<-EOF || die "Generation of Grammar and PatternGrammar pickles failed"
		import lib2to3.pygram
		import lib2to3.patcomp
		lib2to3.patcomp.PatternCompiler()
	EOF

	# Generate cffi modules
	# Please keep in sync with lib_pypy/pypy_tools/build_cffi_imports.py!
	# (NB: we build CFFI modules first to avoid error log when importing
	# build_cffi_imports).
	cffi_targets=(
		pypy_util blake2/_blake2 sha3/_sha3 ssl
		audioop syslog pwdgrp resource lzma posixshmem
		ctypes_test testmultiphase
	)
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
		../pypy${PYVER}-c "_${t}_build.py" || die "Failed to build CFFI bindings for ${t}"
	done
	# testcapi does not have a "build" script
	../pypy${PYVER}-c -c "import _testcapi" || die

	# Verify that CFFI module list is up-to-date
	local expected_cksum=a4138e48
	local local_cksum=$(
		../pypy${PYVER}-c - <<-EOF
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
	find \( -name "*_cffi.c" -o -name '*.o' \) -delete || die
	find -type d -empty -delete || die
}

src_install() {
	einfo "Installing PyPy ..."
	dodir /usr/bin
	dosym pypy${PYVER}-c-${PYPY_PV} /usr/bin/pypy${PYVER}
	insinto /usr/lib/pypy${PYVER}
	# preserve mtimes to avoid obsoleting caches
	insopts -p
	doins -r lib-python/3/. lib_pypy/.
	insinto /usr/include
	doins -r include/pypy${PYVER}

	# replace copied headers with symlinks
	for x in "${BROOT}"/usr/include/pypy${PYVER}/${PYPY_PV}/*; do
		dosym "${PYPY_PV}/${x##*/}" "/usr/include/pypy${PYVER}/${x##*/}"
	done

	dodoc README.rst

	local dest=/usr/lib/pypy${PYVER}
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
	dosym ../python/EXTERNALLY-MANAGED "${dest}/EXTERNALLY-MANAGED"

	local -x PYTHON=${ED}/usr/bin/pypy${PYVER}-c-${PYPY_PV}
	# temporarily copy to build tree to facilitate module builds
	cp -p "${BROOT}/usr/bin/pypy${PYVER}-c-${PYPY_PV}" "${PYTHON}" || die

	einfo "Byte-compiling Python standard library..."
	# exclude list from CPython Makefile.pre.in
	"${PYTHON}" -m compileall -j "$(makeopts_jobs)" -o 0 -o 1 -o 2 \
		-x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' \
		--hardlink-dupes -q -f -d "${dest}" "${ED}${dest}" || die

	# remove to avoid collisions
	rm "${PYTHON}" || die
}
