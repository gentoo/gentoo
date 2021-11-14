# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg-utils

DESCRIPTION="A panel plugin that uses indicator-applet to show new messages"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-indicator-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE=""

RDEPEND=">=dev-libs/libindicator-12.10.1:3=
	>=x11-libs/gtk+-3.18:3=
	x11-libs/libX11:=
	>=xfce-base/libxfce4ui-4.11:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.11:=
	>=xfce-base/xfce4-panel-4.11:=
	>=xfce-base/xfconf-4.13:="
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		# libido3-13.10.0 needs ubuntu-private.h from Ubuntu's GTK+ 3.x
		--disable-ido
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
