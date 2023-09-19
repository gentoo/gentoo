# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Attach/detach from interactive processes across the network"
HOMEPAGE="https://github.com/cosmos72/detachtty"
SRC_URI="https://github.com/cosmos72/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

PATCHES=(
	"${FILESDIR}/${P}-sparc.patch"
	"${FILESDIR}/${P}-clang16-build-fix.patch"
)

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin attachtty detachtty
	doman "${PN}.1"
	dosym detachtty.1 /usr/share/man/man1/attachtty.1
	einstalldocs
}
