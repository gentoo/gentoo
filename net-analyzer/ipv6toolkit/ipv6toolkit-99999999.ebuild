# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 toolchain-funcs

DESCRIPTION="Set of IPv6 security/trouble-shooting tools to send arbitrary IPv6-based packets"
HOMEPAGE="https://www.si6networks.com/tools/ipv6toolkit/"
EGIT_REPO_URI="https://github.com/fgont/ipv6toolkit"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="
	net-libs/libpcap[ipv6(+)]
"
RDEPEND="
	${DEPEND}
	sys-apps/hwdata
"

src_prepare() {
	default
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" PREFIX="${EPREFIX}/usr"
	sed -i -e "s:ipv6toolkit/oui.txt:hwdata/oui.txt:" data/ipv6toolkit.conf manuals/ipv6toolkit.conf.5 || die
}

src_install() {
	dodir /etc
	emake install DESTDIR="${D}" PREFIX="${EPREFIX}/usr"
	#remove the included oui file
	rm "${ED}"/usr/share/ipv6toolkit/oui.txt || die
	dodoc CHANGES.TXT README.TXT
}
