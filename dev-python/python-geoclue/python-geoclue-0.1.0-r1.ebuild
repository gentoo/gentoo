# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Geoclue python module"
HOMEPAGE="https://live.gnome.org/gtg/soc/python_geoclue/"
SRC_URI="http://www.paulocabido.com/soc/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"
IUSE="test"

RDEPEND="
	app-misc/geoclue:0
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]"
DEPEND="test? ( app-misc/geoclue:0 )"

S="${WORKDIR}"/${PN}

python_test() {
	VIRTUALX_COMMAND="${PYTHON}"
	cd "${BUILD_DIR}" || die
	virtualmake "${S}"/tests/test.py
}
