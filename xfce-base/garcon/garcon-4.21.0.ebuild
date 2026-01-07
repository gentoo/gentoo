# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="Xfce's freedesktop.org specification compatible menu implementation library"
HOMEPAGE="
	https://docs.xfce.org/xfce/garcon/start
	https://gitlab.xfce.org/xfce/garcon/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="LGPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc introspection test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.72.0
	>=x11-libs/gtk+-3.24.0:3
	>=xfce-base/libxfce4util-4.18.0:=[introspection?]
	>=xfce-base/libxfce4ui-4.21.0:=[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-build/xfce4-dev-tools
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2 )
"

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc)
		$(meson_use introspection)
		$(meson_use test tests)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
