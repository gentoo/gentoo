# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="WebSocket client for python with hybi13 support"
HOMEPAGE="
	https://github.com/websocket-client/websocket-client/
	https://pypi.org/project/websocket-client/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="examples"

BDEPEND="
	test? (
		dev-python/python-socks[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
