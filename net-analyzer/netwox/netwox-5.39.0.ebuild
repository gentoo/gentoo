# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netwox/netwox-5.39.0.ebuild,v 1.4 2014/07/14 23:16:34 jer Exp $

# NOTE: netwib, netwox and netwag go together, bump all or bump none

EAPI=5
inherit multilib toolchain-funcs

DESCRIPTION="Toolbox of 217 utilities for testing Ethernet/IP networks"
HOMEPAGE="
	http://ntwox.sourceforge.net/
	http://www.laurentconstantin.com/en/netw/netwox/
"
SRC_URI="mirror://sourceforge/ntwox/${P}-src.tgz
	doc? ( mirror://sourceforge/ntwox/${P}-doc_html.tgz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc x86"
IUSE="doc"

DEPEND="
	net-libs/libnet:1.1
	net-libs/libpcap
	~net-libs/netwib-${PV}
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
	sed -i \
		-e "s:-o netwox:& \${LDFLAGS}:g" \
		-e 's: ; make: ; \\$(MAKE):g' \
		genemake || die
}

src_configure() {
	sh genemake || die
}

DOCS=(
	"${WORKDIR}"/${P}-src/README.TXT
	"${WORKDIR}"/${P}-src/doc/{changelog.txt,credits.txt}
	"${WORKDIR}"/${P}-src/doc/{problemreport.txt,problemusageunix.txt,todo.txt}
)

src_install() {
	default

	use doc && dohtml -r "${WORKDIR}"/${P}-doc_html/*
}
