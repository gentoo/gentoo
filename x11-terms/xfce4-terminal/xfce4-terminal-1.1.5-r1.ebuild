# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A terminal emulator for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/apps/terminal/start
	https://gitlab.xfce.org/apps/xfce4-terminal/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86 ~x64-solaris"
IUSE="utempter wayland X"
REQUIRED_USE="|| ( wayland X )"

RDEPEND="
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/libpcre2-10.00:=
	>=x11-libs/gtk+-3.22.0:3[wayland?,X?]
	>=x11-libs/vte-0.51.3:2.91
	>=xfce-base/libxfce4ui-4.17.5:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
	utempter? ( sys-libs/libutempter:= )
	wayland? ( >=gui-libs/gtk-layer-shell-0.7.0 )
	X? ( >=x11-libs/libX11-1.6.7 )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-libs/libxml2
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature X x11)
		$(meson_feature wayland)
		$(meson_feature wayland gtk-layer-shell)
		$(meson_feature utempter libutempter)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
