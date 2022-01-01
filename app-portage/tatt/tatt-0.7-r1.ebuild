# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="arch testing tool"
HOMEPAGE="https://github.com/gentoo/tatt"
SRC_URI="https://github.com/gentoo/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="+templates"

RDEPEND="
	app-portage/eix
	app-portage/gentoolkit[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	www-client/pybugz
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all
	if use templates; then
		insinto "/usr/share/${PN}"
		doins -r templates
	fi
	doman tatt.1
	doman tatt.5
}
