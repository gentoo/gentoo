# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit gnome2-utils

DESCRIPTION="A GTK+ based xmessage clone"
HOMEPAGE="https://savannah.gnu.org/projects/gxmessage/ http://homepages.ihug.co.nz/~trmusson/programs.html#gxmessage"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz
	http://homepages.ihug.co.nz/~trmusson/stuff/${P}.tar.gz"

LICENSE="GPL-3 public-domain"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/pango
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40.1
	sys-devel/gettext"

DOCS=( AUTHORS ChangeLog HACKING NEWS README TODO )

src_install() {
	default

	docinto examples
	dodoc examples/*
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
