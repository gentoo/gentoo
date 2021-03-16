# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="IPython-enabled pdb"
HOMEPAGE="https://pypi.org/project/ipdb/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND=">=dev-python/ipython-7.17[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	app-arch/unzip"

DOCS=( HISTORY.txt )

distutils_enable_tests unittest
