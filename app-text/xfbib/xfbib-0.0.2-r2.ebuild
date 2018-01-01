# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils xdg-utils

DESCRIPTION="a lightweight BibTeX editor"
HOMEPAGE="https://goodies.xfce.org/projects/applications/xfbib"
SRC_URI="https://goodies.xfce.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.12
	>=x11-libs/gtk+-2.10:2
	>=xfce-base/libxfcegui4-4.2
	>=xfce-base/libxfce4ui-4.8
	>=xfce-base/libxfce4util-4.8"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	eapply -p0 "${FILESDIR}"/${P}-validate.patch
	default
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
