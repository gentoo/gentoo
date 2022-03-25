# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Very versatile TCP pipes"
HOMEPAGE="https://bisqwit.iki.fi/source/pipes.html"
SRC_URI="https://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~s390 x86"
PATCHES=(
	"${FILESDIR}"/${P}-execlp.patch
)

src_compile() {
	# Prevent the build system from looking for dependencies
	touch .depend || die

	emake CC="$(tc-getCC)" OPTIM="${CFLAGS}" LDFLAGS="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin plis
	dosym plis /usr/bin/pcon
	dodoc ChangeLog Examples README.html
}
