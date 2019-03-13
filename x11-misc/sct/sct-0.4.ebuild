# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Set color temperature of the screen"
HOMEPAGE="https://www.umaxx.net/"
SRC_URI="https://www.umaxx.net/dl/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	x11-libs/libXrandr"

RDEPEND="
	${DEPEND}"

src_prepare() {
	default
	sed \
		-e 's:_BSD_SOURCE:_DEFAULT_SOURCE:g' \
		-i Makefile || die
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}
