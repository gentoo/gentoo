# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1 git-r3 optfeature

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
	optfeature "Example programs using pysnmp" dev-python/pysnmp-apps
	optfeature "IETF and other mibs" dev-python/pysnmp-mibs
	optfeature "Dump MIBs in python format" dev-python/pysmi
}
