# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_P="PyBluez-${PV}"

DESCRIPTION="Python bindings for Bluez Bluetooth Stack"
HOMEPAGE="https://github.com/pybluez/pybluez"
SRC_URI="mirror://pypi/P/PyBluez/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples"

RDEPEND="net-wireless/bluez"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x usr/share/doc/${PF}/examples
	fi
}
