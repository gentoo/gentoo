# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN^}
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Python toolkit for stream-based generation of output for the web"
HOMEPAGE="
	https://genshi.edgewall.org/
	https://github.com/edgewall/genshi/
	https://pypi.org/project/Genshi/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

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
