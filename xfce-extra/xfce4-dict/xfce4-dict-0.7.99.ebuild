# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit fdo-mime gnome2-utils

DESCRIPTION="A dict.org querying application and panel plug-in for the Xfce desktop"
HOMEPAGE="https://goodies.xfce.org/projects/applications/xfce4-dict"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-libs/glib-2.24:=
	>=x11-libs/gtk+-3.20:3=
	>=xfce-base/libxfce4util-4.10:=
	>=xfce-base/libxfce4ui-4.12:=
	>=xfce-base/xfce4-panel-4.10:="
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/intltool
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	econf --libexecdir="${EPREFIX}"/usr/$(get_libdir)
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
