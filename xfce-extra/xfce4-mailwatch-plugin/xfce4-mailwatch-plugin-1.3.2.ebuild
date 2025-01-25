# Copyright 1999-2025 Gentoo Authors
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
KEYWORDS="~alpha amd64 arm ~hppa ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="ssl"

DEPEND="
	>=dev-libs/glib-2.50.0:=
	>=x11-libs/gtk+-3.22.0:3=
	>=xfce-base/exo-0.11.0:=
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
	ssl? ( >=net-libs/gnutls-2:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
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
