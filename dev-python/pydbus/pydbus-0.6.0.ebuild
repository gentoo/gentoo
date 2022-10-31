# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Pythonic DBus library"
HOMEPAGE="https://github.com/LEW21/pydbus"
SRC_URI="https://github.com/LEW21/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="amd64"
SLOT="0"

RDEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	sys-apps/dbus
"

python_test() {
	sh tests/run.sh "${PYTHON}" || die
}
