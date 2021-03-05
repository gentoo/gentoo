# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A library for registering global keyboard shortcuts"
HOMEPAGE="https://github.com/kupferlauncher/keybinder"
SRC_URI="https://github.com/kupferlauncher/keybinder/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 x86"
IUSE="+introspection"

RDEPEND=">=x11-libs/gtk+-2.20:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	introspection? ( dev-libs/gobject-introspection )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_enable introspection)
		--disable-python
		--disable-lua
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
