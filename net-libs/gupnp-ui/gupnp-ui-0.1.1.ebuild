# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils

DESCRIPTION="Collection of simple GTK+ widgets on top of GUPnP"
HOMEPAGE="http://gupnp.org"
SRC_URI="http://gupnp.org/sources/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	net-libs/gssdp:0/3
	net-libs/gupnp:0/4"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-underlinking.patch
)

src_configure() {
	econf --disable-gtk-doc
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README
}
