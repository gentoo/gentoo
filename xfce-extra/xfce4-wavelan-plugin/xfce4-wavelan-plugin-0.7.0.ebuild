# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A panel plug-in to display wireless interface statistics"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-wavelan-plugin
	https://gitlab.xfce.org/panel-plugins/xfce4-wavelan-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 ~riscv x86"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/libxfce4ui-4.16.0:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
"
RDEPEND="
	${DEPEND}
	kernel_linux? ( sys-apps/net-tools )
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
