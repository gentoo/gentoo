# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/imapfilter/imapfilter-2.5.7.ebuild,v 1.2 2015/07/07 16:58:53 grobian Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="An IMAP mail filtering utility"
HOMEPAGE="http://imapfilter.hellug.gr"
SRC_URI="https://github.com/lefcha/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-libs/openssl
	dev-libs/libpcre
	>=dev-lang/lua-5.1"
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
