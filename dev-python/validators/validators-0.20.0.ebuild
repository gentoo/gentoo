# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python Data Validation for Humans"
HOMEPAGE="
	https://github.com/kvesteri/validators/
	https://pypi.org/project/validators/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-python/decorator-3.4.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
