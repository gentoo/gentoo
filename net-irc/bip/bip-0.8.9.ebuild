# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit eutils

DESCRIPTION="Multiuser IRC proxy with SSL support"
HOMEPAGE="http://bip.milkypond.org/"
SRC_URI="ftp://ftp.duckcorp.org/bip/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug freenode noctcp oidentd vim-syntax"

COMMON_DEPEND="
	dev-libs/openssl:0
"
DEPEND="${COMMON_DEPEND}
	sys-devel/flex
	virtual/yacc
"
RDEPEND="${COMMON_DEPEND}
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
	oidentd? ( >=net-misc/oidentd-2.0 )
"

src_prepare() {
	if use noctcp; then
		sed -i -e '/irc_privmsg_check_ctcp(server, line);/s:^://:' src/irc.c || die
	fi

	if use freenode; then
		epatch "${FILESDIR}/${PN}-freenode.patch" || die
	fi

	sed -i -e "s/-Werror//" Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable oidentd)
}

src_install() {
	dobin src/bip src/bipmkpw

	dodoc AUTHORS ChangeLog README NEWS TODO
	newdoc samples/bip.conf bip.conf.sample
	doman bip.1 bip.conf.5 bipmkpw.1

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins samples/bip.vim
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${FILESDIR}"/bip.vim
	fi
}

pkg_postinst() {
	elog 'The default configuration file is "~/.bip/bip.conf"'
	elog "You can find a sample configuration file in"
	elog "/usr/share/doc/${PF}/bip.conf.sample"
}
