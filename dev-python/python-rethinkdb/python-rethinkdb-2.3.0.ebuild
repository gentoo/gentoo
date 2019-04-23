# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

MY_PN="rethinkdb"
DESCRIPTION="Python driver library for the RethinkDB database server."
HOMEPAGE="https://rethinkdb.com/api/python/"
SRC_URI="mirror://pypi/r/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

# no tests provided on pypi distribution
RESTRICT="test"
S="${WORKDIR}/${MY_PN}-${PV}"
