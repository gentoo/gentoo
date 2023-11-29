# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 optfeature pypi

DESCRIPTION="Python SNMP library"
HOMEPAGE="https://pypi.org/project/pysnmp/ https://github.com/etingof/pysnmp"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ppc ~sparc x86"
IUSE="doc examples"

RDEPEND="
	>=dev-python/pyasn1-0.2.3[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]"
PDEPEND="dev-python/pysmi[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${P}-setuptools-version.patch
	"${FILESDIR}"/${PN}-4.4.12-python310.patch
)

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
