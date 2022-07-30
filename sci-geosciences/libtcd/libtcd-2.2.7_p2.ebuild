# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${PN}-${PV/_p/-r}
DESCRIPTION="Library for reading and writing Tide Constituent Database (TCD) files"
HOMEPAGE="https://flaterco.com/xtide/libtcd.html"
SRC_URI="ftp://ftp.flaterco.com/xtide/${MY_P}.tar.bz2"
S="${WORKDIR}"/${P%_*}

LICENSE="public-domain"
SLOT="0/1"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND=">=sci-geosciences/harmonics-dwf-free-20120302"
RDEPEND="${DEPEND}"

src_configure() {
	econf --disable-static
}

src_install() {
	default

	if use doc ; then
		docinto html
		dodoc libtcd.html
	fi

	find "${ED}" -name '*.la' -delete || die
}
