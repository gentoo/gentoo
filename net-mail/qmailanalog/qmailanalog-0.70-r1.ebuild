# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fixheadtails toolchain-funcs

DESCRIPTION="collection of tools to help you analyze qmail's activity record"
SRC_URI="http://cr.yp.to/software/${P}.tar.gz"
HOMEPAGE="http://cr.yp.to/qmailanalog.html"

LICENSE="freedist public-domain" # public-domain for files/tai64nfrac.c
SLOT="0"
KEYWORDS="~amd64 sparc x86"
IUSE=""

DEPEND="sys-apps/groff"

src_prepare() {
	eapply_user
	eapply "${FILESDIR}"/${PV}-errno.patch
	ht_fix_file auto_home.c.do default.do Makefile
}

src_configure() {
	echo "/var/qmail" > conf-home || die
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
}

src_compile() {
	default
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} \
		"${FILESDIR}"/tai64nfrac.c -o tai64nfrac || die
}

src_test() { :; }

src_install() {
	doman matchup.1 xqp.1 xsender.1 xrecipient.1 columnt.1
	dodoc MATCHUP ACCOUNTING BLURB

	exeopts -o root -g qmail -m 755
	exeinto /var/qmail/bin
	doexe columnt ddist deferrals failures matchup recipients rhosts
	doexe rxdelay senders successes suids xqp xrecipient xsender
	doexe zddist zdeferrals zfailures zoverall zrecipients zrhosts
	doexe zrxdelay zsenders zsendmail zsuccesses zsuids tai64nfrac
}
