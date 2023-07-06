# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="xml(+)"

inherit edo distutils-r1 prefix

DESCRIPTION="Tool to help select distfiles mirrors for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Mirrorselect"
SRC_URI="
	https://dev.gentoo.org/~dolsen/releases/mirrorselect/${P}.tar.gz
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
	"${FILESDIR}"/${P}-setup.py.patch
	"${FILESDIR}"/${P}-main-Fix-all-option-parsing.patch
)

distutils_enable_tests setup.py

python_prepare_all() {
	python_setup

	eprefixify setup.py mirrorselect/main.py
	VERSION="${PVR}" edo "${PYTHON}" setup.py set_version

	distutils-r1_python_prepare_all
}
