# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/bottleneck/bottleneck-0.8.0.ebuild,v 1.5 2015/04/15 08:13:12 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

MY_PN="Bottleneck"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Fast NumPy array functions written in Cython"
HOMEPAGE="http://berkeleyanalytics.com/bottleneck"
SRC_URI="mirror://pypi/B/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"

S="${WORKDIR}"/${MY_P}

python_prepare_all() {
	emake cfiles
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${BUILD_DIR}" || die
	${PYTHON} -c "import bottleneck;bottleneck.test(extra_argv=['--verbosity=3'])" || die
}
