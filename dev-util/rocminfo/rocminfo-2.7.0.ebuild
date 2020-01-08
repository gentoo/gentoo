# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocminfo/"
	inherit git-r3
else
	SRC_URI="https://github.com/RadeonOpenCompute/rocminfo/archive/roc-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocminfo-roc-${PV}"
fi

DESCRIPTION="ROCm Application for Reporting System Info"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="dev-libs/rocr-runtime"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.6.0-cmake-variables.patch"
	"${FILESDIR}/${P}-sizeof.patch"
)

src_configure() {
	local mycmakeargs=(
		-DROCM_DIR="${ESYSROOT}/usr"
		-DROCR_INC_DIR="${ESYSROOT}/usr/include"
		-DROCR_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
	)
	cmake_src_configure
}
