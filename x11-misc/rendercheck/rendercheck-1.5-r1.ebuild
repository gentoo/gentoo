# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tests for compliance with X RENDER extension"
HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/test/rendercheck"
SRC_URI="https://www.x.org/releases/individual/app/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	x11-libs/libXrender
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

src_configure() {
	local econfargs=(
		--disable-selective-werror
	)

	econf "${econfargs[@]}"
}
