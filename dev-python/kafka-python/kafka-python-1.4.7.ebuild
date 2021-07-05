# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="Kafka protocol support in Python"
HOMEPAGE="https://github.com/dpkp/kafka-python/ https://pypi.org/project/kafka-python/"
SRC_URI="https://github.com/dpkp/kafka-python/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="snappy"

RDEPEND="snappy? ( dev-python/snappy[${PYTHON_USEDEP}] )"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
