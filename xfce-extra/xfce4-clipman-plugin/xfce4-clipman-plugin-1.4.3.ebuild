# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="A clipboard manager plug-in for the Xfce panel"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-clipman-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="qrcode"

RDEPEND=">=dev-libs/glib-2.32:2=
	>=x11-libs/gtk+-3.14:3=
	x11-libs/libXtst:=
	>=xfce-base/libxfce4ui-4.12:=
	>=xfce-base/libxfce4util-4.12:=
	>=xfce-base/xfce4-panel-4.12:=
	>=xfce-base/xfconf-4.10:=
	qrcode? ( >=media-gfx/qrencode-3.3.0:= )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-base/xorg-proto"

src_configure() {
	local myconf=(
		$(use_enable qrcode libqrencode)
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
