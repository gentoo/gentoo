# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WANT_AUTOMAKE="1.9"

inherit user eutils multilib flag-o-matic autotools

DESCRIPTION="389 Directory Server (core librares and daemons )"
HOMEPAGE="http://port389.org/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="autobind auto-dn-suffix debug doc +pam-passthru +dna +ldapi +bitwise +presence kerberos selinux"

# Pinned to db:4.8 as it is the current stable, can change to a later db version < 6 when they stabilize.
# The --with-db-inc line in econf will need to be updated as well when changing db version.
COMMON_DEPEND="
	sys-libs/db:4.8
	>=dev-libs/cyrus-sasl-2.1.19
	>=net-analyzer/net-snmp-5.1.2
	>=dev-libs/icu-3.4:=
	dev-libs/nss[utils]
	dev-libs/nspr
	dev-libs/svrcore
	dev-libs/openssl:0=
	dev-libs/libpcre:3
	>=dev-perl/perl-mozldap-1.5.3
	dev-perl/NetAddr-IP
	net-nds/openldap
	sys-libs/pam
	sys-libs/zlib
	kerberos? ( >=app-crypt/mit-krb5-1.7-r100[openldap] )"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-dirsrv )
	virtual/perl-Time-Local
	virtual/perl-MIME-Base64"

pkg_setup() {
	enewgroup dirsrv
	enewuser dirsrv -1 -1 -1 dirsrv
}

src_prepare() {
	#0001-Ticket-47840-add-configure-option-to-disable-instanc.patch
	epatch "${FILESDIR}/389-ds-base-1.3.4-no-instance-script.patch"

	# as per 389 documentation, when 64bit, export USE_64
	use amd64 && export USE_64=1

	# This will be changed in 1.3.5.X
	sed -i -e 's/nobody/dirsrv/g' configure.ac || die "sed failed on configure.ac"
	eautoreconf

	append-lfs-flags
}

src_configure() {
	# for 1.3.5.X, will add --enable-gcc-security.
	# auto-dn-suffix currently throws warning in configure script,
	# see https://fedorahosted.org/389/ticket/48710
	econf \
		$(use_enable debug) \
		$(use_enable pam-passthru) \
		$(use_enable ldapi) \
		$(use_enable autobind) \
		$(use_enable dna) \
		$(use_enable bitwise) \
		$(use_enable presence) \
		$(use_with kerberos) \
		$(use_enable debug) \
		$(use_enable auto-dn-suffix) \
		--enable-maintainer-mode \
		--with-fhs \
		--with-openldap \
		--sbindir=/usr/sbin \
		--bindir=/usr/bin \
		--with-db-inc=/usr/include/db4.8

}

src_compile() {
	default
	if use doc; then
		doxygen slapi.doxy || die "cannot run doxygen"
	fi
}

src_install () {
	emake DESTDIR="${D}" install

	# remove redhat style init script
	rm -rf "${D}"/etc/rc.d || die
	# Needs a config option to remove this.
	rm -rf "${D}"/etc/default || die

	# and install gentoo style init script
	# Get these merged upstream
	newinitd "${FILESDIR}"/389-ds.initd-r1 389-ds
	newinitd "${FILESDIR}"/389-ds-snmp.initd 389-ds-snmp

	# cope with libraries being in /usr/lib/dirsrv
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/dirsrv" > "${D}"/etc/env.d/08dirsrv

	if use doc; then
		cd "${S}" || die
		docinto html/
		dodoc -r docs/html/.
	fi
}

pkg_postinst() {
	echo
	elog "If you are planning to use 389-ds-snmp (ldap-agent),"
	elog "make sure to properly configure: /etc/dirsrv/config/ldap-agent.conf"
	elog "adding proper 'server' entries, and adding the lines below to"
	elog " => /etc/snmp/snmpd.conf"
	elog
	elog "master agentx"
	elog "agentXSocket /var/agentx/master"
	elog
	elog "To start 389 Directory Server (LDAP service) at boot:"
	elog
	elog "    rc-update add 389-ds default"
	elog
	elog "If you are upgrading from previous 1.2.6 release candidates"
	elog "please see:"
	elog "http://directory.fedoraproject.org/wiki/Subtree_Rename#warning:_upgrade_from_389_v1.2.6_.28a.3F.2C_rc1_.7E_rc6.29_to_v1.2.6_rc6_or_newer"
	echo
}
