# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN/-data}
MY_PN=${MY_PN}.org-data

DESCRIPTION="OpenAstro data files, ephemeris, famous people database, geo database"
HOMEPAGE="http://openastro.org"
SRC_URI="http://ppa.launchpad.net/pellesimon/ubuntu/pool/main/o/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3+"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}
