# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Core components suite for Dash"
HOMEPAGE="https://plot.ly/dash"
SRC_URI="https://github.com/plotly/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"
# Test execution depends on sci-visualization/dash being installed
# but sci-visualization/dash depends on this
RESTRICT="test"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
