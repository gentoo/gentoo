# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 systemd pypi

DESCRIPTION="A Python object API for managing the Linux LIO kernel target"
HOMEPAGE="
	https://github.com/open-iscsi/rtslib-fb/
	https://pypi.org/project/rtslib-fb/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/pyudev[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

src_install() {
	distutils-r1_src_install
	systemd_dounit "${FILESDIR}/target.service"
}
