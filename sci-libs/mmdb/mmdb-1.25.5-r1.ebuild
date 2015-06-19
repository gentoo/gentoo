# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/mmdb/mmdb-1.25.5-r1.ebuild,v 1.1 2014/11/12 20:13:31 jlec Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="The Coordinate Library, designed to assist CCP4 developers in working with coordinate files"
HOMEPAGE="http://launchpad.net/mmdb/"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="static-libs"

DEPEND="!<sci-libs/ccp4-libs-6.1.3"
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-include-path.patch )
