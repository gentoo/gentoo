# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Class and tools for handling of IPv4 and IPv6 addresses and networks"
HOMEPAGE="
	https://github.com/autocracy/python-ipy/
	https://pypi.org/project/IPy/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="examples"

python_test() {
	"${EPYTHON}" test/test_IPy.py || die "Tests fail with ${EPYTHON}"
	"${EPYTHON}" test_doc.py || die "Doctests fail with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
