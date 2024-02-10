# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A terminal emulator for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/apps/terminal/start
	https://gitlab.xfce.org/apps/xfce4-terminal/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/$(ver_cut 1-2)/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="utempter wayland X"
REQUIRED_USE="|| ( wayland X )"

RDEPEND="
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/libpcre2-10.00:=
	>=x11-libs/gtk+-3.22.0:3[wayland?,X?]
	>=x11-libs/vte-0.51.3:2.91
	>=xfce-base/libxfce4ui-4.17.5:=[gtk3(+)]
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
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_with utempter)
		$(use_enable wayland)
		$(use_enable wayland gtk-layer-shell)
		$(use_enable X x11)
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
