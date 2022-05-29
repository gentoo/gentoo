# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=flit
inherit distutils-r1

DESCRIPTION="Pytest parametrize decorators from external files."
HOMEPAGE="https://pypi.org/project/pytest_param_files/
	https://github.com/chrisjsewell/pytest-param-files"
SRC_URI="
	https://github.com/chrisjsewell/pytest-param-files/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
