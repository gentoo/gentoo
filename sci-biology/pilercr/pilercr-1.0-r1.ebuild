# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Analysis of Clustered Regularly Interspaced Short Palindromic Repeats (CRISPRs)"
HOMEPAGE="http://www.drive5.com/pilercr/"
SRC_URI="http://www.drive5.com/pilercr/pilercr1.06.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}

PATCHES=(
	"${FILESDIR}"/${PN}-1.0-fix-build-system.patch
	"${FILESDIR}"/${PN}-1.0-gcc43.patch
)

src_configure() {
	tc-export CXX
}

src_install() {
	dobin ${PN}
}
