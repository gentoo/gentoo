# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_7,3_8} )

inherit distutils-r1

DESCRIPTION="Github-Flavored Markdown for Python-Markdown"
HOMEPAGE="https://github.com/Zopieux/py-gfm"
SRC_URI="https://github.com/Zopieux/py-gfm/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="dev-python/markdown[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
