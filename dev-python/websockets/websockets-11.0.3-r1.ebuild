# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Library for building WebSocket servers and clients in Python"
HOMEPAGE="
	https://websockets.readthedocs.io/
	https://github.com/python-websockets/websockets/
	https://pypi.org/project/websockets/
"
# tests are missing pypi sdist, as of 11.0
SRC_URI="
	https://github.com/python-websockets/websockets/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-11.0.3-python3.12.patch.xz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"
IUSE="+native-extensions"

distutils_enable_tests pytest

PATCHES=(
	"${WORKDIR}"/${P}-python3.12.patch
)

src_configure() {
	export BUILD_EXTENSION=$(usex native-extensions)
}

python_test() {
	local EPYTEST_DESELECT=(
		# very fragile to speed
		tests/legacy/test_protocol.py::ServerTests::test_local_close_receive_close_frame_timeout
		# requires DNS access
		# https://bugs.gentoo.org/909567
		tests/legacy/test_client_server.py::ClientServerTests::test_explicit_host_port
		tests/legacy/test_client_server.py::SecureClientServerTests::test_explicit_host_port
	)

	epytest tests
}
