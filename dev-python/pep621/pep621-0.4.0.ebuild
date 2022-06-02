# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="PEP 621 metadata parsing"
HOMEPAGE="https://pypi.org/project/pep621/ https://github.com/FFY00/python-pep621/"
SRC_URI="https://github.com//FFY00/python-pep621/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/python-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/packaging[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${P}-fix-tests-packaging.patch
)

distutils_enable_tests pytest
