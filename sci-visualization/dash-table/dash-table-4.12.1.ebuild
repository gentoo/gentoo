# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="First-Class interactive DataTable for Dash"
HOMEPAGE="https://plot.ly/dash"
SRC_URI="https://github.com/plotly/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"
# Test execution depends on sci-visualization/dash being installed
# but sci-visualization/dash depends on this
RESTRICT="test"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

distutils_enable_tests pytest

python_prepare_all() {
	# Needs percy - not available
	rm -r tests/selenium || die

	distutils-r1_python_prepare_all
}
