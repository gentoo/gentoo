# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO: test phase

EAPI=7

PYTHON_COMPAT=( python{3_7,3_8} )
PYTHON_REQ_USE="xml"

inherit distutils-r1

DESCRIPTION="Python framework for efficient cluster administration"
HOMEPAGE="https://cea-hpc.github.com/clustershell/"
SRC_URI="https://github.com/cea-hpc/clustershell/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="
	${CDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

RDEPEND="
	${CDEPEND}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-libs/openssl:0="
RESTRICT="test" # currently fail

python_install() {
	distutils-r1_python_install
	python_optimize
}

python_test() {
	cd tests || die
	nosetests -sv --all-modules || die
}

pkg_postinst() {
	einfo
	einfo "Some default system-wide config files have been installed into"
	einfo "/etc/${PN}"
	einfo
}
