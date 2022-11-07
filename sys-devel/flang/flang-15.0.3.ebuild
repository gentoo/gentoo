# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake llvm llvm.org  multilib-minimal \
	python-single-r1

DESCRIPTION="Flang is a ground-up implementation of a Fortran front end written in modern C++"
HOMEPAGE=" https://github.com/llvm/llvm-project/tree/main/flang
		http://flang.llvm.org/docs/"
SRC_URI="
	https://src.fedoraproject.org/rpms/flang/raw/rawhide/f/link-against-libclang-cpp.patch -> flang-Link-against-libclang-cpp.patch
	https://src.fedoraproject.org/rpms/flang/raw/rawhide/f/0001-PATCH-flang-Disable-use-of-sphinx_markdown_tables.patch -> flang-PATCH-flang-Disable-use-of-sphinx_markdown_tables.patch
	https://src.fedoraproject.org/rpms/flang/raw/rawhide/f/0001-flang-docs-nfc-Refine-FlangOptionsDocs.td.patch -> flang-PATCH-flang-docs-nfc-Refine-FlangOptionsDocs.td.patch
	https://src.fedoraproject.org/rpms/flang/raw/rawhide/f/0001-Use-find_program-for-clang-tblgen.patch -> flang-PATCH-Use-find_program-for-clang-tblgen.patch
"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT"
SLOT="$(ver_cut 1)"
vver="$(ver_cut 1-3)"
IUSE="doc test"
KEYWORDS="~amd64"

RDEPEND="
	${PYTHON_DEPS}
	sys-devel/clang:${SLOT}=[${MULTILIB_USEDEP}]
	sys-devel/mlir:${SLOT}=[${MULTILIB_USEDEP}]
	>=sys-devel/clang-common-${vver}:0=[default-libcxx]
	>=sys-devel/clang-runtime-${vver}:${vver}=[libcxx]
	"
DEPEND="${RDEPEND}
"

BDEPEND="
	doc? (
		dev-python/sphinx
		app-doc/doxygen[dot]
	)
	test? (
		dev-python/lit
	)
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

LLVM_COMPONENTS=( flang cmake )
llvm.org_set_globals

pkg_setup() {
	LLVM_MAX_SLOT=${SLOT} llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	mkdir -p x/y || die
	BUILD_DIR=${WORKDIR}/x/y/flang
	eapply -p2 "${DISTDIR}/flang-Link-against-libclang-cpp.patch"
	eapply -p2 "${DISTDIR}/flang-PATCH-flang-Disable-use-of-sphinx_markdown_tables.patch"
	eapply -p2 "${DISTDIR}/flang-PATCH-flang-docs-nfc-Refine-FlangOptionsDocs.td.patch"
	eapply -p2 "${DISTDIR}/flang-PATCH-Use-find_program-for-clang-tblgen.patch"
	llvm.org_src_prepare
}

multilib_src_configure() {

	local mycmakeargs=(
		-GNinja
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
		-DMLIR_TABLEGEN_EXE="${EPREFIX}/usr/lib/llvm/${SLOT}/bin/mlir-tblgen"
		-DCMAKE_BUILD_TYPE=Release
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/llvm/"
		-DCLANG_DIR="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/clang/"
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/llvm/"
		-DMLIR_DIR="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/mlir/"
		-DBUILD_SHARED_LIBS:BOOL=ON
		#-DBUILD_SHARED_LIBS=OFF
		-DLLVM_LINK_LLVM_DYLIB:BOOL=ON
		-DLLVM_ENABLE_THREADS=ON

		-DFLANG_INCLUDE_TESTS=OFF
		-DLLVM_EXTERNAL_LIT="${EPREFIX}"/usr/bin//lit
		#-Wno-dev
		)
		use doc &&  mycmakeargs+=(
			-DLLVM_ENABLE_SPHINX:BOOL=ON
			-DLLVM_ENABLE_DOXYGEN=ON
			-DFLANG_INCLUDE_DOCS=ON
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
			-DSPHINX_EXECUTABLE="${EPREFIX}"/usr/bin/sphinx-build
		)
		use test && mycmakeargs+=(
				-DLLVM_BUILD_TESTS=ON
				-DLLVM_EXTERNAL_LIT="${EPREFIX}"/usr/bin//lit
				-DPython3_EXECUTABLE="${PYTHON}"
		)
	cmake_src_configure
	multilib_is_native_abi && check_distribution_components
}

multilib_src_compile() {
	export LD_LIBRARY_PATH="${BUILD_DIR}/lib"
	# comes from arch linux :) thanks
	# try to figure out a reasonable CMAKE_BUILD_PARALLEL_LEVEL
	if [ -z "${CMAKE_BUILD_PARALLEL_LEVEL+x}" ]; then
		# figure about 1 job per 2GB RAM - I increased to 4 GB
		local _jobs=$(awk '{ if ($1 == "MemTotal:") { printf "%.0f", $2/(2*2*1024*1024) } }' /proc/meminfo)
		# EXCEPT on GHA, which is being really difficult.
		if (( _jobs < 1 )) || [ -n "${CI+x}" ]; then
			_jobs=1
		elif (( _jobs > $(nproc) + 2 )); then
			_jobs=$(( $(nproc) + 2 ))
		fi
		export CMAKE_BUILD_PARALLEL_LEVEL=${_jobs}
		export MAKEOPTS=-j${_jobs}
	fi
	cmake_src_compile
	if use doc ; then
		##cmake_src_compile doxygen-flang
		cmake_build --target docs-flang-html
	fi
}

multilib_src_install() {
	DESTDIR=${D} cmake_build install
}
