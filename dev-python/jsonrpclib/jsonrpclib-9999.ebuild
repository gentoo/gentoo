# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/tcalmant/jsonrpclib.git"
	inherit git-r3
else
	SRC_URI="
		https://github.com/tcalmant/jsonrpclib/archive/v${PV}.tar.gz
			-> ${P}.gh.tar.gz
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
fi

DESCRIPTION="python implementation of the JSON-RPC spec (1.0 and 2.0)"
HOMEPAGE="
	https://github.com/tcalmant/jsonrpclib/
	https://pypi.org/project/jsonrpclib/
"

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="
	test? (
		dev-python/simplejson[${PYTHON_USEDEP}]
		dev-python/ujson[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	epytest

	# NB: we need to run this test separately as it breaks
	# tests/test_server.py::PooledServerTests
	# see jsonlib.py, get_handler()
	# the most preferred (first) lib that's in test deps
	local -x JSONRPCLIB_TEST_EXPECTED_LIB=ujson
	epytest tests/test_jsonlib.py::TestJsonLibLoading
}
