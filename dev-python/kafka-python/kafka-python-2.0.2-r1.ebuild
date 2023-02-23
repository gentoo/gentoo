# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1 optfeature

DESCRIPTION="Kafka protocol support in Python"
HOMEPAGE="
	https://github.com/dpkp/kafka-python/
	https://pypi.org/project/kafka-python/
"
SRC_URI="
	https://github.com/dpkp/kafka-python/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/xxhash[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/lz4[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
		dev-python/python-snappy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Needs the unpackaged crc32c module
	"test/record/test_util.py::test_crc32c[None]"
	# Needs kafka server running
	test/test_consumer_integration.py::test_kafka_consumer_offsets_for_time_old
)

pkg_postinst() {
	optfeature "LZ4 compression/decompression support" dev-python/lz4
	optfeature "Snappy compression support" dev-python/python-snappy
	optfeature "ZSTD compression/decompression support" dev-python/zstandard
}
