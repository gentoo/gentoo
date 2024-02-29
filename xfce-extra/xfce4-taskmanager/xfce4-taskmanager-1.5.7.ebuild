# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Easy to use task manager"
HOMEPAGE="
	https://docs.xfce.org/apps/xfce4-taskmanager/start
	https://gitlab.xfce.org/apps/xfce4-taskmanager/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="X"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=x11-libs/cairo-1.5.0
	>=x11-libs/gtk+-3.22.0:3
	>=x11-libs/libXmu-1.1.2
	>=x11-libs/libwnck-3.2:3
	>=xfce-base/libxfce4ui-4.14.0:=
	>=xfce-base/xfconf-4.14.0:=
	X? (
		>=x11-libs/libX11-1.6.7
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable X libx11)
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
