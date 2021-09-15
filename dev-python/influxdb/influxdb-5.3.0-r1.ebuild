# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="InfluxDB client"
HOMEPAGE="https://github.com/influxdb/influxdb-python https://pypi.org/project/influxdb/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/msgpack-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.6.0[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/requests-2.17.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"
BDEPEND="test? (
		dev-db/influxdb
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}/${P}-pandas-future-warning.patch" )

distutils_enable_tests nose

src_prepare() {
	# The tarball is missing this file.
	# <https://github.com/influxdata/influxdb-python/issues/714>
	cp "${FILESDIR}/influxdb.conf.template" "${S}/influxdb/tests/server_tests/influxdb.conf.template" || die
	default
}
