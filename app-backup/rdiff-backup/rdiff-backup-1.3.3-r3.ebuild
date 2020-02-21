# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

UPSTREAM_PV=$(ver_rs 0 '-')

DESCRIPTION="Local/remote mirroring+incremental backup"
HOMEPAGE="https://github.com/sol1/rdiff-backup"
SRC_URI="https://github.com/sol1/${PN}/archive/r${UPSTREAM_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="examples"

DEPEND="
	net-libs/librsync:0=
"
RDEPEND="${DEPEND}
	dev-python/pylibacl[${PYTHON_USEDEP}]
	dev-python/pyxattr[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-librsync-1.0.0.patch"
	"${FILESDIR}/${P}-no-docs.patch"
)

python_install_all() {
	local HTML_DOCS=( FAQ.html )
	use examples && HTML_DOCS+=( examples.html )
	distutils-r1_python_install_all
}
