# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library for accessing discs and disc image files"
HOMEPAGE="https://www.seasip.info/Unix/LibDsk/"
SRC_URI="https://www.seasip.info/Unix/LibDsk/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"

DOCS=( doc/${PN}.{txt,pdf} )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
