# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Decorator for retrying when exceptions occur"
HOMEPAGE="
	https://github.com/pnpnpn/retry-decorator/
	https://pypi.org/project/retry-decorator/
"
SRC_URI="
	https://github.com/pnpnpn/retry-decorator/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv x86"

DOCS=( README.rst )

distutils_enable_tests pytest
