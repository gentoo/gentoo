# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

MY_P="Genshi-${PV}"

DESCRIPTION="Python toolkit for stream-based generation of output for the web"
HOMEPAGE="http://genshi.edgewall.org/ https://pypi.org/project/Genshi/"
SRC_URI="http://ftp.edgewall.com/pub/genshi/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

python_test() {
	esetup.py test
}

python_install_all() {
	if use doc; then
		dodoc doc/*.txt
		dohtml -r doc/*
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
	distutils-r1_python_install_all
}
