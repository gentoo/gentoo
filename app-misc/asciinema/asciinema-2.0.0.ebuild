# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5} )
inherit distutils-r1

DESCRIPTION="Command line recorder for asciinema.org service"
HOMEPAGE="https://asciinema.org/ https://pypi.python.org/pypi/asciinema"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md doc/asciicast-v1.md )

python_test() {
	nosetests || die
}

src_install() {
	distutils-r1_src_install
	doman man/asciinema.1
}
