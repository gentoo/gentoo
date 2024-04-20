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
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="+native-extensions"

BDEPEND="
	test? (
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_compile() {
	if use native-extensions && [[ ${EPYTHON} != pypy3 ]] ; then
		local -x BUILD_EXTENSION=yes
	else
		local -x BUILD_EXTENSION=no
	fi

	distutils-r1_python_compile
}

python_test() {
	local EPYTEST_DESELECT=(
		# requires DNS access
		# https://bugs.gentoo.org/909567
		tests/legacy/test_client_server.py::ClientServerTests::test_explicit_host_port
		tests/legacy/test_client_server.py::SecureClientServerTests::test_explicit_host_port
	)

	epytest tests --reruns=10 --reruns-delay=2
}
