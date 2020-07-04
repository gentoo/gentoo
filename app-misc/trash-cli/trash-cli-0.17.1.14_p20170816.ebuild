# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 vcs-snapshot

GIT_REF=5abecd53e1d84f2a5fd3fc60d2f5d71e518826c5

DESCRIPTION="Python scripts to manipulate trash cans via the command line"
HOMEPAGE="https://github.com/andreafrancia/trash-cli"
SRC_URI="https://github.com/andreafrancia/${PN}/archive/${GIT_REF}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

python_test() {
	nosetests -v || die
}
