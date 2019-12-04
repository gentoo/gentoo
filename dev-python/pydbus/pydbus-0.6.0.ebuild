# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Pythonic DBus library"
HOMEPAGE="https://github.com/LEW21/pydbus"
SRC_URI="https://github.com/LEW21/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86 "
SLOT="0"

IUSE="doc examples"

RDEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	sys-apps/dbus"

python_install_all() {
	use doc && dodoc -r doc/*
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}

python_test() {
	sh tests/run.sh "${PYTHON}" || die
}
