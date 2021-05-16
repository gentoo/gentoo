# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="MBrowse is a graphical MIB browser"
HOMEPAGE="https://sourceforge.net/projects/mbrowse/"
SRC_URI="mirror://sourceforge/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="
	dev-libs/glib
	net-analyzer/net-snmp:=
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README ChangeLog )

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.3-flags.patch
	"${FILESDIR}"/${PN}-0.4.3-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --with-snmp-lib="${EPREFIX}/usr/$(get_libdir)"
}
