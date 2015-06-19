# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/mcelog/mcelog-1.0_pre3.ebuild,v 1.4 2013/02/16 18:47:19 vapier Exp $

inherit eutils toolchain-funcs

MY_PV="${PV/_/}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A tool to log and decode Machine Check Exceptions"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/cpu/mce/"
SRC_URI="mirror://kernel/linux/utils/cpu/mce/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

# test suite needs mce-inject, we don't have a package for it yet
RESTRICT="test"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.8_pre1-timestamp-mcelog.patch

	sed -i \
		-e 's:-g:${CFLAGS}:g' \
		-e 's:\tgcc:\t$(CC):g' Makefile || die "sed makefile failed"
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dosbin mcelog || die
	doman mcelog.8

	exeinto /etc/cron.daily
	newexe mcelog.cron mcelog || die

	insinto /etc/logrotate.d/
	newins mcelog.logrotate mcelog || die

	dodoc CHANGES README TODO *.pdf
}
