# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Geek code generator"
HOMEPAGE="https://sourceforge.net/projects/geekcode"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~mips ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"

src_prepare() {
	eapply -p0 "${FILESDIR}/${P}-exit.patch"
	sed -i Makefile -e 's| -o | ${LDFLAGS}&|g' || die "sed Makefile"

	eapply_user

	append-flags -fcommon
}

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	dobin geekcode
	dodoc CHANGES README geekcode.txt
}
