# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

# TODO: install scripts and their man pages

inherit eutils distutils-r1

DESCRIPTION="Ethernet settings python bindings"
HOMEPAGE="https://fedorahosted.org/python-ethtool/"
SRC_URI="https://fedorahosted.org/releases/p/y/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~amd64"
IUSE=""

DEPEND="dev-libs/libnl:3"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}_include-net-if.h-for-IFF_-macros.patch"
	distutils-r1_src_prepare
}
