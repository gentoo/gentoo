# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Python scripts to manipulate trash cans via the command line"
HOMEPAGE="https://github.com/andreafrancia/trash-cli"
SRC_URI="https://github.com/andreafrancia/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests nose
