# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="FreeSockets - Portable C++ classes for IP (sockets) applications"
HOMEPAGE="https://www.worldforge.org/"
SRC_URI="mirror://sourceforge/worldforge/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

DEPEND="test? ( dev-util/cppunit )"
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-test.patch )

src_configure() {
	# bug 651840
	append-cxxflags -std=c++11

	default
}
