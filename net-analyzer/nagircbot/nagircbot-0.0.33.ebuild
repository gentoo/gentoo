# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="An irc bot that alerts you to nagios changes"
HOMEPAGE="http://www.vanheusden.com/nagircbot"
SRC_URI="http://www.vanheusden.com/nagircbot/${P}.tgz"

LICENSE="GPL-2" # GPL-2 only
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

CDEPEND="
	dev-libs/openssl:0="
DEPEND="virtual/pkgconfig
	${CDEPEND}"
RDEPEND="net-analyzer/nagios-core
	${CDEPEND}"

src_prepare() {
	cp -av Makefile{,.org}

	sed -i Makefile \
		-e 's:-lcrypto -lssl:$(shell ${PKG_CONFIG} --libs openssl):g' \
		-e 's:-O2::g;s:-g::g' \
		|| die
}

src_compile() {
	tc-export PKG_CONFIG
	emake CC=$(tc-getCC) CXX=$(tc-getCXX)
}

src_install() {
	dobin nagircbot
	newconfd "${FILESDIR}"/conf nagircbot
	newinitd "${FILESDIR}"/init nagircbot
}
