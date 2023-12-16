# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Analysis of Clustered Regularly Interspaced Short Palindromic Repeats (CRISPRs)"
HOMEPAGE="https://www.drive5.com/pilercr/"
SRC_URI="https://www.drive5.com/pilercr/pilercr1.06.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0-fix-build-system.patch
	"${FILESDIR}"/${PN}-1.0-gcc43.patch
	"${FILESDIR}"/${PN}-1.0-drop-registers.patch
)

src_configure() {
	tc-export CXX
}

src_install() {
	dobin pilercr
}
