# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python framework for building ML & data science web apps"
HOMEPAGE="https://github.com/plotly/dash"
SRC_URI="https://github.com/plotly/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# Test need some packages not yet in the tree
# flask_talisman
# percy
# ...
RESTRICT="test"

RDEPEND="
	dev-python/plotly[${PYTHON_USEDEP}]
	dev-python/flask-compress[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/beautifulsoup4 )"

distutils_enable_tests pytest
