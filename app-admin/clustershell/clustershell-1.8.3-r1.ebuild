# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="Python framework for efficient cluster administration"
HOMEPAGE="https://cea-hpc.github.com/clustershell/"
SRC_URI="https://github.com/cea-hpc/clustershell/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

BDEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

RDEPEND="
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
