# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Converts OpenOffice formats to text or HTML"
HOMEPAGE="http://siag.nu/o3read/"
SRC_URI="http://siag.nu/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
RESTRICT="test"

PATCHES=( "${FILESDIR}"/${P}-fix-buildsystem.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin o3read o3totxt o3tohtml utf8tolatin1
	einstalldocs
	doman *.1
}
