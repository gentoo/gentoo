# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A panel plug-in to provide quick access to files, folders and removable media"
HOMEPAGE="
	https://goodies.xfce.org/projects/panel-plugins/xfce4-places-plugin
	https://gitlab.xfce.org/panel-plugins/xfce4-places-plugin/
"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="libnotify"

DEPEND="
	>=dev-libs/glib-2.50:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libX11:=
	>=xfce-base/exo-4.16.0:=
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
	libnotify? ( >=x11-libs/libnotify-0.7.0:= )
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
		$(use_enable libnotify notifications)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
