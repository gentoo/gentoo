# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

MY_PV=${PV/_beta/b0}

DESCRIPTION="Local/remote mirroring+incremental backup"
HOMEPAGE="https://github.com/rdiff-backup/rdiff-backup"
SRC_URI="https://github.com/rdiff-backup/${PN}/releases/download/v${MY_PV}/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="examples"

DEPEND=">=net-libs/librsync-1.0:0="
RDEPEND="${DEPEND}
	dev-python/pylibacl[${PYTHON_USEDEP}]
	dev-python/pyxattr[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.0-no-docs.patch"
)

S=${WORKDIR}/${PN}-${MY_PV}

python_install_all() {
	local DOCS=( docs/FAQ.md )
	use examples && DOCS+=( docs/examples.md )
	distutils-r1_python_install_all
}
