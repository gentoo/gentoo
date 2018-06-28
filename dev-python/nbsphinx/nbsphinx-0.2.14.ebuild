# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Jupyter Notebook Tools for Sphinx"
HOMEPAGE="https://github.com/spatialaudio/nbsphinx/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/nbconvert[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.3.2[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"
