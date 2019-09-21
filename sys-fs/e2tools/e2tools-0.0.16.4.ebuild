# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="utilities to read, write, and manipulate files in an ext2/ext3 filesystem"
HOMEPAGE="https://github.com/ndim/e2tools"
SRC_URI="https://github.com/ndim/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-fs/e2fsprogs
	sys-libs/e2fsprogs-libs"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# The configure script is ancient.
	#export CONFIG_SHELL="/bin/bash"
	tc-export CC
	default
}
