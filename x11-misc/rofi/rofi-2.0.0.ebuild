# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson toolchain-funcs xdg-utils

DESCRIPTION="A window switcher, run dialog and dmenu replacement"
HOMEPAGE="https://github.com/davatorium/rofi"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/davatorium/rofi"
	inherit git-r3
else
	SRC_URI="https://github.com/davatorium/rofi/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+drun test wayland +windowmode X"
REQUIRED_USE="|| ( wayland X )"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-devel/bison
	>=sys-devel/flex-2.5.39
	virtual/pkgconfig
"
RDEPEND="
	>=dev-libs/glib-2.72:2
	x11-libs/cairo[X?]
	x11-libs/gdk-pixbuf:2
	x11-libs/libxkbcommon[X?]
	x11-libs/pango[X?]
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libxcb:=
		x11-libs/startup-notification
		x11-libs/xcb-util
		x11-libs/xcb-util-cursor
		x11-libs/xcb-util-wm
		x11-misc/xkeyboard-config
	)
"
DEPEND="
	${RDEPEND}
	wayland? ( dev-libs/wayland-protocols )
	X? (
		x11-base/xorg-proto
		x11-libs/xcb-util-keysyms
	)
	test? ( >=dev-libs/check-0.11 )
"

DOCS=(
	AUTHORS
	Changelog
	Examples/
	README.md
)

src_configure() {
	# Doesn't work with reflex, bug #887049
	export LEX=flex

	# Requires bison, see https://bugs.gentoo.org/894634.
	unset YACC

	tc-export CC

	local emesonargs=(
		$(meson_use drun)
		$(meson_use windowmode window)
		$(meson_feature test check)
		$(meson_feature wayland)
		$(meson_feature X xcb)
	   -Dimdkit=false
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
