# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Collection of general purpose C++-classes"
HOMEPAGE="http://www.tntnet.org/cxxtools.html"
SRC_URI="http://www.tntnet.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"

RDEPEND="virtual/libiconv"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog )

src_configure() {
	econf \
		--disable-demos \
		--disable-unittest
}
