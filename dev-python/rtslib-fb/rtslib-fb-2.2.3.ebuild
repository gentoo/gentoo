# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 systemd pypi

DESCRIPTION="A Python object API for managing the Linux LIO kernel target"
HOMEPAGE="
	https://github.com/open-iscsi/rtslib-fb/
	https://pypi.org/project/rtslib-fb/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	dev-python/pyudev[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests import-check

src_install() {
	distutils-r1_src_install
	systemd_dounit "${FILESDIR}/target.service"
}
