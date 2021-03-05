# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Local/remote mirroring+incremental backup"
HOMEPAGE="https://github.com/rdiff-backup/rdiff-backup"
SRC_URI="https://github.com/rdiff-backup/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="examples"

DEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]
	>=net-libs/librsync-1.0:0="
RDEPEND="dev-python/pylibacl[${PYTHON_USEDEP}]
	dev-python/pyxattr[${PYTHON_USEDEP}]
	>=net-libs/librsync-1.0:0="

PATCHES=(
	"${FILESDIR}/${PN}-2.0.3-no-docs.patch"
)

python_install_all() {
	local DOCS=( docs/FAQ.md )
	use examples && DOCS+=( docs/examples.md )
	distutils-r1_python_install_all
}
