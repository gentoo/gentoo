# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils

DESCRIPTION="The Coordinate Library for working with CCP4 coordinate files"
HOMEPAGE="https://launchpad.net/mmdb/"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="static-libs"

PATCHES=( "${FILESDIR}"/${P}-include-path.patch )
