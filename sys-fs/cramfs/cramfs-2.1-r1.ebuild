# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Linux filesystem designed to be simple, small, and to compress things well"
HOMEPAGE="https://github.com/npitre/cramfs-tools"
SRC_URI="https://github.com/npitre/cramfs-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/cramfs-tools-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

DEPEND="sys-libs/zlib:="
RDEPEND="${DEPEND}"

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" # overwrite what's hardcoded
}

src_install() {
	into /
	dosbin mkcramfs cramfsck
	dodoc README NOTES
}
