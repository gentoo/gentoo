# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic linux-info pam systemd toolchain-funcs

DESCRIPTION="A full-featured web proxy cache"
HOMEPAGE="http://www.squid-cache.org/"

# Upstream patch ID for the most recent bug-fixed update to the formal release.
r=
#r=-20181117-r0022167
if [[ -z "${r}" ]]; then
	SRC_URI="http://www.squid-cache.org/Versions/v${PV%.*}/${P}.tar.xz"
else
	SRC_URI="http://www.squid-cache.org/Versions/v${PV%.*}/${P}${r}.tar.bz2"
	S="${S}${r}"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~sparc x86"
IUSE="caps gnutls ipv6 pam ldap samba sasl kerberos nis radius ssl snmp selinux logrotate test \
	ecap esi ssl-crtd \
	mysql postgres sqlite systemd \
	perl qos tproxy \
	+htcp +wccp +wccpv2"

RESTRICT="!test? ( test )"

BDEPEND="dev-lang/perl"

COMMON_DEPEND="acct-group/squid
	acct-user/squid
	virtual/libcrypt:=
	caps? ( >=sys-libs/libcap-2.16 )
	pam? ( sys-libs/pam )
	ldap? ( net-nds/openldap:= )
	kerberos? ( virtual/krb5 )
	qos? ( net-libs/libnetfilter_conntrack )
	ssl? (
		!gnutls? (
			dev-libs/openssl:0=
		)
		dev-libs/nettle:=
	)
	sasl? ( dev-libs/cyrus-sasl )
	systemd? ( sys-apps/systemd:= )
	ecap? ( net-libs/libecap:1 )
	esi? ( dev-libs/expat dev-libs/libxml2 )
	gnutls? ( >=net-libs/gnutls-3.1.5:= )
	logrotate? ( app-admin/logrotate )
	>=sys-libs/db-4:*
	dev-libs/libltdl:0"

DEPEND="${COMMON_DEPEND}
	${BDEPEND}
	ecap? ( virtual/pkgconfig )
	test? ( dev-util/cppunit )"

RDEPEND="${COMMON_DEPEND}
	samba? ( net-fs/samba )
	perl? ( dev-lang/perl )
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	selinux? ( sec-policy/selinux-squid )
	sqlite? ( dev-perl/DBD-SQLite )"

REQUIRED_USE="tproxy? ( caps )
		qos? ( caps )"

pkg_pretend() {
	if use tproxy; then
		local CONFIG_CHECK="~NF_CONNTRACK ~NETFILTER_XT_MATCH_SOCKET ~NETFILTER_XT_TARGET_TPROXY"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-4.3-gentoo.patch"
	eapply "${FILESDIR}/${PN}-4.17-use-system-libltdl.patch"
	eapply "${FILESDIR}/${PN}-4.17-fix-libxml2-2.10.0.patch"

	sed -i -e 's:/usr/local/squid/etc:/etc/squid:' \
		INSTALL QUICKSTART \
		scripts/fileno-to-pathname.pl \
		scripts/check_cache.pl \
		tools/cachemgr.cgi.8 \
		tools/purge/conffile.hh \
		tools/purge/purge.1  || die
	sed -i -e 's:/usr/local/squid/sbin:/usr/sbin:' \
		INSTALL QUICKSTART || die
	sed -i -e 's:/usr/local/squid/var/cache:/var/cache/squid:' \
		QUICKSTART || die
	sed -i -e 's:/usr/local/squid/var/logs:/var/log/squid:' \
		QUICKSTART \
		src/log/access_log.cc || die
	sed -i -e 's:/usr/local/squid/logs:/var/log/squid:' \
		src/log/access_log.cc || die
	sed -i -e 's:/usr/local/squid/libexec:/usr/libexec/squid:' \
		src/acl/external/unix_group/ext_unix_group_acl.8 \
		src/acl/external/session/ext_session_acl.8 || die
	sed -i -e 's:/usr/local/squid/cache:/var/cache/squid:' \
		scripts/check_cache.pl || die
	# /var/run/squid to /run/squid
	sed -i -e 's:$(localstatedir)::' \
		src/ipc/Makefile.am || die
	sed -i -e 's:_LTDL_SETUP:LTDL_INIT([installable]):' \
		libltdl/configure.ac || die

	sed -i 's:/var/run/:/run/:g' tools/systemd/squid.service || die

	eapply_user
	eautoreconf
}

src_configure() {
	local basic_modules="NCSA,POP3,getpwnam"
	use samba && basic_modules+=",SMB"
	use ldap && basic_modules+=",SMB_LM,LDAP"
	use pam && basic_modules+=",PAM"
	use sasl && basic_modules+=",SASL"
	use nis && basic_modules+=",NIS"
	use radius && basic_modules+=",RADIUS"
	if use mysql || use postgres || use sqlite ; then
		basic_modules+=",DB"
	fi

	local digest_modules="file"
	use ldap && digest_modules+=",LDAP,eDirectory"

	local negotiate_modules="none"
	local myconf="--without-mit-krb5 --without-heimdal-krb5"
	if use kerberos ; then
		negotiate_modules="kerberos,wrapper"
		if has_version app-crypt/heimdal ; then
			myconf="--without-mit-krb5 --with-heimdal-krb5"
		else
			myconf="--with-mit-krb5 --without-heimdal-krb5"
		fi
	fi

	local ntlm_modules="none"
	use samba && ntlm_modules="SMB_LM"

	local ext_helpers="file_userip,session,unix_group,delayer,time_quota"
	use samba && ext_helpers+=",wbinfo_group"
	use ldap && ext_helpers+=",LDAP_group,eDirectory_userip"
	use ldap && use kerberos && ext_helpers+=",kerberos_ldap_group"
	if use mysql || use postgres || use sqlite ; then
	    ext_helpers+=",SQL_session"
	fi

	local storeio_modules="aufs,diskd,rock,ufs"

	local transparent
	if use kernel_linux ; then
		transparent+=" --enable-linux-netfilter"
		use qos && transparent+=" --enable-zph-qos --with-netfilter-conntrack"
	fi

	tc-export_build_env BUILD_CXX
	export BUILDCXX=${BUILD_CXX}
	export BUILDCXXFLAGS=${BUILD_CXXFLAGS}
	tc-export CC AR

	# Should be able to drop this workaround with newer versions.
	# https://bugs.squid-cache.org/show_bug.cgi?id=4224
	tc-is-cross-compiler && export squid_cv_gnu_atomics=no

	# Bug #719662
	(use ppc || use arm || use hppa) && append-libs -latomic

	econf \
		--sysconfdir=/etc/squid \
		--libexecdir=/usr/libexec/squid \
		--localstatedir=/var \
		--with-pidfile=/run/squid.pid \
		--datadir=/usr/share/squid \
		--with-logdir=/var/log/squid \
		--with-default-user=squid \
		--enable-removal-policies="lru,heap" \
		--enable-storeio="${storeio_modules}" \
		--enable-disk-io \
		--enable-auth-basic="${basic_modules}" \
		--enable-auth-digest="${digest_modules}" \
		--enable-auth-ntlm="${ntlm_modules}" \
		--enable-auth-negotiate="${negotiate_modules}" \
		--enable-external-acl-helpers="${ext_helpers}" \
		--enable-log-daemon-helpers \
		--enable-url-rewrite-helpers \
		--enable-cache-digests \
		--enable-delay-pools \
		--enable-eui \
		--enable-icmp \
		--enable-follow-x-forwarded-for \
		--with-large-files \
		--with-build-environment=default \
		--disable-strict-error-checking \
		--disable-arch-native \
		--without-included-ltdl \
		--with-ltdl-include="${ESYSROOT}"/usr/include \
		--with-ltdl-lib="${ESYSROOT}"/usr/$(get_libdir) \
		$(use_with caps libcap) \
		$(use_enable ipv6) \
		$(use_enable snmp) \
		$(use_with ssl openssl) \
		$(use_with ssl nettle) \
		$(use_with gnutls) \
		$(use_enable ssl-crtd) \
		$(use_with systemd) \
		$(use_enable ecap) \
		$(use_enable esi) \
		$(use_enable htcp) \
		$(use_enable wccp) \
		$(use_enable wccpv2) \
		${transparent} \
		${myconf}
}

src_install() {
	default

	systemd_dounit "tools/systemd/squid.service"

	# need suid root for looking into /etc/shadow
	fowners root:squid /usr/libexec/squid/basic_ncsa_auth
	fperms 4750 /usr/libexec/squid/basic_ncsa_auth
	if use pam; then
		fowners root:squid /usr/libexec/squid/basic_pam_auth
		fperms 4750 /usr/libexec/squid/basic_pam_auth
	fi
	# pinger needs suid as well
	fowners root:squid /usr/libexec/squid/pinger
	fperms 4750 /usr/libexec/squid/pinger

	# these scripts depend on perl
	if ! use perl; then
		for f in basic_pop3_auth \
			ext_delayer_acl \
			helper-mux \
			log_db_daemon \
			security_fake_certverify \
			storeid_file_rewrite \
			url_lfs_rewrite; do
				rm "${D}"/usr/libexec/squid/${f} || die
		done
	fi

	# cleanup
	rm -r "${D}"/run "${D}"/var/cache || die

	dodoc CONTRIBUTORS CREDITS ChangeLog INSTALL QUICKSTART README SPONSORS doc/*.txt
	newdoc src/auth/negotiate/kerberos/README README.kerberos
	newdoc src/auth/basic/RADIUS/README README.RADIUS
	newdoc src/acl/external/kerberos_ldap_group/README README.kerberos_ldap_group
	dodoc RELEASENOTES.html

	if use pam; then
		newpamd "${FILESDIR}/squid.pam" squid
	fi

	newconfd "${FILESDIR}/squid.confd-r2" squid
	newinitd "${FILESDIR}/squid.initd-r5" squid
	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/squid.logrotate" squid
	else
		exeinto /etc/cron.weekly
		newexe "${FILESDIR}/squid.cron" squid.cron
	fi

	diropts -m0750 -o squid -g squid
	keepdir /var/log/squid /etc/ssl/squid /var/lib/squid
}

pkg_postinst() {
	elog "A good starting point to debug Squid issues is to use 'squidclient mgr:' commands such as 'squidclient mgr:info'."
	if [[ ${#r} -gt 0 ]]; then
		elog "You are using a release with the official ${r} patch! Make sure you mention that, or send the output of 'squidclient mgr:info' when asking for support."
	fi
}
