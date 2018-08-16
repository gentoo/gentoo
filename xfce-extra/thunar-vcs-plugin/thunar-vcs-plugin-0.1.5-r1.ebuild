# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="Adds Subversion and GIT actions to the context menu of thunar"
HOMEPAGE="https://goodies.xfce.org/projects/thunar-plugins/thunar-vcs-plugin"
SRC_URI="https://archive.xfce.org/src/thunar-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+git +subversion"

RDEPEND=">=dev-libs/glib-2.18:2=
	>=x11-libs/gtk+-2.14:2=
	>=xfce-base/exo-0.6:=
	>=xfce-base/libxfce4util-4.8:=
	<xfce-base/thunar-1.7:=
	git? ( dev-vcs/git )
	subversion? (
		>=dev-libs/apr-0.9.7:=
		>=dev-vcs/subversion-1.5:=
		)"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

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
