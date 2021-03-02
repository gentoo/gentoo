# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A module to handle standardized numbers and codes"
HOMEPAGE="https://arthurdejong.org/python-stdnum/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="vies"

RDEPEND="
	vies? (
		|| (
			dev-python/zeep[${PYTHON_USEDEP}]
			dev-python/suds[${PYTHON_USEDEP}]
		)
	)"

DOCS=( ChangeLog NEWS README )

distutils_enable_tests nose
