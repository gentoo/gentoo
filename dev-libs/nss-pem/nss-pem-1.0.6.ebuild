# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS="cmake"

inherit cmake-multilib

DESCRIPTION="PEM file reader for Network Security Services (NSS)"
HOMEPAGE="https://github.com/kdudka/nss-pem"
SRC_URI="https://github.com/kdudka/${PN}/releases/download/${P}/${P}.tar.xz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

BDEPEND=" >=dev-libs/nss-3.50-r1 "
RDEPEND="${BDEPEND}"

DEPEND="!<=dev-libs/nss-3.50
	${RDEPEND}"

PATCHES=(
	"${FILESDIR}/nss-pem-1.0.5-nss-3.53.1-support.patch"
)

S="${WORKDIR}/${P}/src"

multilib_src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"
	)
	cmake_src_configure
}
