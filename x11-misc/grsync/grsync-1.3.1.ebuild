# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit xdg

DESCRIPTION="A gtk frontend to rsync"
HOMEPAGE="http://www.opbyte.it/grsync/"
SRC_URI="http://www.opbyte.it/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+gtk3"

DEPEND="
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( >=x11-libs/gtk+-2.16:2 )"
RDEPEND="${DEPEND}
	net-misc/rsync"
BDEPEND="virtual/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS NEWS README"

src_prepare() {
	default

	if ! use gtk3; then
		sed -e "s/gtk_widget_override_font/gtk_widget_modify_font/" \
			-i src/callbacks.c || die
	fi
}

src_configure() {
	econf --disable-unity $(use_enable gtk3)
}
