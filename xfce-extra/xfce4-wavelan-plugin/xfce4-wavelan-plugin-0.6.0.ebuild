# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit fdo-mime gnome2-utils

DESCRIPTION="A panel plug-in to display wireless interface statistics"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-wavelan-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="kernel_linux"

COMMON_DEPEND=">=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/xfce4-panel-4.12:="
RDEPEND="${COMMON_DEPEND}
	kernel_linux? ( sys-apps/net-tools )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

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
