# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="File identification library for Python"
HOMEPAGE="
	https://github.com/pre-commit/identify/
	https://pypi.org/project/identify/
"
SRC_URI="
	https://github.com/pre-commit/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/ukkonen[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
