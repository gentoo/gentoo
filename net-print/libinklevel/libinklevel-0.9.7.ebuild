# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="${P/_/}"
DESCRIPTION="A library to get the ink level of your printer"
HOMEPAGE="https://libinklevel.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/libinklevel/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

DEPEND="
	dev-libs/libxml2:=
	virtual/libusb:1
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-0.9.7-disable-docs.patch" )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
