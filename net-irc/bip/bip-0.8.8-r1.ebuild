# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
inherit eutils autotools

DESCRIPTION="Multiuser IRC proxy with SSL support"
HOMEPAGE="http://bip.milkypond.org/"
SRC_URI="ftp://ftp.duckcorp.org/bip/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug freenode noctcp ssl vim-syntax oidentd"

DEPEND="sys-devel/flex
	virtual/yacc
	ssl? ( dev-libs/openssl )"

RDEPEND="${DEPEND}
	vim-syntax? (
		|| ( app-editors/vim app-editors/gvim ) )
	oidentd? ( >=net-misc/oidentd-2.0 )"

src_prepare() {
	epatch "${FILESDIR}/${P}-configure.patch" || die
	epatch "${FILESDIR}/${PN}-CVE-2012-0806.patch" || die

	eautoreconf

	if use noctcp; then
		sed -i -e '/irc_privmsg_check_ctcp(server, line);/s:^://:' src/irc.c || die
	fi

	if use freenode; then
		epatch "${FILESDIR}/${PN}-freenode.patch" || die
	fi
}

src_configure() {
	econf \
		$(use_with ssl openssl) \
		$(use_enable debug) \
		$(use_enable oidentd)
}

src_compile() {
	# Parallel make fails.
	emake -j1 || die "emake failed"
}

src_install() {
	dobin src/bip src/bipmkpw || die "dobin failed"

	dodoc AUTHORS ChangeLog README NEWS TODO || die "dodoc failed"
	newdoc samples/bip.conf bip.conf.sample || die "newdoc failed"
	doman bip.1 bip.conf.5 bipmkpw.1 || die "doman failed"

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins samples/bip.vim || die "doins failed"
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${FILESDIR}"/bip.vim || die "doins failed"
	fi
}

pkg_postinst() {
	elog 'The default configuration file is "~/.bip/bip.conf"'
	elog "You can find a sample configuration file in"
	elog "/usr/share/doc/${PF}/bip.conf.sample"
}
