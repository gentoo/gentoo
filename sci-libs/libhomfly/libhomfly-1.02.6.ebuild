# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_rs 2 r)
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Library to compute the homfly polynomial of a link"
HOMEPAGE="https://github.com/miguelmarco/libhomfly"
SRC_URI="https://github.com/miguelmarco/${PN}/releases/download/${MY_PV}/${MY_P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND="dev-libs/boehm-gc"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
