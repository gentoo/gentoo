# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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
	default

	eapply -p0 "${FILESDIR}"/${PV}-pidfile.patch
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
