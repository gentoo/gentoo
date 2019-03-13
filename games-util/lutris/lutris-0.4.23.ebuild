# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{4,5,6,7} )
PYTHON_REQ_USE="sqlite,threads(+)"

inherit distutils-r1 virtualx xdg

DESCRIPTION="An open source gaming platform for GNU/Linux"
HOMEPAGE="https://lutris.net/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/lutris/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/lutris/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

BDEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"
RDEPEND="
	app-arch/cabextract
	app-arch/p7zip
	app-arch/unrar
	app-arch/unzip
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-evdev[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	net-libs/libsoup
	x11-apps/xgamma
	x11-apps/xrandr
	x11-libs/gtk+:3[introspection]
"

python_install_all() {
	local DOCS=( AUTHORS README.rst docs/installers.rst )
	distutils-r1_python_install_all
}

python_test() {
	virtx nosetests -v || die
}

pkg_postinst() {
	xdg_pkg_postinst

	# Quote README.rst
	elog "Lutris installations are fully automated through scripts, which can"
	elog "be written in either JSON or YAML. The scripting syntax is described"
	elog "in ${EROOT%/}/usr/share/doc/${PF}/installers.rst.bz2, and is also"
	elog "available online at lutris.net."
}
