# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="InfluxDB 2.0 and 1.8+ Python client library"
HOMEPAGE="https://github.com/influxdata/influxdb-client-python"
SRC_URI="https://github.com/influxdata/${PN}-python/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-python-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="ciso extra test"
RESTRICT="!test? ( test )"

DOCS="README.rst"

RDEPEND=">=dev-python/certifi-14.05.14[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.5.3[${PYTHON_USEDEP}]
	>=dev-python/pytz-2019.1[${PYTHON_USEDEP}]
	>=dev-python/Rx-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.15.1[${PYTHON_USEDEP}]
"
BDEPEND="${REDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	ciso? (
		>=dev-python/ciso8601-2.1.1
	)
	extra? (
		>=dev-python/pandas-0.25.3
		dev-python/numpy
	)
	test? (
		>=dev-python/coverage-4.0.3[${PYTHON_USEDEP}]
		>=dev-python/httpretty-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/pluggy-0.3.1[${PYTHON_USEDEP}]
		>=dev-python/py-1.4.31[${PYTHON_USEDEP}]
		>=dev-python/pytest-5.0.0[${PYTHON_USEDEP}]
		>=dev-python/randomize-0.13[${PYTHON_USEDEP}]
	)
"
