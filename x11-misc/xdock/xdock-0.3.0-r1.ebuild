# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Emulates Window Maker docks (runs in any window manager)"
HOMEPAGE="https://xdock.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libX11"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"

DOCS=( API AUTHORS ChangeLog README TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.0-ldconfig.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	sed -i -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' configure.ac || die
	eautoreconf
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
