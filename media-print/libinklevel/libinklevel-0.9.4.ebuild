# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="${P/_/}"
DESCRIPTION="A library to get the ink level of your printer"
HOMEPAGE="https://libinklevel.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/libinklevel/libinklevel/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug"

DEPEND="
	>=sys-libs/libieee1284-0.2.11
	virtual/libusb:1
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	sed -i -e "/^dist_doc_DATA/d" Makefile.am \
		|| die "Failed to disable installation of docs"

	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
