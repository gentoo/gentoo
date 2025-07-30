# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing pax-utils python-utils-r1 toolchain-funcs

PYVER=$(ver_cut 1-2)
PATCHSET_PV=$(ver_cut 3-)
PYPY_PV=${PATCHSET_PV%_p*}

MY_P="pypy${PYVER}-v${PYPY_PV/_}"
PATCHSET="pypy${PYVER}-gentoo-patches-${PATCHSET_PV/_rc/rc}"

DESCRIPTION="A fast, compliant alternative implementation of the Python (${PYVER}) language"
HOMEPAGE="
	https://pypy.org/
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
SLOT="${PYVER}/pypy311-pp73-416"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"
IUSE="+ensurepip gdbm +jit ncurses sqlite symlink +test-install tk"
# many tests are failing upstream
# see https://buildbot.pypy.org/summary?branch=py${PYVER}
RESTRICT="test"

RDEPEND="
	|| (
		dev-lang/pypy3-exe:${PV%_p*}[bzip2(+),ncurses?]
		dev-lang/pypy3-exe-bin:${PV%_p*}
	)
	dev-lang/python-exec[python_targets_pypy${PYVER/./_}(-)]
	dev-libs/openssl:0=
	dev-python/gentoo-common
	ensurepip? (
		dev-python/ensurepip-pip
		dev-python/ensurepip-setuptools
	)
	gdbm? ( sys-libs/gdbm:0= )
	sqlite? ( dev-db/sqlite:3= )
	tk? (
		dev-lang/tk:0=
		dev-tcltk/tix:0=
	)
	symlink? (
		!dev-lang/pypy:3.10[symlink(-)]
		!<dev-python/pypy3-7.3.17-r100
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
	mkdir "include/pypy${PYVER}" || die
	# copy over to make sys.prefix happy
	cp -p "${BROOT}/usr/bin/pypy${PYVER}-c-${PYPY_PV}" pypy${PYVER}-c || die
	cp -p "${BROOT}/usr/include/pypy${PYVER}/${PYPY_PV}"/* include/pypy${PYVER}/ || die
	# (not installed by pypy-exe)
	rm pypy/module/cpyext/include/_numpypy/numpy/README || die
	mv pypy/module/cpyext/include/* "include/pypy${PYVER}/" || die
	mv pypy/module/cpyext/parse/*.h "include/pypy${PYVER}/" || die
	pax-mark m "pypy${PYVER}-c"

	# verify the subslot
	local soabi=$(
		"./pypy${PYVER}-c" - <<-EOF
			import importlib.util
			import sysconfig
			soabi = sysconfig.get_config_var("SOABI")
			magic = importlib.util._RAW_MAGIC_NUMBER & 0xffff
			print(f"{soabi}-{magic}")
		EOF
	)
	[[ ${soabi} == ${SLOT#*/} ]] || die "update subslot to ${soabi}"

	# Add epython.py to the distribution
	echo "EPYTHON=\"pypy${PYVER}\"" > lib-python/3/epython.py || die

	einfo "Generating caches and CFFI modules ..."

	# Generate Grammar and PatternGrammar pickles.
	"./pypy${PYVER}-c" - <<-EOF || die "Generation of Grammar and PatternGrammar pickles failed"
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
		"../pypy${PYVER}-c" "_${t}_build.py" || die "Failed to build CFFI bindings for ${t}"
	done
	# testcapi does not have a "build" script
	"../pypy${PYVER}-c" -c "import _testcapi" || die

	# Verify that CFFI module list is up-to-date
	local expected_cksum=a4138e48
	local local_cksum=$(
		"../pypy${PYVER}-c" - <<-EOF
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
	cd .. || die

	# Generate sysconfig data
	local host_gnu_type=$(sh pypy/tool/release/config.guess)
	local overrides=(
		HOST_GNU_TYPE "${host_gnu_type:-unknown}"
		INCLUDEPY "${EPREFIX}/usr/include/pypy${PYVER}"
		LIBDIR "${EPREFIX}/usr/$(get_libdir)"
		TZPATH "${EPREFIX}/usr/share/zoneinfo"
		WHEEL_PKG_DIR "${EPREFIX}/usr/lib/python/ensurepip"
	)
	"./pypy${PYVER}-c" -m sysconfig --generate-posix-vars "${overrides[@]}" || die
	local outdir
	outdir=$(<pybuilddir.txt) || die
	cp "${outdir}"/_sysconfigdata__*.py lib-python/3/ || die
}

src_install() {
	local dest="/usr/lib/pypy${PYVER}"
	einfo "Installing PyPy ..."
	dodir /usr/bin
	dosym "pypy${PYVER}-c-${PYPY_PV}" "/usr/bin/pypy${PYVER}"
	insinto "${dest}"
	# preserve mtimes to avoid obsoleting caches
	insopts -p
	doins -r lib-python/3/. lib_pypy/.
	insinto /usr/include
	doins -r "include/pypy${PYVER}"

	# replace copied headers with symlinks
	for x in "${BROOT}/usr/include/pypy${PYVER}/${PYPY_PV}"/*; do
		dosym "${PYPY_PV}/${x##*/}" "/usr/include/pypy${PYVER}/${x##*/}"
	done

	dodoc README.rst

	rm -r "${ED}${dest}"/ensurepip/_bundled || die
	if ! use ensurepip; then
		rm -r "${ED}${dest}"/ensurepip || die
	fi
	if ! use gdbm; then
		rm -r "${ED}${dest}"/_gdbm* || die
	fi
	if ! use test-install; then
		rm -r "${ED}${dest}"/{ctypes,tkinter,unittest}/test \
			"${ED}${dest}"/{distutils,lib2to3}/tests \
			"${ED}${dest}"/idlelib/idle_test || die
	fi
	if ! use sqlite; then
		rm -r "${ED}${dest}"/sqlite3 \
			"${ED}${dest}"/_sqlite3* \
			"${ED}${dest}"/test/test_sqlite3 || die
	fi
	if ! use tk; then
		rm -r "${ED}${dest}"/{idlelib,tkinter} \
			"${ED}${dest}"/_tkinter \
			"${ED}${dest}"/test/test_{tcl,tk,ttk*}.py || die
	fi
	# remove test last since we have some file removals above
	if ! use test-install; then
		rm -r "${ED}${dest}"/test || die
	fi
	dosym ../python/EXTERNALLY-MANAGED "${dest}/EXTERNALLY-MANAGED"

	local -x PYTHON="${ED}/usr/bin/pypy${PYVER}-c-${PYPY_PV}"
	# temporarily copy to build tree to facilitate module builds
	cp -p "${BROOT}/usr/bin/pypy${PYVER}-c-${PYPY_PV}" "${PYTHON}" || die

	einfo "Byte-compiling Python standard library..."
	# exclude list from CPython Makefile.pre.in
	"${PYTHON}" -m compileall -j "$(makeopts_jobs)" -o 0 -o 1 -o 2 \
		-x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data' \
		--hardlink-dupes -q -f -d "${dest}" "${ED}${dest}" || die

	# remove to avoid collisions
	rm "${PYTHON}" || die

	if use symlink; then
		dosym pypy${PYVER} /usr/bin/pypy3

		# install symlinks for python-exec
		local EPYTHON=pypy${PYVER}
		local scriptdir=${D}$(python_get_scriptdir)
		mkdir -p "${scriptdir}" || die
		ln -s "../../../bin/pypy3" "${scriptdir}/python3" || die
		ln -s python3 "${scriptdir}/python" || die
	fi
}
