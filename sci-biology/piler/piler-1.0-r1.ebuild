# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Analysis of repetitive DNA found in genome sequences"
HOMEPAGE="http://www.drive5.com/piler/"
SRC_URI="http://www.drive5.com/piler/piler_source.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="
	|| (
		sci-biology/muscle
		sci-libs/libmuscle
	)
	sci-biology/pals"

S=${WORKDIR}

PATCHES=(
	"${FILESDIR}"/${PN}-1.0-fix-build-system.patch
	"${FILESDIR}"/${PN}-1.0-glibc-2.10.patch
)

src_configure() {
	tc-export CXX
}

src_install() {
	dobin piler
}
