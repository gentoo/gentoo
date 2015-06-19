# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/tenshi/tenshi-0.12.ebuild,v 1.7 2012/05/31 02:59:03 zmedico Exp $

EAPI=4
inherit eutils user

DESCRIPTION="Log parsing and notification program"
HOMEPAGE="http://dev.inversepath.com/trac/tenshi"
SRC_URI="http://dev.inversepath.com/tenshi/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/IO-BufferedSelect
	sys-apps/coreutils"

pkg_setup() {
	enewgroup tenshi
	enewuser tenshi -1 -1 /var/lib/tenshi tenshi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-create-mandir.patch"
	epatch "${FILESDIR}/${PN}-openrc-init.patch" #218042
	epatch "${FILESDIR}/${PN}-openrc-init-r1.patch" #398987

	# Fix for bug #241254
	sed -i 's:^docdir =.*:docdir = /usr/share/doc/${PF}:' \
		Makefile || die "docdir substitution failed"
}

src_install() {
	emake DESTDIR="${D}" install
	fowners tenshi:root /etc/tenshi/tenshi.conf
	dodir /var/lib/tenshi
	fowners tenshi:root /var/lib/tenshi
	doman tenshi.8
	newinitd tenshi.gentoo-init tenshi
	keepdir /var/lib/tenshi
}

pkg_postinst() {
	ewarn "The sample config installed to ${ROOT}etc/tenshi/tenshi.conf"
	ewarn "monitors /var/log/messages which, by default, can not be read"
	ewarn "by the tenshi user.  Make sure that the tenshi user has read"
	ewarn "permission on all the files that you want tenshi to monitor."
}
