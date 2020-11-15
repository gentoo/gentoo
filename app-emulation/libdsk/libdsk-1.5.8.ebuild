# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LIBDSK is a library for accessing discs and disc image files"
HOMEPAGE="http://www.seasip.info/Unix/LibDsk/"
SRC_URI="http://www.seasip.info/Unix/LibDsk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc"

PATCHES=( "${FILESDIR}"/${P}-include-sysmacros.patch )
DOCS=( doc/${PN}.{txt,pdf} )

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
