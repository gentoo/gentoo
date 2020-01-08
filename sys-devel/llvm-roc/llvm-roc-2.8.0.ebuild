# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Radeon Open Compute llvm,lld,clang"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm/"
SRC_URI="https://github.com/RadeonOpenCompute/llvm/archive/roc-ocl-${PV}.tar.gz -> llvm-roc-ocl-${PV}.tar.gz
	https://github.com/RadeonOpenCompute/clang/archive/roc-${PV}.tar.gz -> clang-roc-${PV}.tar.gz
	https://github.com/RadeonOpenCompute/lld/archive/roc-ocl-${PV}.tar.gz -> lld-roc-ocl-${PV}.tar.gz"

LICENSE="UoI-NCSA rc BSD public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="virtual/cblas
	 dev-libs/rocr-runtime"
DEPEND="${RDEPEND}"

CMAKE_BUILD_TYPE=RelWithDebInfo

S="${WORKDIR}/llvm-roc-ocl-${PV}"

src_unpack() {
	unpack ${A}
	ln -s "${WORKDIR}/clang-roc-${PV}" "${WORKDIR}/llvm-roc-ocl-${PV}/tools/clang"
	ln -s "${WORKDIR}/lld-roc-ocl-${PV}" "${WORKDIR}/llvm-roc-ocl-${PV}/tools/lld"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/roc"
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" "${S}"
		-DLLVM_BUILD_DOCS=NO
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_SPHINX=NO
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_INSTALL_UTILS=ON
		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
	)
	cmake_src_configure
}
src_install(){
	cmake_src_install
	cat > "99${PN}" <<-EOF
		LDPATH="${EROOT}/usr/lib/llvm/roc/lib"
	EOF
	doenvd "99${PN}"
}
