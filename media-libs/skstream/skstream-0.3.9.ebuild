# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit base eutils

DESCRIPTION="FreeSockets - Portable C++ classes for IP (sockets) applications"
HOMEPAGE="http://www.worldforge.org/"
SRC_URI="mirror://sourceforge/worldforge/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

DEPEND="test? ( dev-util/cppunit )"
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-test.patch )
DOCS=( AUTHORS ChangeLog NEWS README README.FreeSockets TODO )
