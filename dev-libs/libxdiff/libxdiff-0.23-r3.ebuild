# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library for creating diff files"
HOMEPAGE="http://www.xmailserver.org/xdiff-lib.html"
SRC_URI="http://www.xmailserver.org/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=( "${FILESDIR}/${P}-tests.patch" )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
