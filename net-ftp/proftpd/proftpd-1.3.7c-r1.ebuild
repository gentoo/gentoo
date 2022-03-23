# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib systemd tmpfiles toolchain-funcs

MOD_CASE="0.7"
MOD_CLAMAV="0.14rc2"
MOD_DISKUSE="0.9"
MOD_GSS="1.3.9"
MOD_MSG="0.4.1"
MOD_VROOT="0.9.4"

DESCRIPTION="An advanced and very configurable FTP server"
HOMEPAGE="http://www.proftpd.org/
	http://www.castaglia.org/proftpd/
	https://github.com/jbenden/mod_clamav
	http://gssmod.sourceforge.net/"
SRC_URI="ftp://ftp.proftpd.org/distrib/source/${P/_/}.tar.gz
	case? ( http://www.castaglia.org/${PN}/modules/${PN}-mod-case-${MOD_CASE}.tar.gz )
	clamav? ( https://github.com/jbenden/mod_clamav/archive/v${MOD_CLAMAV}.tar.gz -> ${PN}-mod_clamav-${MOD_CLAMAV}.tar.gz )
	diskuse? ( http://www.castaglia.org/${PN}/modules/${PN}-mod-diskuse-${MOD_DISKUSE}.tar.gz )
	kerberos? ( mirror://sourceforge/gssmod/mod_gss-${MOD_GSS}.tar.gz )
	msg? ( http://www.castaglia.org/${PN}/modules/${PN}-mod-msg-${MOD_MSG}.tar.gz )
	vroot? ( https://github.com/Castaglia/${PN}-mod_vroot/archive/v${MOD_VROOT}.tar.gz -> mod_vroot-${MOD_VROOT}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="acl authfile ban +caps case clamav copy ctrls deflate diskuse dso dynmasq exec ifsession ifversion ident ipv6
	kerberos ldap log-forensic memcache msg mysql ncurses nls pam +pcre postgres qos radius
	ratio readme rewrite selinux sftp shaper sitemisc snmp sodium softquota sqlite ssl tcpd test unique-id vroot"
# TODO: geoip
REQUIRED_USE="ban? ( ctrls )
	msg? ( ctrls )
	sftp? ( ssl )
	shaper? ( ctrls )

	mysql? ( ssl )
	postgres? ( ssl )
	sqlite? ( ssl )
"

CDEPEND="virtual/libcrypt:=
	acl? ( virtual/acl )
	caps? ( sys-libs/libcap )
	clamav? ( app-antivirus/clamav )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:= )
	memcache? ( >=dev-libs/libmemcached-0.41 )
	mysql? ( dev-db/mysql-connector-c:0= )
	nls? ( virtual/libiconv )
	ncurses? ( sys-libs/ncurses:0= )
	ssl? ( dev-libs/openssl:0= )
	pam? ( sys-libs/pam )
	pcre? ( dev-libs/libpcre )
	postgres? ( dev-db/postgresql:= )
	sodium? ( dev-libs/libsodium:0= )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${CDEPEND}
	test? ( dev-libs/check )"
RDEPEND="${CDEPEND}
	net-ftp/ftpbase
	selinux? ( sec-policy/selinux-ftp )"

S="${WORKDIR}/${P/_/}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.6-use-trace.patch
	"${FILESDIR}"/${PN}-1.3.7a-slibtool.patch
)

RESTRICT=test # Some tests are ran in chroot. Confuse sandbox.

in_dir() {
	pushd "${WORKDIR}/${1}" || die
	shift
	"$@"
	popd
}

src_prepare() {
	# Skip 'install-conf' / Support LINGUAS
	sed -i -e "/install-all/s/ install-conf//" Makefile.in || die
	sed -i -e "s/^LANGS=.*$/LANGS=${LINGUAS}/" locale/Makefile.in || die

	# Prepare external modules
	if use case; then
		cp -v "${WORKDIR}"/mod_case/mod_case.c contrib || die
		cp -v "${WORKDIR}"/mod_case/mod_case.html doc/contrib || die
	fi

	if use clamav ; then
		cp -v "${WORKDIR}"/mod_clamav-${MOD_CLAMAV}/mod_clamav.{c,h} contrib || die
		eapply -p0 "${WORKDIR}"/mod_clamav-${MOD_CLAMAV}/001-add-mod_clamav-to-tests.patch
	fi

	if use diskuse; then
		in_dir mod_diskuse eapply "${FILESDIR}"/${PN}-1.3.6_rc4-diskuse-refresh-api.patch

		# ./configure will modify files. Symlink them instead of copying
		ln -sv "${WORKDIR}"/mod_diskuse/mod_diskuse.h "${S}"/contrib || die

		cp -v "${WORKDIR}"/mod_diskuse/mod_diskuse.c "${S}"/contrib || die
		cp -v "${WORKDIR}"/mod_diskuse/mod_diskuse.html "${S}"/doc/contrib || die
	fi

	if use msg; then
		in_dir mod_msg eapply "${FILESDIR}"/${PN}-1.3.6_rc4-msg-refresh-api.patch

		cp -v "${WORKDIR}"/mod_msg/mod_msg.c contrib || die
		cp -v "${WORKDIR}"/mod_msg/mod_msg.html doc/contrib || die
	fi

	if use vroot; then
		in_dir ${PN}-mod_vroot-${MOD_VROOT} eapply "${FILESDIR}"/${PN}-1.3.6_rc4-vroot-refresh-api.patch

		cp -v "${WORKDIR}"/${PN}-mod_vroot-${MOD_VROOT}/mod_vroot.c contrib || die
		cp -v "${WORKDIR}"/${PN}-mod_vroot-${MOD_VROOT}/mod_vroot.html doc/contrib || die
	fi

	if use kerberos ; then
		# in_dir mod_gss-${MOD_GSS} eapply "${FILESDIR}"/${PN}-1.3.6_rc4-gss-refresh-api.patch

		# Support app-crypt/heimdal / Gentoo Bug #284853
		sed -i -e "s/krb5_principal2principalname/_\0/" "${WORKDIR}"/mod_gss-${MOD_GSS}/mod_auth_gss.c.in || die

		# Remove obsolete DES / Gentoo Bug #324903
		# Replace 'rpm' lookups / Gentoo Bug #391021
		sed -i -e "/ac_gss_libs/s/ -ldes425//" \
			-e "s/ac_libdir=\`rpm -q -l.*$/ac_libdir=\/usr\/$(get_libdir)\//" \
			-e "s/ac_includedir=\`rpm -q -l.*$/ac_includedir=\/usr\/include\//" "${WORKDIR}"/mod_gss-${MOD_GSS}/configure{,.ac}  || die

		# ./configure will modify files. Symlink them instead of copying
		ln -sv "${WORKDIR}"/mod_gss-${MOD_GSS}/mod_auth_gss.c "${S}"/contrib || die
		ln -sv "${WORKDIR}"/mod_gss-${MOD_GSS}/mod_gss.c "${S}"/contrib || die
		ln -sv "${WORKDIR}"/mod_gss-${MOD_GSS}/mod_gss.h "${S}"/include || die

		cp -v "${WORKDIR}"/mod_gss-${MOD_GSS}/README.mod_{auth_gss,gss} "${S}" || die
		cp -v "${WORKDIR}"/mod_gss-${MOD_GSS}/mod_gss.html "${S}"/doc/contrib || die
		cp -v "${WORKDIR}"/mod_gss-${MOD_GSS}/rfc{1509,2228}.txt "${S}"/doc/rfc || die
	fi

	default

	tc-export CC
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
		in_dir mod_diskuse econf
		m="${m}:mod_diskuse"
	fi
	use dynmasq && m="${m}:mod_dynmasq"
	use exec && m="${m}:mod_exec"
	use ifsession && m="${m}:mod_ifsession"
	use ifversion && m="${m}:mod_ifversion"
	if use kerberos ; then
		in_dir mod_gss-${MOD_GSS} econf
		m="${m}:mod_gss:mod_auth_gss"
	fi
	use ldap && m="${m}:mod_ldap"
	use log-forensic && m="${m}:mod_log_forensic"
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
	use unique-id && m="${m}:mod_unique_id"
	use vroot && m="${m}:mod_vroot"

	if [[ -n ${PROFTP_CUSTOM_MODULES} ]]; then
		einfo "Adding user-specified extra modules: '${PROFTP_CUSTOM_MODULES}'"
		m="${m}:${PROFTP_CUSTOM_MODULES}"
	fi

	[[ -z ${m} ]] || c="${c} --with-modules=${m:1}"

	econf --localstatedir=/run/proftpd --sysconfdir=/etc/proftpd --disable-strip \
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
		$(use_enable sodium) \
		$(use_enable test tests) \
		--enable-trace \
		--enable-shadow \
		--enable-autoshadow \
		${c:1}
}

src_test() {
	emake api-tests -C tests
}

src_install() {
	default
	[[ -z ${LINGUAS-set} ]] && rm -r "${ED}"/usr/share/locale
	rm -rf "${ED}"/run "${ED}"/var/run

	newinitd "${FILESDIR}"/proftpd.initd-r1 proftpd
	insinto /etc/proftpd
	doins "${FILESDIR}"/proftpd.conf.sample

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/proftpd.xinetd proftpd

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	dodoc ChangeLog CREDITS INSTALL NEWS README* RELEASE_NOTES

	docinto html
	dodoc doc/*.html doc/contrib/*.html doc/howto/*.html doc/modules/*.html

	docinto rfc
	dodoc doc/rfc/*.txt

	systemd_dounit       "${FILESDIR}"/${PN}.service
	newtmpfiles "${FILESDIR}"/${PN}-tmpfiles.d.conf-r1 ${PN}.conf
}

pkg_postinst() {
	# Create /var/run files at package merge time: bug #650000
	tmpfiles_process ${PN}.conf
}
