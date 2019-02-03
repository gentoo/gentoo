# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${PN}2-${PV}"

DESCRIPTION="The Coordinate Library for working with CCP4 coordinate files"
HOMEPAGE="https://launchpad.net/mmdb/"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="static-libs"

S="${WORKDIR}"/${MY_P}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default
	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
