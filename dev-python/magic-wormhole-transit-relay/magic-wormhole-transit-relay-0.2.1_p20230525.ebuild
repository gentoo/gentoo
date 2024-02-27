# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

# Version 0.2.1 with additional upstream fixes for python 3.11 support and
# miscelleanous bufixes
COMMIT_SHA1="db48e915311d1d10c748bb5299e2345c74e90a1b"

inherit distutils-r1

DESCRIPTION="Transit relay server for magic-wormhole"
HOMEPAGE="https://magic-wormhole.readthedocs.io/en/latest/ https://pypi.org/project/magic-wormhole-transit-relay/"
SRC_URI="https://github.com/magic-wormhole/${PN}/archive/${COMMIT_SHA1}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
S="${WORKDIR}/magic-wormhole-transit-relay-${COMMIT_SHA1}"

RDEPEND="
	dev-python/autobahn[${PYTHON_USEDEP}]
	dev-python/twisted[ssl,${PYTHON_USEDEP}]"

BDEPEND="test? (
	dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	# deselect test_buff_fill test because it exhibits intermittent hangs,
	# bug #907200
	local EPYTEST_DESELECT=(
		src/wormhole_transit_relay/test/test_backpressure.py::TransitWebSockets::test_buffer_fill
	)
	epytest
}
