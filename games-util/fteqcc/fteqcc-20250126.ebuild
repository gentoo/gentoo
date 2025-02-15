# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Quake-C compiler"
HOMEPAGE="https://www.fteqcc.org/"
MY_COMMIT="f767d952e3ad8bbcb52f1cd6e2e36a47e3dbaa87"
SRC_URI="https://github.com/fte-team/fteqw/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/fteqw-${MY_COMMIT}/engine/qclib"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	newbin fteqcc.bin fteqcc
	dodoc readme.txt
}
