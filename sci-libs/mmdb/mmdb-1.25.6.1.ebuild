# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The Coordinate Library for working with CCP4 coordinate files"
HOMEPAGE="https://launchpad.net/mmdb/"
SRC_URI="https://launchpad.net/mmdb/1.25/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="static-libs"

PATCHES=( "${FILESDIR}"/${PN}-1.25.5-include-path.patch )
