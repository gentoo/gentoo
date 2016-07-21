# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

MY_P="${PN}2-${PV}"

DESCRIPTION="The Coordinate Library, designed to assist CCP4 developers in working with coordinate files"
HOMEPAGE="https://launchpad.net/mmdb/"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="static-libs"

S="${WORKDIR}"/${MY_P}
