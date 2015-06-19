# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/midentd/midentd-2.3.1-r1.ebuild,v 1.7 2014/12/29 14:19:01 pacho Exp $

EAPI=5
inherit eutils

DESCRIPTION="ident daemon with masquerading and fake replies support"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-pidfile.patch
	sed -i \
		-e 's:/usr/local:/usr:' \
		-e 's:service ident:service auth:' \
		-e 's:disable = no:disable = yes:' \
		midentd.xinetd || die
}

src_install() {
	dosbin midentd midentd.logcycle

	insinto /etc/xinetd.d
	newins midentd.xinetd midentd
	newinitd "${FILESDIR}"/midentd.rc midentd
	newconfd "${FILESDIR}"/midentd.conf.d midentd

	dodoc CHANGELOG README

	dodir /var/log
	touch "${D}"/var/log/midentd.log
	fowners nobody:nobody /var/log/midentd.log
}
