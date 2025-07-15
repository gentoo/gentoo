# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit meson python-any-r1

EGIT_COMMIT=4d37dc9da9a1f699b86d4e6b05f4619b8eee4ee8
WLR_COMMIT=4264185db3b7e961e7f157e1cc4fd0ab75137568
MY_P=libwlembed-${EGIT_COMMIT}
DESCRIPTION="A library for easily adding embedded Wayland compositor functionality"
HOMEPAGE="https://gitlab.xfce.org/kelnos/libwlembed"
SRC_URI="
	https://gitlab.xfce.org/kelnos/libwlembed/-/archive/${EGIT_COMMIT}/${MY_P}.tar.bz2
	https://gitlab.freedesktop.org/wlroots/wlr-protocols/-/archive/${WLR_COMMIT}/wlr-protocols-${WLR_COMMIT}.tar.bz2

"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="gtk gtk-doc +introspection"

DEPEND="
	>=dev-libs/glib-2.72
	>=dev-libs/wayland-1.20
	>=dev-util/wayland-scanner-1.20
	x11-libs/libxkbcommon
	gtk? (
		>=gui-libs/gtk-layer-shell-0.7.0
		>=x11-libs/gtk+-3.24:3[wayland]
	)
	introspection? ( >=dev-libs/gobject-introspection-1.72.0 )
"
RDEPEND="
	${DEPEND}
"
DEPEND+="
	>=dev-libs/wayland-protocols-1.25
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

src_unpack() {
	default
	mv "${WORKDIR}/wlr-protocols-${WLR_COMMIT}"/* \
		"${S}/protocol/wlr-protocols" || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature gtk gtk3)
		$(meson_feature gtk gtk3-layer-shell)
		$(meson_use introspection)
		$(meson_use gtk-doc)
		-Dexamples=false
	)

	meson_src_configure
}
