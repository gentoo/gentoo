# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools epatch

DESCRIPTION="emulates Window Maker docks (runs in any window manager)"
HOMEPAGE="http://xdock.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

DOCS=( API AUTHORS ChangeLog README TODO )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.2.0-ldconfig.patch
	sed -i -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' configure.ac || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
