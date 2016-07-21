# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="The BGP swiss army knife of networking"
HOMEPAGE="https://github.com/Exa-Networks/exabgp"
SRC_URI="https://github.com/Exa-Networks/${PN}/archive/${P}.tar.gz"
MY_P="${PN}-${PN}-${PV}"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
