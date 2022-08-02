# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Pairwise Aligner for Long Sequences"
HOMEPAGE="https://www.drive5.com/pals/"
SRC_URI="https://www.drive5.com/pals/pals_source.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=( "${FILESDIR}"/${PN}-1.0-fix-build-system.patch )

src_configure() {
	tc-export CXX
}

src_install() {
	dobin pals
}
