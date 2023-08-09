# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="An mail notification panel plug-in for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-mailwatch-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-mailwatch-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="ssl"

DEPEND="
	>=dev-libs/glib-2.42.0:=
	>=x11-libs/gtk+-3.22.0:3=
	>=xfce-base/exo-0.11.0:=
	>=xfce-base/libxfce4ui-4.14.0:=
	>=xfce-base/libxfce4util-4.14.0:=
	>=xfce-base/xfce4-panel-4.14.0:=
	ssl? ( >=net-libs/gnutls-2:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable ssl)
	)

	econf "${myconf[@]}"
}

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
