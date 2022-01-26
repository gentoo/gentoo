# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib python-single-r1 llvm llvm.org

DESCRIPTION="Flang is a ground-up implementation of a Fortran front end written in modern C++"
HOMEPAGE=" https://github.com/llvm/llvm-project/tree/main/flang
		http://flang.llvm.org/docs/"
SRC_URI="
	https://src.fedoraproject.org/rpms/flang/raw/rawhide/f/0001-Link-against-libclang-cpp.so.patch -> flang-Link-against-libclang-cpp.so.patch
	https://src.fedoraproject.org/rpms/flang/raw/rawhide/f/0001-PATCH-flang-Disable-use-of-sphinx_markdown_tables.patch -> flang-PATCH-flang-Disable-use-of-sphinx_markdown_tables.patch
"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT"
SLOT="13"
IUSE="doc test"
KEYWORDS="~amd64"

DEPEND="
	>=sys-devel/clang-13.0.0:13=[static-analyzer,${MULTILIB_USEDEP}]
	sys-devel/llvm:13=[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}"

BDEPEND="
	doc? (
		dev-python/sphinx
		app-doc/doxygen[dot]
	)
	test? (
		dev-python/lit
	)
	sys-devel/mlir:13=
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

LLVM_MAX_SLOT=13
LLVM_COMPONENTS=( flang )
llvm.org_set_globals

src_unpack() {
	unpack llvmorg-${PV}.tar.gz
	mv "${WORKDIR}/llvm-project-llvmorg-${PV}/flang" "${WORKDIR}/flang" || die
}

src_prepare() {
	eapply -p2 "${DISTDIR}/flang-Link-against-libclang-cpp.so.patch"
	eapply -p2 "${DISTDIR}/flang-PATCH-flang-Disable-use-of-sphinx_markdown_tables.patch"
	eapply_user
	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-GNinja
		-DCMAKE_INSTALL_PREFIX="${BROOT}/usr/lib/llvm/${SLOT}"
		-DMLIR_TABLEGEN_EXE="${BROOT}/usr/lib/llvm/${SLOT}/bin/mlir-tblgen"
		-DCMAKE_BUILD_TYPE=Release
		-DCLANG_DIR="${BROOT}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/clang/"
		-DMLIR_DIR="${BROOT}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/mlir/"
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DLLVM_LINK_LLVM_DYLIB:BOOL=ON
		-DLLVM_ENABLE_THREADS=ON

		-DCMAKE_PREFIX_PATH="${BROOT}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/llvm/"
		-Wno-dev
		)
		use doc &&  mycmakeargs+=(
			-DLLVM_ENABLE_SPHINX:BOOL=ON
			-DLLVM_ENABLE_DOXYGEN=ON
			-DFLANG_INCLUDE_DOCS=ON
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
			-DSPHINX_EXECUTABLE=/usr/bin/sphinx-build
		)
		use test && mycmakeargs+=(
				-DLLVM_BUILD_TESTS=ON
				-DLLVM_EXTERNAL_LIT="${BROOT}"/usr/bin//lit
				-DPython3_EXECUTABLE="${PYTHON}"
		)
	cmake_src_configure
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
	echo "Number of jobs " ${_jobs}
	cmake_src_compile
	if use doc ; then
		cmake_src_compile doxygen-flang
	fi
}

pkg_postinst() {
	elog "You should consider switching to the clamg/clamg++ "
	elog " for flang if you didn't that. See: "
	elog " https://wiki.gentoo.org/wiki/Clang#Clang_environments "
}
