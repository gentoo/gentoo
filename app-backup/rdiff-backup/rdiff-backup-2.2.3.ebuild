# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYPI_NO_NORMALIZE=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Local/remote mirroring+incremental backup"
HOMEPAGE="https://github.com/rdiff-backup/rdiff-backup"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
# Tests use a tox environment and separate steps for test env preparation
RESTRICT="test"

DEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]
	>=net-libs/librsync-1.0:0="
RDEPEND="dev-python/pylibacl[${PYTHON_USEDEP}]
	dev-python/pyxattr[${PYTHON_USEDEP}]
	>=net-libs/librsync-1.0:0="

src_prepare() {
	sed -e "s#share/doc/${PN}#share/doc/${PF}#" -i setup.py || die
	default
}
