# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PN="TTFQuery"
MY_PV="${PV/_beta/b}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Font metadata and glyph outline extraction utility library"
HOMEPAGE="http://ttfquery.sourceforge.net/ https://pypi.org/project/TTFQuery/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE=""

DEPEND="dev-python/fonttools[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
