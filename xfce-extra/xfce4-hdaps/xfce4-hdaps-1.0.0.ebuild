# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg-utils

DESCRIPTION="Show the status of the IBM Hard Drive Active Protection System"
HOMEPAGE="http://michael.orlitzky.com/code/xfce4-hdaps.xhtml"
SRC_URI="http://michael.orlitzky.com/code/releases/${P}.tar.xz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND="dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
DEPEND=">=x11-libs/gtk+-3.20:3
	x11-libs/libX11
	>=xfce-base/libxfce4ui-4.14
	>=xfce-base/libxfce4util-4.14
	>=xfce-base/xfce4-panel-4.14:="
RDEPEND="${DEPEND}
	app-laptop/hdapsd
	app-laptop/tp_smapi"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
