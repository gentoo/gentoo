# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Radeon Open Compute llvm,lld,clang"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm/"
SRC_URI="https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz -> llvm-rocm-ocl-${PV}.tar.gz"

LICENSE="UoI-NCSA rc BSD public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="virtual/cblas
	dev-libs/rocr-runtime"
DEPEND="${RDEPEND}"

S="${WORKDIR}/llvm-project-rocm-${PV}/llvm"

CMAKE_BUILD_TYPE=RelWithDebInfo

src_prepare() {
	cd "${WORKDIR}/llvm-project-rocm-${PV}" || die
	eapply "${FILESDIR}/${PN}-3.0.0-add_libraries.patch"
	eapply_user
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/roc"
		-DLLVM_ENABLE_PROJECTS="clang;lld"
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
		-DLLVM_BUILD_DOCS=NO
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_SPHINX=NO
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_INSTALL_UTILS=ON
		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
	)

	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	cmake_src_configure
}

src_install() {
	cmake_src_install
	cat > "99${PN}" <<-EOF
		LDPATH="${EROOT}/usr/lib/llvm/roc/lib"
	EOF
	doenvd "99${PN}"
}
