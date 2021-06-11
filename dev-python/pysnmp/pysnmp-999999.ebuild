# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1 git-r3

DESCRIPTION="Python SNMP library"
HOMEPAGE="https://pypi.org/project/pysnmp/	https://github.com/etingof/pysnmp"
EGIT_REPO_URI="https://github.com/etingof/pysnmp"

LICENSE="BSD"
SLOT="0"
IUSE="doc examples"

RDEPEND="
	>=dev-python/pyasn1-0.2.3[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]"
PDEPEND="dev-python/pysmi[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs/source

python_prepare_all() {
	touch docs/source/conf.py || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r examples/. docs/mibs
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "You may also be interested in the following packages: "
	elog "dev-python/pysnmp-apps - example programs using pysnmp"
	elog "dev-python/pysnmp-mibs - IETF and other mibs"
	elog "dev-python/pysmi - to dump MIBs in python format"
}
