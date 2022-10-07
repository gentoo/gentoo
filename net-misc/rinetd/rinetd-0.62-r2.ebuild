# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="redirects TCP connections from one IP address and port to another"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+ GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare() {
	default

	sed -i '/gcc rinetd/d' Makefile || die
}

src_compile() {
	tc-export CC

	emake CFLAGS="${CFLAGS} -DLINUX"
}

src_install() {
	dosbin rinetd
	doman rinetd.8
	einstalldocs

	docinto html
	dodoc index.html

	newinitd "${FILESDIR}"/rinetd.rc rinetd
}
