# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="alabaster sub-theme used on git-pull docs"
HOMEPAGE="https://github.com/git-pull/alagitpull"
SRC_URI="https://github.com/git-pull/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	<dev-python/alabaster-0.8[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

# no tests...
