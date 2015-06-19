# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/acct/acct-6.5.5-r3.ebuild,v 1.6 2013/12/21 17:22:15 ago Exp $

EAPI=3
inherit eutils autotools systemd

DESCRIPTION="GNU system accounting utilities"
HOMEPAGE="https://savannah.gnu.org/projects/acct/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~mips ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-6.5.5-cross-compile.patch \
		"${FILESDIR}"/${PN}-6.5.5-no-gets.patch
	eautoreconf
}

src_configure() {
	econf --enable-linux-multiformat
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
	keepdir /var/account
	newinitd "${FILESDIR}"/acct.initd acct || die
	newconfd "${FILESDIR}"/acct.confd acct || die
	systemd_dounit "${FILESDIR}"/acct.service
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/acct.logrotate acct || die

	# sys-apps/sysvinit already provides this
	rm "${ED}"/usr/bin/last "${ED}"/usr/share/man/man1/last.1 || die

	# accton in / is only a temp workaround for #239748
	dodir /sbin
	mv "${ED}"/usr/sbin/accton "${ED}"/sbin/ || die
}
