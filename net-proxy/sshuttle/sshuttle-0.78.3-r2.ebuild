# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit linux-info distutils-r1

DESCRIPTION="Transparent proxy server that works as a poor man's VPN using ssh"
HOMEPAGE="https://github.com/sshuttle/sshuttle https://pypi.python.org/pypi/sshuttle"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	net-firewall/iptables
"
DEPEND="
	dev-python/sphinx
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

CONFIG_CHECK="~NETFILTER_XT_TARGET_HL ~IP_NF_TARGET_REDIRECT ~IP_NF_MATCH_TTL ~NF_NAT"

PATCHES=( "${FILESDIR}"/${P}-remote-python.patch )

python_prepare_all() {
	# don't run tests via setup.py pytest
	sed -i "/setup_requires=/s/'pytest-runner'//" setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	emake -C docs html man
}

python_test() {
	py.test || die "Tests fail under ${EPYTHON}"
}

python_install_all() {
	HTML_DOCS=( "${S}"/docs/_build/html/. )
	doman "${S}"/docs/_build/man/*
	distutils-r1_python_install_all
}
