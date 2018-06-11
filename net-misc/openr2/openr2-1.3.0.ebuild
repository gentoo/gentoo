# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="An open implementation of the MFC/R2 telephony signaling protocol"
HOMEPAGE="https://libopenr2.org/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="net-misc/dahdi"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-fix-build-system.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
