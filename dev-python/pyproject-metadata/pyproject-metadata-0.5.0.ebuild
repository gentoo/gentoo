# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="PEP 621 metadata parsing"
HOMEPAGE="https://pypi.org/project/pyproject-metadata/ https://github.com/FFY00/python-pyproject-metadata/"
SRC_URI="https://github.com//FFY00/python-pyproject-metadata/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/python-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/packaging[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.0-no-install-tests.patch
)

distutils_enable_tests pytest
