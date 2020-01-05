# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Python to native compiler"
HOMEPAGE="http://www.nuitka.net"
SRC_URI="http://nuitka.net/releases/${P^}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-util/scons[${PYTHON_USEDEP}]
	"

S="${WORKDIR}/${P^}"

pkg_postinst() {
	elog "nuitka needs app-admin/chrpath for building"
	elog "stand-alone executables"
}
