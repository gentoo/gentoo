# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Information about the Debian distributions' releases (data files)"
HOMEPAGE="https://debian.org/"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.xz"

LICENSE="ISC"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""
# Package provides only csv data and test script
# written in python
RESTRICT="test"
