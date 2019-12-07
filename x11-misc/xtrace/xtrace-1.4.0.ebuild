# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="X11 protocol trace utility"
HOMEPAGE="https://salsa.debian.org/debian/xtrace"
SRC_URI="https://salsa.debian.org/debian/${PN}/-/archive/${P}/${PN}-${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~s390 ~sh ~x86"

DEPEND="x11-base/xorg-proto
	x11-libs/libXext
	x11-libs/libX11"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --program-transform-name="s/^x/x11/"
}

pkg_postinst () {
	einfo "To avoid collision with glibc (/usr/bin/xtrace)"
	einfo "binary was renamed to x11trace, as suggested by author"
}
