# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}-${PV/_p/-r}
DESCRIPTION="Library for reading and writing Tide Constituent Database (TCD) files"
HOMEPAGE="https://flaterco.com/xtide/libtcd.html"
SRC_URI="https://flaterco.com/files/xtide/${MY_P}.tar.xz"
S="${WORKDIR}"/${P%_*}

LICENSE="public-domain"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=sci-geosciences/harmonics-dwf-free-20120302"
RDEPEND="${DEPEND}"

src_configure() {
	econf --disable-static
}

src_install() {
	default

	rm \
		"${ED}"/usr/share/doc/${P}/{AUTHORS,ChangeLog,NEWS,README} \
		"${ED}"/usr/share/${PN}/libtcd.html \
		|| die

	if use doc ; then
		docinto html
		dodoc libtcd.html
	fi

	find "${ED}" -name '*.la' -delete || die
}
