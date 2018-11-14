# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools-utils

DESCRIPTION="An Event Expression Library inspired by CEE"
HOMEPAGE="http://www.libee.org"
SRC_URI="http://www.libee.org/files/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 hppa x86 ~amd64-linux"
IUSE="debug static-libs"

DEPEND="dev-libs/libxml2
	dev-libs/libestr"
RDEPEND="${DEPEND}"

DOCS=(INSTALL ChangeLog)

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		--enable-testbench
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile -j1
}
