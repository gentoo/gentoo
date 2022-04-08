# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Library for building WebSocket servers and clients in Python"
HOMEPAGE="https://websockets.readthedocs.io/"
SRC_URI="
	https://github.com/aaugustin/${PN}/archive/${PV}.tar.gz -> ${P}-src.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# very fragile to speed
		tests/legacy/test_protocol.py::ServerTests::test_local_close_receive_close_frame_timeout
	)
	[[ ${EPYTHON} == pypy3 ]] && EPYTEST_DESELECT+=(
		tests/test_utils.py::SpeedupsTests::test_apply_mask_non_contiguous_memoryview
		tests/legacy/test_client_server.py::SecureClientServerTests::test_http_request_ws_endpoint
	)

	epytest tests
}
