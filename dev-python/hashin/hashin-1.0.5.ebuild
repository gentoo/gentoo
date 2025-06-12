# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..13} )

inherit distutils-r1 pypi

DESCRIPTION="Adds hashed entries for packages to requirements.txt"
HOMEPAGE="https://github.com/peterbe/hashin"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
"

RESTRICT="!test? ( test )"

distutils_enable_tests pytest
