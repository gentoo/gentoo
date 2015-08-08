# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WANT_AUTOMAKE="1.9"

MY_PV=${PV/_rc/.rc}
MY_PV=${MY_PV/_a/.a}

inherit eutils multilib autotools depend.apache

DESCRIPTION="389 Directory Server (admin)"
HOMEPAGE="http://port389.org/"
SRC_URI="http://directory.fedoraproject.org/sources/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug ipv6 selinux"

# TODO snmp agent init script

COMMON_DEPEND=">=app-admin/389-admin-console-1.1.0
	>=app-admin/389-ds-console-1.1.0
	app-misc/mime-types
	dev-libs/389-adminutil
	dev-libs/cyrus-sasl
	dev-libs/icu:=
	dev-libs/nss[utils]
	|| ( <=dev-libs/nspr-4.8.3-r3[ipv6?] >=dev-libs/nspr-4.8.4 )
	dev-libs/svrcore
	net-analyzer/net-snmp[ipv6?]
	net-nds/openldap
	selinux? (
		sys-apps/checkpolicy
		sys-apps/policycoreutils
	)
	>=sys-libs/db-4.2.52
	sys-libs/pam
	sys-apps/tcp-wrappers[ipv6?]
	www-apache/mod_nss
	www-servers/apache:2[apache2_modules_actions,apache2_modules_alias,apache2_modules_auth_basic,apache2_modules_authz_default,apache2_modules_cgi,apache2_modules_mime_magic,apache2_modules_rewrite,apache2_modules_setenvif,suexec,threads]"
RDEPEND="
	${COMMON_DEPEND}
	www-client/lynx
	selinux? ( sec-policy/selinux-base-policy )
"
DEPEND="sys-apps/sed ${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

need_apache2

src_prepare() {
	# as per 389 documentation, when 64bit, export USE_64
	use amd64 && export USE_64=1

	epatch "${FILESDIR}/1.1.11_rc1/0001-gentoo-apache-names.patch"
	epatch "${FILESDIR}/1.1.11_rc1/0003-find-mod_nss.m4.patch"
	epatch "${FILESDIR}/1.1.11_rc1/0004-rpath-fix.configure.ac.patch"
	# Configuration fixes
	epatch "${FILESDIR}/${PN}-cfgstuff-1.patch"

	sed -e "s!SUBDIRS!# SUBDIRS!g" -i Makefile.am || die "sed failed"
	# Setup default user/group, in this case it's dirsrv
	sed -e "s!nobody!dirsrv!g" -i configure.ac || die "sed failed"

	eautoreconf
}

src_configure() {
	# stub autoconf triplet  :(
	local myconf=""
	use debug && myconf="--enable-debug"
	use selinux &&  myconf="${myconf} --with-selinux"

	econf \
		--enable-threading \
		--disable-rpath \
		--with-adminutil=/usr \
		--with-apr-config \
		--with-apxs=${APXS} \
		--with-fhs \
		--with-httpd=${APACHE_BIN} \
		--with-openldap \
		${myconf} || die "econf failed"
}

src_install () {

	emake DESTDIR="${D}" install || die "emake failed"
	keepdir /var/log/dirsrv/admin-serv

	# remove redhat style init script.
	rm -rf "${D}"/etc/rc.d
	rm -rf "${D}"/etc/default

	# install gentoo style init script.
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	# remove redhat style wrapper scripts
	# and install gentoo scripts.
	rm -rf "${D}"/usr/sbin/*-ds-admin
	dosbin "${FILESDIR}"/*-ds-admin || die "cannot install gentoo start/stop scripts"

	# In this version build systems for modules is delete :(
	# manually install modules, not using apache-modules eclass
	# because use bindled library

	# install mod_admserv
	exeinto "${APACHE_MODULESDIR}"
	doexe "${S}/.libs"/mod_admserv.so || die "internal ebuild error: mod_admserv not found"

	insinto "${APACHE_MODULES_CONFDIR}"
	newins "${FILESDIR}/1.1.11_rc1"/48_mod_admserv.conf 48_mod_admserv \
				|| die "internal ebuild error: 48_mod_admserv.conf not found"

	# install mod_restard
	exeinto "${APACHE_MODULESDIR}"
	doexe "${S}/.libs"/mod_restartd.so || die "internal ebuild error: mod_restartd  not found"

	insinto "${APACHE_MODULES_CONFDIR}"
	newins "${FILESDIR}/1.1.11_rc1"/48_mod_restartd.conf 48_mod_restartd \
		|| die "internal ebuild error: 48_mod_restard.conf not found"

	if use selinux; then
		local POLICY_TYPES="targeted"
		cd "${S}"/selinux || die
		cp /usr/share/selinux/${POLICY_TYPES}/include/Makefile  . || die
		make || die "selinux policy compile failed"
		insinto /usr/share/selinux/${POLICY_TYPES}
		doins -r "${S}/selinux/"*.pp
	fi

}

pkg_postinst() {

	# show setup information
	elog "Once you configured www-servers/apache as written above,"
	elog "you need to run (as root): /usr/sbin/setup-ds-admin.pl"
	elog

	# show security and sysctl info
	elog "It is recommended to setup net.ipv4.tcp_keep_alive_time"
	elog "in /etc/sysctl.conf (or via sysctl -w && sysctl -p) to a reasonable"
	elog "value (in milliseconds) to avoid temporary server congestions"
	elog "from lost client connections"
	elog

	# /etc/security/limits.conf settings
	elog "It is also recommended to fine tune the maximum open files"
	elog "settings inside /etc/security/limits.conf:"
	elog "* soft nofile 2048"
	elog "* hard nofile 4096"
	elog

	elog "To start 389 Directory Server Administration Interface at boot"
	elog "please add 389-admin service to the default runlevel:"
	elog
	elog "    rc-update add 389-admin default"
	elog

	elog "for 389 Directory Server Admin interface to work, you need"
	elog "to setup a FQDN hostname and use it while running /usr/sbin/setup-ds-admin.pl"
	elog

}
