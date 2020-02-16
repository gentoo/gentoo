# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Scripts to prepare and plot VOACAP propagation predictions"
HOMEPAGE="http://www.qsl.net/hz1jw/pythonprop"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		|| (
			dev-python/matplotlib-python2[gtk2,${PYTHON_MULTI_USEDEP}]
			dev-python/matplotlib[gtk2,${PYTHON_MULTI_USEDEP}]
		)
	')
	dev-python/basemap[${PYTHON_SINGLE_USEDEP}]
	sci-electronics/voacapl
"
DEPEND="${RDEPEND}"
