# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Package/Module importer for importing code from Jupyter Notebook files"
HOMEPAGE="http://ipython.org/"
SRC_URI="https://github.com/ipython/ipynb/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
