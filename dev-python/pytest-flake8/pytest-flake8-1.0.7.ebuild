# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="py.test plugin for flake8"
HOMEPAGE="https://github.com/tholo/pytest-flake8 https://pypi.org/project/pytest-flake8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 x86"

RDEPEND="
	>=dev-python/flake8-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-3.5[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
