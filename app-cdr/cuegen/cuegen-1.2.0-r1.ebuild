# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="CUEgen is a FLAC-compatible cuesheet generator for Linux"
HOMEPAGE="http://www.cs.man.ac.uk/~slavinp/cuegen.html"
SRC_URI="http://www.cs.man.ac.uk/~slavinp/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.0-fix-build-system.patch
	"${FILESDIR}"/${PN}-1.2.0-missing-includes.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin cuegen
	einstalldocs
}
