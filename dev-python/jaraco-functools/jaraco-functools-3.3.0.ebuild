# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Additional functions used by other projects by developer jaraco"
HOMEPAGE="https://github.com/jaraco/jaraco.functools"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/more-itertools[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/jaraco-classes[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	">=dev-python/jaraco-packaging-3.2" \
	">=dev-python/rst-linker-1.9"
distutils_enable_tests pytest
