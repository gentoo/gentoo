# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="An mail notification panel plug-in for the Xfce desktop environment"
HOMEPAGE="http://spuriousinterrupt.org/projects/xfce4-mailwatch-plugin/"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="ipv6 ssl"

RDEPEND=">=dev-libs/glib-2:=
	>=x11-libs/gtk+-2.18:2=
	x11-libs/libX11:=
	xfce-base/exo[gtk2(+)]
	<xfce-base/libxfce4ui-4.15:=[gtk2(+)]
	>=xfce-base/libxfce4util-4.10:=
	<xfce-base/xfce4-panel-4.15:=[gtk2(+)]
	ssl? (
		dev-libs/libgcrypt:0=
		>=net-libs/gnutls-2:=
		)"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	econf $(use_enable ssl) $(use_enable ipv6)
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
