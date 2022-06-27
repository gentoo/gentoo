# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

MY_PN="IPy"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Class and tools for handling of IPv4 and IPv6 addresses and networks"
HOMEPAGE="
	https://github.com/autocracy/python-ipy/
	https://pypi.org/project/IPy/
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc x86"
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
