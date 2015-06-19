# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-geoclue/python-geoclue-0.1.0-r1.ebuild,v 1.13 2015/04/08 08:05:04 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Geoclue python module"
HOMEPAGE="http://live.gnome.org/gtg/soc/python_geoclue/"
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

python_prepare_all() {
	use test && DISTUTILS_NO_PARALLEL_BUILD=true
	distutils-r1_python_prepare_all
}

python_test() {
	VIRTUALX_COMMAND="${PYTHON}"
	cd "${BUILD_DIR}" || die
	virtualmake "${S}"/tests/test.py
}
