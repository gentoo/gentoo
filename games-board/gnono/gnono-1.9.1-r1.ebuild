# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils gnome2-utils

DESCRIPTION="A rewrite for GNOME of the Windows card game WUNO"
HOMEPAGE="https://sourceforge.net/projects/gnono/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="gnome-base/libgnomeui
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-glib-single-include.patch
)

src_prepare() {
	default

	eautoreconf
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
