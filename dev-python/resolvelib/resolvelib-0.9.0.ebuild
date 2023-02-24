# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Resolve abstract dependencies into concrete ones"
HOMEPAGE="
	https://github.com/sarugaku/resolvelib/
	https://pypi.org/project/resolvelib/

"
SRC_URI="
	https://github.com/sarugaku/resolvelib/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

BDEPEND="
	test? (
		dev-python/commentjson[${PYTHON_USEDEP}]
		<dev-python/packaging-22[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
