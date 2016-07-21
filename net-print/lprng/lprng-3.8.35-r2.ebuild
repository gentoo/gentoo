# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils flag-o-matic

MY_PN=LPRng
DESCRIPTION="Extended implementation of the Berkeley LPR print spooler"
HOMEPAGE="http://www.lprng.com/"
SRC_URI="ftp://ftp.lprng.com/pub/${MY_PN}/${MY_PN}/${MY_PN}-${PV}.tgz"

LICENSE="|| ( GPL-2 Artistic )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE="foomaticdb kerberos nls ssl"

RDEPEND="sys-process/procps
	ssl? ( dev-libs/openssl )
	foomaticdb? ( net-print/foomatic-filters net-print/foomatic-db )
	!>=net-print/cups-1.6.2-r4[-lprng-compat]
	!<net-print/cups-1.6.2-r4"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	kerberos? ( app-crypt/mit-krb5 )"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.8.27-certs.diff
	epatch "${FILESDIR}"/${PN}-3.8.28-make.diff
	epatch "${FILESDIR}"/${PN}-3.8.28-krb.diff
}

src_configure() {
	# wont compile with -O3, needs -O2
	replace-flags -O[3-9] -O2

	econf \
		$(use_enable nls) \
		$(use_enable kerberos) \
		$(use_enable ssl) \
		--disable-setuid \
		--disable-werror \
		--with-userid=lp \
		--with-groupid=lp \
		--with-lpd_conf_path=/etc/lprng/lpd.conf \
		--with-lpd_perms_path=/etc/lprng/lpd.perms \
		--libexecdir=/usr/libexec/lprng \
		--sysconfdir=/etc/lprng \
		--disable-strip
}

src_compile() {
	# bash is necessary due to bashisms in libtool
	emake -j1 SHELL=/bin/bash
}

src_install() {
	dodir /var/spool/lpd
	diropts -m 700 -o lp -g lp
	dodir /var/spool/lpd/lp

	emake install \
		DESTDIR="${D}" \
		POSTINSTALL="NO" \
		gnulocaledir="${D}"/usr/share/locale

	dodoc CHANGES README VERSION "${FILESDIR}"/printcap lpd.conf lpd.perms

	insinto /etc/lprng
	doins "${FILESDIR}"/printcap lpd.conf lpd.perms
	dosym /etc/lprng/printcap /etc/printcap
	newinitd "${FILESDIR}"/lprng-init lprng
}

pkg_postinst() {
	einfo "If printing does not work, try 'checkpc'/'checkpc -f'"
}
