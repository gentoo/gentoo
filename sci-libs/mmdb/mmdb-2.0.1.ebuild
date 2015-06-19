# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/mmdb/mmdb-2.0.1.ebuild,v 1.1 2014/09/23 13:28:01 jlec Exp $

EAPI=5

inherit autotools-utils

MY_P="${PN}2-${PV}"

DESCRIPTION="The Coordinate Library, designed to assist CCP4 developers in working with coordinate files"
HOMEPAGE="http://launchpad.net/mmdb/"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="static-libs"

DEPEND="!<sci-libs/ccp4-libs-6.1.3"
RDEPEND=""

S="${WORKDIR}"/${MY_P}
