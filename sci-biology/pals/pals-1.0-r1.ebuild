# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Pairwise Aligner for Long Sequences"
HOMEPAGE="http://www.drive5.com/pals/"
SRC_URI="http://www.drive5.com/pals/pals_source.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S=${WORKDIR}

PATCHES=( "${FILESDIR}"/${PN}-1.0-fix-build-system.patch )

src_configure() {
	tc-export CXX
}

src_install() {
	dobin pals
}
