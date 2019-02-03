# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
inherit distutils-r1

DESCRIPTION="Record terminal sessions as SVG animations"
HOMEPAGE="https://github.com/nbedos/termtosvg"
SRC_URI="https://github.com/nbedos/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	>=dev-python/pyte-0.8.0[${PYTHON_USEDEP}]
	dev-python/svgwrite[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
