# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Adds special features for media files to the Thunar File Manager"
HOMEPAGE="
	https://docs.xfce.org/xfce/thunar/media-tags
	https://gitlab.xfce.org/thunar-plugins/thunar-media-tags-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/thunar-plugins/${PN}/${PV%.*}/${P}.tar.bz2
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

DEPEND="
	media-libs/taglib:=
	>=dev-libs/glib-2.50.0:2
	>=x11-libs/gtk+-3.22:3
	>=xfce-base/libxfce4util-4.0.0:=
	>=xfce-base/thunar-1.7:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
