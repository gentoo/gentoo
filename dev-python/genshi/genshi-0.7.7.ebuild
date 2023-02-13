# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Python toolkit for stream-based generation of output for the web"
HOMEPAGE="https://genshi.edgewall.org/ https://pypi.org/project/Genshi/"
SRC_URI="mirror://pypi/G/${PN^}/${P^}.tar.gz"
S="${WORKDIR}/${P^}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/six[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" -m unittest -v genshi.tests.suite || die
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
