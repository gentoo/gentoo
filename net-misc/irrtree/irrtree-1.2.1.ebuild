# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
PATCHES="${FILESDIR}/${P}-leniency-deps.patch
	${FILESDIR}/${P}-queue-capitalisation.patch"

inherit distutils-r1

DEPEND="dev-python/asciitree
	dev-python/progressbar2"
RDEPEND="${DEPEND}"

DESCRIPTION="The BGP swiss army knife of networking"
HOMEPAGE="https://github.com/job/irrtree"
SRC_URI="https://github.com/job/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
