# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS="cmake"

inherit cmake-multilib

DESCRIPTION="PEM file reader for Network Security Services (NSS)"
HOMEPAGE="https://github.com/kdudka/nss-pem"
SRC_URI="https://github.com/kdudka/${PN}/releases/download/${P}/${P}.tar.xz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x64-solaris"
IUSE=""

BDEPEND=" >=dev-libs/nss-3.50-r1 "
RDEPEND="${BDEPEND}"

DEPEND="!<=dev-libs/nss-3.50
	${RDEPEND}"

S="${WORKDIR}/${P}/src"

multilib_src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"
	)
	cmake_src_configure
}
