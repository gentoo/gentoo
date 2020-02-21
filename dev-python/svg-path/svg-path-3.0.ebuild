# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PN="svg.path"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="SVG path objects and parser"
HOMEPAGE="https://github.com/regebro/svg.path"
SRC_URI="https://github.com/regebro/svg.path/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

python_test() {
	esetup.py test || die
}

python_install() {
	python_domodule src/svg
}
