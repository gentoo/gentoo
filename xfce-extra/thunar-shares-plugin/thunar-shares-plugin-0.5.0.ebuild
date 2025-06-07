# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Thunar plugin to share files using Samba"
HOMEPAGE="
	https://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin
	https://gitlab.xfce.org/thunar-plugins/thunar-shares-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/thunar-plugins/thunar-shares-plugin/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/gtk+-3.24.0:3
	>=xfce-base/thunar-4.18.0:=
	>=xfce-base/xfconf-4.18.0:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
