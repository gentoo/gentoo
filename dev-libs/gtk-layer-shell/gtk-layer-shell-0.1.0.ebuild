# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A library to create panels and other desktop components for Wayland"
HOMEPAGE="https://github.com/wmww/gtk-layer-shell"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wmww/gtk-layer-shell.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/wmww/gtk-layer-shell/archive/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="docs examples"

DEPEND=">=x11-libs/gtk+-3.24.11:3[introspection,wayland]
	>=dev-libs/wayland-1.10.0
	dev-libs/gobject-introspection
	docs? ( dev-util/gtk-doc
		>=x11-libs/gtk+-3.24.11:3[gtk-doc] )
"

RDEPEND=">=x11-libs/gtk+-3.24.11:3[introspection,wayland]
	>=dev-libs/wayland-1.10.0
	dev-libs/gobject-introspection
"

BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Ddocs=$(usex docs true false)
		-Dexamples=$(usex examples true false)
	)
	meson_src_configure
}
