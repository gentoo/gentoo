# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/"
	inherit git-r3
	S="${WORKDIR}/${P}/lib/comgr"
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/archive/roc-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCm-CompilerSupport-roc-${PV}/lib/comgr"
	KEYWORDS="~amd64"
fi
PATCHES=(
	"${FILESDIR}/${P}-correctly-install.patch"
	"${FILESDIR}/${P}-find-clang.patch"
	"${FILESDIR}/${P}-find-lld-includes.patch"
	"${FILESDIR}/${P}-dependencies.patch"
	"${FILESDIR}/${P}-unbundle-yaml-cpp.patch"
)

DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="dev-libs/rocm-device-libs
	dev-cpp/yaml-cpp:=
	sys-devel/llvm-roc:="
DEPEND="${RDEPEND}"

src_prepare() {
	rm -rf yaml-cpp || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/roc/"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
	)
	cmake-utils_src_configure
}
