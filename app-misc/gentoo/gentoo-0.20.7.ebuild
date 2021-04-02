# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools desktop

DESCRIPTION="Graphical file manager for Unix-like systems, using GTK+"
HOMEPAGE="https://sourceforge.net/projects/gentoo/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="nls"

RDEPEND="
	>x11-libs/gtk+-3.12:3
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/pango
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

DOCS=(
	AUTHORS BUGS CONFIG-CHANGES CREDITS NEWS README TODO docs/{FAQ,menus.txt}
)

src_prepare() {
	sed -i \
		-e 's^icons/gnome/16x16/mimetypes^gentoo/icons^' \
		gentoorc.in || die
	sed -i \
		-e '/GTK_DISABLE_DEPRECATED/d' \
		-e '/^GENTOO_CFLAGS=/s|".*"|"${CFLAGS}"|g' \
		-e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' \
		configure.ac || die #357343

	eapply_user

	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir=/etc/gentoo \
		$(use_enable nls)
}

src_install() {
	default

	docinto html
	dodoc -r docs/{images,config,*.{html,css}}

	newman docs/gentoo.1x gentoo.1

	docinto scratch
	dodoc docs/scratch/*

	make_desktop_entry ${PN} Gentoo \
		/usr/share/${PN}/icons/${PN}.png \
		"System;FileTools;FileManager"
}
