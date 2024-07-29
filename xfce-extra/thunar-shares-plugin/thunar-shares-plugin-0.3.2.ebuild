# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Thunar plugin to share files using Samba"
HOMEPAGE="
	https://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin
	https://gitlab.xfce.org/thunar-plugins/thunar-shares-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/thunar-plugins/thunar-shares-plugin/${PV%.*}/${P}.tar.bz2
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

DEPEND="
	>=dev-libs/glib-2.26.0
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/thunar-1.7:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
