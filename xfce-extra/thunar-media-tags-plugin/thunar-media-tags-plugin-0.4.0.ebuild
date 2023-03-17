# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Adds special features for media files to the Thunar File Manager"
HOMEPAGE="
	https://goodies.xfce.org/projects/thunar-plugins/thunar-media-tags-plugin
	https://gitlab.xfce.org/thunar-plugins/thunar-media-tags-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/thunar-plugins/${PN}/${PV%.*}/${P}.tar.bz2
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv x86"

DEPEND="
	>=media-libs/taglib-1.6
	>=dev-libs/glib-2.50.0:2
	>=x11-libs/gtk+-3.22:3
	>=xfce-base/libxfce4util-4.0.0:=
	>=xfce-base/thunar-1.7:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
