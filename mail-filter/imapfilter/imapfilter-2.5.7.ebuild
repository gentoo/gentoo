# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="An IMAP mail filtering utility"
HOMEPAGE="http://imapfilter.hellug.gr"
SRC_URI="https://github.com/lefcha/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-libs/openssl:0
	dev-libs/libpcre
	dev-lang/lua:*"
DEPEND="${RDEPEND}"

DOCS="AUTHORS NEWS README samples/*"

src_prepare() {
	sed -i -e "/^PREFIX/s:/usr/local:${EPREFIX}/usr:" \
		-e "/^MANDIR/s:man:share/man:" \
		-e "/^CFLAGS/s:CFLAGS =:CFLAGS +=:" \
		-e "/^CFLAGS/s/-O//" \
		src/Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	default
	doman doc/imapfilter.1 doc/imapfilter_config.5
}
