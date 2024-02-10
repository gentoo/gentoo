# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="Adds Subversion and GIT actions to the context menu of thunar"
HOMEPAGE="https://goodies.xfce.org/projects/thunar-plugins/thunar-vcs-plugin"
SRC_URI="https://archive.xfce.org/src/thunar-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="+git +subversion"

RDEPEND=">=dev-libs/glib-2.32:2=
	>=x11-libs/gtk+-3.20:3=
	>=xfce-base/exo-0.11.4:=
	>=xfce-base/libxfce4util-4.12:=
	>=xfce-base/thunar-1.7:=
	git? ( dev-vcs/git )
	subversion? (
		>=dev-libs/apr-0.9.7:=
		>=dev-vcs/subversion-1.5:=
		)"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_enable subversion)
		$(use_enable git)
	)
	econf "${myconf[@]}"
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
