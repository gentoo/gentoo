# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="FITS to PNG converter"
HOMEPAGE="http://integral.physics.muni.cz/fitspng/"
SRC_URI="ftp://integral.physics.muni.cz/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	sci-libs/cfitsio:0=
	media-libs/libpng:0="
DEPEND="${RDEPEND}"

src_install() {
	default
	use doc || rm -rf "${ED}"usr/share/doc/${PF}/html
}
