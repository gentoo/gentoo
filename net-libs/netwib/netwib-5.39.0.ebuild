# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# NOTE: netwib, netwox and netwag go together, bump all or bump none

EAPI=5
inherit toolchain-funcs multilib

DESCRIPTION="Library of Ethernet, IP, UDP, TCP, ICMP, ARP and RARP protocols"
HOMEPAGE="
	http://www.laurentconstantin.com/en/netw/netwib/
	http://ntwib.sourceforge.net/
"
SRC_URI="mirror://sourceforge/ntwib/${P}-src.tgz
	doc? ( mirror://sourceforge/ntwib/${P}-doc_html.tgz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc x86"
IUSE="doc"

DEPEND="
	net-libs/libnet:1.1
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}-src/src

src_prepare() {
	sed -i \
		-e 's:/man$:/share/man:g' \
		-e "s:/lib:/$(get_libdir):" \
		-e "s:/usr/local:/usr:" \
		-e "s:=ar:=$(tc-getAR):" \
		-e "s:=ranlib:=$(tc-getRANLIB):" \
		-e "s:=gcc:=$(tc-getCC):" \
		-e "s:-O2:${CFLAGS}:" \
		config.dat || die
}

src_configure() {
	sh genemake || die
}

src_install() {
	default
	dodoc ../README.TXT
	if use doc; then
		mkdir "${D}"/usr/share/doc/${PF}/html
		mv "${WORKDIR}"/${P}-doc_html/{index.html,${PN}} \
			"${D}"/usr/share/doc/${PF}/html
	fi

	cd "${S}"/..
	dodoc \
		doc/{changelog.txt,credits.txt,integration.txt} \
		doc/{problemreport.txt,problemusageunix.txt,todo.txt}
}
