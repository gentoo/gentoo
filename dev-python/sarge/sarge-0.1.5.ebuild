# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7,8} )

inherit distutils-r1

MY_PN="${PN}"
MY_P="${MY_PN}-${PV}.post0"
S=$WORKDIR/$MY_P

DESCRIPTION="wrapper for subprocess which provides command pipeline functionality"
HOMEPAGE="http://sarge.readthedocs.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND=""
BDEPEND=""
