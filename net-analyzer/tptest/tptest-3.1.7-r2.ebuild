# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV="${PV/./_}"

DESCRIPTION="Internet bandwidth tester"
HOMEPAGE="http://tptest.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.7-getstatsfromlinevuln.patch
)

src_prepare() {
	default

	sed -i apps/unix/{client,server}/Makefile \
		-e "s:^CFLAGS[[:space:]]*=:CFLAGS+=:" \
		|| die

	cp -f os-dep/unix/* . || die
	cp -f engine/* . || die
}

src_compile() {
	emake -C apps/unix/client \
		CC="$(tc-getCC)" \
		LDFLAGS="${LDFLAGS}"

	emake -C apps/unix/server \
		CC="$(tc-getCC)" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin apps/unix/client/tptestclient
	dosbin apps/unix/server/tptestserver

	insinto /etc
	doins apps/unix/server/tptest.conf
}
