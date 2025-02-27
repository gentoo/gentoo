# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Pythonic DBus library"
HOMEPAGE="https://github.com/LEW21/pydbus"
SRC_URI="https://github.com/LEW21/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64"

RDEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	sys-apps/dbus
"

python_test() {
	PYTHONPATH="${BUILD_DIR}/install/$(python_get_sitedir)" \
		sh tests/run.sh "${PYTHON}" || die
}
