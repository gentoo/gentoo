# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Vestigial utilities from IPython"
HOMEPAGE="https://github.com/ipython/ipython_genutils"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 x86"

# Needed because package provides decorators which use nose
RDEPEND="dev-python/nose[${PYTHON_USEDEP}]"

distutils_enable_tests nose
