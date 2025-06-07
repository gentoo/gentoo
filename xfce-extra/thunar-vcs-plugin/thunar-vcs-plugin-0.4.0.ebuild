# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="Adds Subversion and GIT actions to the context menu of thunar"
HOMEPAGE="
	https://docs.xfce.org/xfce/thunar/thunar-vcs-plugin
	https://gitlab.xfce.org/thunar-plugins/thunar-vcs-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/thunar-plugins/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv x86"
IUSE="+git subversion"

# TODO: remove exo when we dep on libxfce4ui >= 4.21
DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/gtk+-3.24.0:3
	>=xfce-base/exo-4.18.0:=
	>=xfce-base/libxfce4ui-4.18.0:=
	>=xfce-base/libxfce4util-4.18.0:=
	>=xfce-base/thunar-4.18.0:=
	git? ( dev-vcs/git )
	subversion? (
		>=dev-libs/apr-0.9.7:=
		>=dev-libs/apr-util-0.9.1:=
		>=dev-vcs/subversion-1.5:=
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature git)
		$(meson_feature subversion svn)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
