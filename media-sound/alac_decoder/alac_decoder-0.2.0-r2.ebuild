# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Basic decoder for Apple Lossless Audio Codec files (ALAC)"
HOMEPAGE="http://craz.net/programs/itunes/alac.html"
SRC_URI="http://craz.net/programs/itunes/files/${P}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=( "${FILESDIR}"/${PN}-0.2.0-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin alac
	einstalldocs
}
