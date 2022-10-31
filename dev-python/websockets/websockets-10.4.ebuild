# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Library for building WebSocket servers and clients in Python"
HOMEPAGE="
	https://websockets.readthedocs.io/
	https://github.com/aaugustin/websockets/
	https://pypi.org/project/websockets/
"
SRC_URI="
	https://github.com/aaugustin/websockets/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# very fragile to speed
		tests/legacy/test_protocol.py::ServerTests::test_local_close_receive_close_frame_timeout
	)

	epytest tests
}
