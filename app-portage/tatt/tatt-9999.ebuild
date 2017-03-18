# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 git-r3

DESCRIPTION="arch testing tool"
HOMEPAGE="https://github.com/kensington/tatt"
EGIT_REPO_URI="https://github.com/kensington/tatt.git \
	git://github.com/kensington/tatt.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+templates"

RDEPEND="
	app-portage/eix
	app-portage/gentoolkit
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	www-client/pybugz
"
DEPEND="${RDEPEND}
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
