# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="Easy to use task manager"
HOMEPAGE="
	https://docs.xfce.org/apps/xfce4-taskmanager/start
	https://gitlab.xfce.org/apps/xfce4-taskmanager/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 arm ~arm64 ~hppa ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="X"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/cairo-1.5.0
	>=x11-libs/gtk+-3.24.0:3
	>=x11-libs/libXmu-1.1.2
	>=x11-libs/libwnck-3.2:3
	>=xfce-base/libxfce4ui-4.18.0:=
	>=xfce-base/libxfce4util-4.18.0:=
	>=xfce-base/xfconf-4.18.0:=
	X? (
		>=x11-libs/libX11-1.6.7
	)
"
RDEPEND="
	${DEPEND}
"
# dev-libs/glib for glib-compile-resources
BDEPEND="
	>=dev-libs/glib-2.66.0
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature X x11)
		# TODO: do we want to make it conditional?
		-Dwnck=enabled
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
