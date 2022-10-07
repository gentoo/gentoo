# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 prefix

DESCRIPTION="Tool to help select distfiles mirrors for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Mirrorselect"
SRC_URI="https://dev.gentoo.org/~dolsen/releases/mirrorselect/${P}.tar.gz
	https://dev.gentoo.org/~dolsen/releases/mirrorselect/mirrorselect-test
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="ipv6"

RDEPEND="
	dev-util/dialog
	>=net-analyzer/netselect-0.4[ipv6(+)?]
	>=dev-python/ssl-fetch-0.3[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/mirrorselect-2.3.0-setup.py.patch"
)

python_prepare_all() {
	python_setup
	eprefixify setup.py mirrorselect/main.py
	echo Now setting version... VERSION="${PVR}" "${PYTHON}" setup.py set_version
	VERSION="${PVR}" "${PYTHON}" setup.py set_version || die "setup.py set_version failed"

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test || die "tests failed under ${EPYTHON}"
}
