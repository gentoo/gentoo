# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Python PAM module"
HOMEPAGE="
	https://github.com/FirefighterBlu3/python-pam/
	https://pypi.org/project/python-pam/
"
SRC_URI="
	https://github.com/FirefighterBlu3/python-pam/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
