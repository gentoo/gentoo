# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python framework for building ML & data science web apps"
HOMEPAGE="https://github.com/plotly/dash"
SRC_URI="https://github.com/plotly/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Test need some packages not yet in the tree
# flask_talisman
# percy
# ...
RESTRICT="test"

RDEPEND="
	dev-python/future[${PYTHON_USEDEP}]
	sci-visualization/dash-table[${PYTHON_USEDEP}]
	sci-visualization/dash-html-components[${PYTHON_USEDEP}]
	sci-visualization/dash-core-components[${PYTHON_USEDEP}]
	dev-python/plotly[${PYTHON_USEDEP}]
	dev-python/flask-compress[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/beautifulsoup4 )"
BDEPEND=""

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/0001-Fix-werkzeug-2.1.0-import-dev-tools-error-html-rende.patch
)
