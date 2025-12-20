# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="FITS to PNG converter"
HOMEPAGE="http://integral.physics.muni.cz/fitspng/"
SRC_URI="ftp://integral.physics.muni.cz/pub/${PN}/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sci-libs/cfitsio:0=
	media-libs/libpng:0="
DEPEND="${RDEPEND}"
