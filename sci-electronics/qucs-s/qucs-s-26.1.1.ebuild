# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Quite universal circuit simulator with SPICE"
HOMEPAGE="https://ra3xdh.github.io/"
SRC_URI="https://github.com/ra3xdh/qucs_s/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

inherit cmake

DEPEND="
	dev-qt/qtbase:6
	dev-qt/qttools:6
	dev-qt/qtsvg:6
	dev-qt/qtcharts:6
	"

RDEPEND="
	${DEPEND}
	"

BDEPEND="
	dev-build/cmake
	sys-devel/flex
	sys-devel/bison
	dev-util/gperf
	app-text/dos2unix
	"
