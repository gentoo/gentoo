# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="An HTML minification plugin for Pelican, the static site generator."
HOMEPAGE="https://pypi.org/project/pelican-minify/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/joblib-0.9[${PYTHON_USEDEP}]
	>=app-text/htmlmin-0.1.5[${PYTHON_USEDEP}]
	>=app-text/pelican-3.1.1[${PYTHON_USEDEP}]"
