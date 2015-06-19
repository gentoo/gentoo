# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/usermin/usermin-1.600.ebuild,v 1.1 2014/05/28 00:35:35 tomwij Exp $

EAPI="5"

inherit eutils pam user

DESCRIPTION="A web-based user administration interface"
HOMEPAGE="http://www.webmin.com/index6.html"
SRC_URI="mirror://sourceforge/webadmin/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ipv6 ldap pam ssl syslog zlib"

DEPEND="dev-lang/perl"

RDEPEND="${DEPEND}
	|| ( virtual/perl-Digest-MD5 dev-perl/MD5 )
	dev-perl/Digest-SHA1
	dev-perl/Net-HTTP
	sys-process/lsof
	virtual/perl-Time-HiRes
	virtual/perl-Time-Local
	ipv6? ( dev-perl/Socket6 )
	ldap? ( dev-perl/perl-ldap )
	pam? ( dev-perl/Authen-PAM )
	ssl? ( dev-perl/Net-SSLeay )
	syslog? ( virtual/perl-Sys-Syslog )
	zlib? ( virtual/perl-Compress-Raw-Zlib )"

pkg_setup() {
	enewuser ${PN} -1 /bin/bash
}

src_prepare() {
	# Point to the correct mysql location
	sed -i -e "s:/usr/local/mysql:/usr:g" mysql/config

	# Change /usr/local/bin/perl references
	find . -type f | xargs sed -i -e 's:^#!.*/usr/local/bin/perl:#!/usr/bin/perl:'

	epatch "${FILESDIR}"/${PN}-1.080-safestop.patch
	epatch "${FILESDIR}"/${PN}-1.150-setup-nocheck.patch
}

src_install() {
	dodir /usr/libexec/${PN}
	cp -pR * "${D}"/usr/libexec/${PN}

	newinitd "${FILESDIR}"/${PN}-1.540-r1.init ${PN}
	newpamd "${FILESDIR}"/${PN}.pam-include.1 ${PN}

	dodir /etc/${PN}
	dodir /var/log/${PN}

	# Fix ownership
	chown -R ${PN} "${ED}"

	config_dir=${D}/etc/${PN}
	var_dir=${D}/var/log/${PN}
	perl=/usr/bin/perl
	autoos=1
	port=20000
	login=root
	crypt="XXX"
	host=`hostname`
	use ssl && ssl=1 || ssl=0
	atboot=0
	nostart=1
	nochown=1
	autothird=1
	nouninstall=1
	noperlpath=1
	tempdir="${T}"
	export config_dir var_dir perl autoos port login crypt host ssl atboot nostart nochown autothird nouninstall noperlpath tempdir
	"${D}"/usr/libexec/${PN}/setup.sh > "${T}"/${PN}-setup.out 2>&1 || die "Failed to create initial ${PN} configuration."

	# Cleanup from the config script
	rm -rf "${D}"/var/log/${PN}
	keepdir /var/log/${PN}
}

pkg_postinst() {
	elog "To make ${PN} start at boot time, run: 'rc-update add ${PN} default'."
	elog "Point your web browser to https://localhost:20000 to use ${PN}."
}
