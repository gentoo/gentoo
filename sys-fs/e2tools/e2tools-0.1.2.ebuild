# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="utilities to read, write, and manipulate files in an ext2/ext3 filesystem"
HOMEPAGE="https://github.com/ndim/e2tools"
SRC_URI="https://github.com/e2tools/e2tools/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=sys-fs/e2fsprogs-1.27"
RDEPEND="${DEPEND}"

src_configure() {
	tc-export CC
	default
}
