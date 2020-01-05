# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

MY_PN=BitTornado
MY_P=${MY_PN}-${PV}
EGIT_COMMIT="ed327c4e1ebbe1fe949be81723527cfda87aeb8d"

DESCRIPTION="John Hoffman's fork of the original bittorrent"
HOMEPAGE="https://github.com/effigies/BitTornado"
SRC_URI="https://github.com/effigies/BitTornado/archive/${EGIT_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
# GPL-2 is just for the init script from FILESDIR.
LICENSE="MIT GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	|| (
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]
	)"
DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${MY_PN}-${EGIT_COMMIT}

python_prepare_all() {
	# https://github.com/effigies/BitTornado/pull/53
	sed -e 's:"BitTornado.Tracker":\0, "BitTornado.Types":' -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v BitTornado/tests || die "tests failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	newconfd "${FILESDIR}"/bttrack.conf bttrack
	newinitd "${FILESDIR}"/bttrack.rc bttrack
}
