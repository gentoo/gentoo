# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} pypy3 )

inherit distutils-r1

DESCRIPTION="Python toolkit for stream-based generation of output for the web"
HOMEPAGE="http://genshi.edgewall.org/ https://pypi.org/project/Genshi/"
SRC_URI="mirror://pypi/G/${PN^}/${P^}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc examples"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${BDEPEND}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P^}"

python_test() {
	esetup.py test
}

python_install_all() {
	if use doc; then
		dodoc doc/*.txt
	fi
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
