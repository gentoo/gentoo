# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib-minimal user

DESCRIPTION="NSS module for name lookups using LDAP"
HOMEPAGE="http://arthurdejong.org/nss-pam-ldapd/"
SRC_URI="http://arthurdejong.org/nss-pam-ldapd/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug kerberos sasl +pam"

DEPEND="
	net-nds/openldap
	sasl? ( dev-libs/cyrus-sasl )
	kerberos? ( virtual/krb5 )
	virtual/pam
	!sys-auth/nss_ldap
	!sys-auth/pam_ldap"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup nslcd
	enewuser nslcd -1 -1 -1 nslcd
}

multilib_src_configure() {
	# nss libraries always go in /lib on Gentoo
	myconf="
		--enable-warnings
		--with-ldap-lib=openldap
		--with-ldap-conf-file=/etc/nslcd.conf
		--with-nslcd-pidfile=/run/nslcd/nslcd.pid
		--with-nslcd-socket=/run/nslcd/socket
		--with-pam-seclib-dir=/$(get_libdir)/security
		--libdir=/$(get_libdir)
		$(use_enable debug)
		$(use_enable kerberos)
		$(use_enable pam)
		$(use_enable sasl)"

	if use x86-fbsd; then
		myconf+=" --with-nss-flavour=freebsd"
	else
		myconf+=" --with-nss-flavour=glibc"
	fi

	ECONF_SOURCE="${S}" econf ${myconf}
}

multilib_src_install() {
	default

	# for socket and pid file (not needed bug 452992)
	#keepdir /run/nslcd

	# init script
	newinitd "${FILESDIR}"/nslcd-init-r1 nslcd

	# make an example copy
	insinto /usr/share/nss-pam-ldapd
	doins "${WORKDIR}/${P}/nslcd.conf"

	fperms o-r /etc/nslcd.conf
}

pkg_postinst() {
	echo
	elog "For this to work you must configure /etc/nslcd.conf"
	elog "This configuration is similar to pam_ldap's /etc/ldap.conf"
	echo
	elog "In order to use nss-pam-ldapd, nslcd needs to be running. You can"
	elog "start it like this:"
	elog "  # /etc/init.d/nslcd start"
	echo
	elog "You can add it to the default runlevel like so:"
	elog " # rc-update add nslcd default"
	elog
	elog "If you are upgrading, keep in mind that /etc/nss-ldapd.conf"
	elog " is now named /etc/nslcd.conf"
	echo
}
