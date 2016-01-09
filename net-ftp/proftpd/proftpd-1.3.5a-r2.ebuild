# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib systemd

MOD_CASE="0.7"
MOD_CLAMAV="0.11rc"
MOD_DISKUSE="0.9"
MOD_GSS="1.3.3"
MOD_MSG="0.4.1"
MOD_VROOT="0.9.3"

DESCRIPTION="An advanced and very configurable FTP server"
HOMEPAGE="http://www.proftpd.org/
	http://www.castaglia.org/proftpd/
	http://www.thrallingpenguin.com/resources/mod_clamav.htm
	http://gssmod.sourceforge.net/"
SRC_URI="ftp://ftp.proftpd.org/distrib/source/${P/_/}.tar.gz
	case? ( http://www.castaglia.org/${PN}/modules/${PN}-mod-case-${MOD_CASE}.tar.gz )
	clamav? ( https://secure.thrallingpenguin.com/redmine/attachments/download/1/mod_clamav-${MOD_CLAMAV}.tar.gz )
	diskuse? ( http://www.castaglia.org/${PN}/modules/${PN}-mod-diskuse-${MOD_DISKUSE}.tar.gz )
	kerberos? ( mirror://sourceforge/gssmod/mod_gss-${MOD_GSS}.tar.gz )
	msg? ( http://www.castaglia.org/${PN}/modules/${PN}-mod-msg-${MOD_MSG}.tar.gz )
	vroot? ( https://github.com/Castaglia/${PN}-mod_vroot/archive/mod_vroot-${MOD_VROOT}.tar.gz )"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="acl authfile ban +caps case clamav copy ctrls deflate diskuse doc dso dynmasq exec ifsession ifversion ident ipv6
	kerberos ldap libressl linguas_bg_BG linguas_en_US linguas_fr_FR linguas_it_IT linguas_ja_JP linguas_ko_KR
	linguas_ru_RU linguas_zh_CN linguas_zh_TW log_forensic memcache msg mysql ncurses nls pam +pcre postgres qos radius
	ratio readme rewrite selinux sftp shaper sitemisc snmp softquota sqlite ssl tcpd test trace unique_id vroot xinetd"
# TODO: geoip
REQUIRED_USE="ban? ( ctrls )
	msg? ( ctrls )
	sftp? ( ssl )
	shaper? ( ctrls )"

CDEPEND="acl? ( virtual/acl )
	caps? ( sys-libs/libcap )
	clamav? ( app-antivirus/clamav )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	memcache? ( >=dev-libs/libmemcached-0.41 )
	mysql? ( virtual/mysql )
	nls? ( virtual/libiconv )
	ncurses? ( sys-libs/ncurses:0= )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	pam? ( virtual/pam )
	pcre? ( dev-libs/libpcre )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite:3 )
	xinetd? ( virtual/inetd )"
DEPEND="${CDEPEND}
	test? ( dev-libs/check )"
RDEPEND="${CDEPEND}
	net-ftp/ftpbase
	selinux? ( sec-policy/selinux-ftp )"

S="${WORKDIR}/${P/_/}"

__prepare_module() {
	local mod_name=$1
	local mod_topdir=${WORKDIR}/${2:-${mod_name}}

	mv "${mod_topdir}/${mod_name}.c" contrib || die
	mv "${mod_topdir}/${mod_name}.html" doc/contrib || die
	rm -r "${mod_topdir}" || die
}

src_prepare() {
	epatch -p1 "${FILESDIR}"/${P}-unbound-sftp-{p1,p2}.patch

	# Skip 'install-conf' / Support LINGUAS
	sed -i -e "/install-all/s/ install-conf//" Makefile.in
	sed -i -e "s/^LANGS=.*$/LANGS=${LINGUAS}/" locale/Makefile.in

	# Prepare external modules
	use case && __prepare_module mod_case
	if use clamav ; then
		mv "${WORKDIR}"/mod_clamav-${MOD_CLAMAV}/mod_clamav.{c,h} contrib
		epatch "${WORKDIR}"/mod_clamav-${MOD_CLAMAV}/${PN}.patch
		rm -r "${WORKDIR}"/mod_clamav-${MOD_CLAMAV}
	fi
	use msg && __prepare_module mod_msg
	use vroot && __prepare_module mod_vroot ${PN}-mod_vroot-mod_vroot-${MOD_VROOT}

	# Prepare external kerberos module
	if use kerberos ; then
		cd "${WORKDIR}"/mod_gss-${MOD_GSS}

		# Support app-crypt/heimdal / Gentoo Bug #284853
		sed -i -e "s/krb5_principal2principalname/_\0/" mod_auth_gss.c.in

		# Remove obsolete DES / Gentoo Bug #324903
		# Replace 'rpm' lookups / Gentoo Bug #391021
		sed -i -e "/ac_gss_libs/s/ -ldes425//" \
			-e "s/ac_libdir=\`rpm -q -l.*$/ac_libdir=\/usr\/$(get_libdir)\//" \
			-e "s/ac_includedir=\`rpm -q -l.*$/ac_includedir=\/usr\/include\//" configure{,.in}
	fi
}

src_configure() {
	local c m

	use acl && m="${m}:mod_facl"
	use ban && m="${m}:mod_ban"
	use case && m="${m}:mod_case"
	use clamav && m="${m}:mod_clamav"
	use copy && m="${m}:mod_copy"
	use ctrls && m="${m}:mod_ctrls_admin"
	use deflate && m="${m}:mod_deflate"
	if use diskuse ; then
		cd "${WORKDIR}"/mod_diskuse
		econf
		mv mod_diskuse.{c,h} "${S}"/contrib
		mv mod_diskuse.html "${S}"/doc/contrib
		cd "${S}"
		rm -r "${WORKDIR}"/mod_diskuse
		m="${m}:mod_diskuse"
	fi
	use dynmasq && m="${m}:mod_dynmasq"
	use exec && m="${m}:mod_exec"
	use ifsession && m="${m}:mod_ifsession"
	use ifversion && m="${m}:mod_ifversion"
	if use kerberos ; then
		cd "${WORKDIR}"/mod_gss-${MOD_GSS}
		if has_version app-crypt/mit-krb5 ; then
			econf --enable-mit
		else
			econf --enable-heimdal
		fi
		mv mod_{auth_gss,gss}.c "${S}"/contrib
		mv mod_gss.h "${S}"/include
		mv README.mod_{auth_gss,gss} "${S}"
		mv mod_gss.html "${S}"/doc/contrib
		mv rfc{1509,2228}.txt "${S}"/doc/rfc
		cd "${S}"
		rm -r "${WORKDIR}"/mod_gss-${MOD_GSS}
		m="${m}:mod_gss:mod_auth_gss"
	fi
	use ldap && m="${m}:mod_ldap"
	use log_forensic && m="${m}:mod_log_forensic"
	use msg && m="${m}:mod_msg"
	if use mysql || use postgres || use sqlite ; then
		m="${m}:mod_sql:mod_sql_passwd"
		use mysql && m="${m}:mod_sql_mysql"
		use postgres && m="${m}:mod_sql_postgres"
		use sqlite && m="${m}:mod_sql_sqlite"
	fi
	use qos && m="${m}:mod_qos"
	use radius && m="${m}:mod_radius"
	use ratio && m="${m}:mod_ratio"
	use readme && m="${m}:mod_readme"
	use rewrite && m="${m}:mod_rewrite"
	if use sftp ; then
		m="${m}:mod_sftp"
		use pam && m="${m}:mod_sftp_pam"
		use mysql || use postgres || use sqlite && m="${m}:mod_sftp_sql"
	fi
	use shaper && m="${m}:mod_shaper"
	use sitemisc && m="${m}:mod_site_misc"
	use snmp && m="${m}:mod_snmp"
	if use softquota ; then
		m="${m}:mod_quotatab:mod_quotatab_file"
		use ldap && m="${m}:mod_quotatab_ldap"
		use radius && m="${m}:mod_quotatab_radius"
		use mysql || use postgres || use sqlite && m="${m}:mod_quotatab_sql"
	fi
	if use ssl ; then
		m="${m}:mod_tls:mod_tls_shmcache"
		use memcache && m="${m}:mod_tls_memcache"
	fi
	if use tcpd ; then
		m="${m}:mod_wrap2:mod_wrap2_file"
		use mysql || use postgres || use sqlite && m="${m}:mod_wrap2_sql"
	fi
	use unique_id && m="${m}:mod_unique_id"
	use vroot && m="${m}:mod_vroot"

	if [[ -n ${PROFTP_CUSTOM_MODULES} ]]; then
		einfo "Adding user-specified extra modules: '${PROFTP_CUSTOM_MODULES}'"
		m="${m}:${PROFTP_CUSTOM_MODULES}"
	fi

	[[ -z ${m} ]] || c="${c} --with-modules=${m:1}"
	econf --localstatedir=/var/run/proftpd --sysconfdir=/etc/proftpd --disable-strip \
		$(use_enable acl facl) \
		$(use_enable authfile auth-file) \
		$(use_enable caps cap) \
		$(use_enable ctrls) \
		$(use_enable dso) \
		$(use_enable ident) \
		$(use_enable ipv6) \
		$(use_enable memcache) \
		$(use_enable ncurses) \
		$(use_enable nls) \
		$(use_enable ssl openssl) \
		$(use_enable pam auth-pam) \
		$(use_enable pcre) \
		$(use_enable test tests) \
		$(use_enable trace) \
		$(use_enable userland_GNU shadow) \
		$(use_enable userland_GNU autoshadow) \
		${c:1}
}

src_test() {
	emake api-tests -C tests
}

src_install() {
	default
	[[ -z ${LINGUAS} ]] && rm -r "${ED}"/usr/share/locale
	rm -rf "${ED}"/var/run

	newinitd "${FILESDIR}"/proftpd.initd proftpd
	insinto /etc/proftpd
	doins "${FILESDIR}"/proftpd.conf.sample

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}"/proftpd.xinetd proftpd
	fi

	dodoc ChangeLog CREDITS INSTALL NEWS README* RELEASE_NOTES
	if use doc ; then
		dohtml doc/*.html doc/contrib/*.html doc/howto/*.html doc/modules/*.html
		docinto rfc
		dodoc doc/rfc/*.txt
	fi

	systemd_dounit       "${FILESDIR}"/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}-tmpfiles.d.conf ${PN}.conf
}
