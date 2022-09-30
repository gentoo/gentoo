# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools flag-o-matic linux-info pam systemd toolchain-funcs

DESCRIPTION="A full-featured web proxy cache"
HOMEPAGE="http://www.squid-cache.org/"

MY_PV_MAJOR=$(ver_cut 1)
# Upstream patch ID for the most recent bug-fixed update to the formal release.
#r=-20181117-r0022167
r=
if [[ -z ${r} ]]; then
	SRC_URI="http://www.squid-cache.org/Versions/v${MY_PV_MAJOR}/${P}.tar.xz"
else
	SRC_URI="http://www.squid-cache.org/Versions/v${MY_PV_MAJOR}/${P}${r}.tar.bz2"
	S="${S}${r}"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="caps gnutls pam ldap samba sasl kerberos nis radius ssl snmp selinux logrotate test ecap"
IUSE+=" esi ssl-crtd mysql postgres sqlite systemd perl qos tproxy +htcp +wccp +wccpv2"
RESTRICT="!test? ( test )"
REQUIRED_USE="tproxy? ( caps ) qos? ( caps )"

DEPEND="
	acct-group/squid
	acct-user/squid
	dev-libs/libltdl
	sys-libs/tdb
	virtual/libcrypt:=
	caps? ( >=sys-libs/libcap-2.16 )
	ecap? ( net-libs/libecap:1 )
	esi? (
		dev-libs/expat
		dev-libs/libxml2
	)
	ldap? ( net-nds/openldap:= )
	gnutls? ( >=net-libs/gnutls-3.1.5:= )
	logrotate? ( app-admin/logrotate )
	nis? (
		net-libs/libtirpc:=
		net-libs/libnsl:=
	)
	kerberos? ( virtual/krb5 )
	pam? ( sys-libs/pam )
	qos? ( net-libs/libnetfilter_conntrack )
	ssl? (
		dev-libs/nettle:=
		!gnutls? (
			dev-libs/openssl:=
		)
	)
	sasl? ( dev-libs/cyrus-sasl )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="
	!!<net-proxy/squid-5
	${DEPEND}
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	perl? ( dev-lang/perl )
	samba? ( net-fs/samba )
	selinux? ( sec-policy/selinux-squid )
	sqlite? ( dev-perl/DBD-SQLite )
"
BDEPEND="
	dev-lang/perl
	ecap? ( virtual/pkgconfig )
	test? ( dev-util/cppunit )
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.3-gentoo.patch
	"${FILESDIR}"/${PN}-4.17-use-system-libltdl.patch
)

pkg_pretend() {
	if use tproxy; then
		local CONFIG_CHECK="~NF_CONNTRACK ~NETFILTER_XT_MATCH_SOCKET ~NETFILTER_XT_TARGET_TPROXY"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	default

	# Fixup various paths
	sed -i -e 's:/usr/local/squid/etc:/etc/squid:' \
		INSTALL QUICKSTART \
		scripts/fileno-to-pathname.pl \
		scripts/check_cache.pl \
		tools/cachemgr.cgi.8 \
		tools/purge/conffile.hh \
		tools/purge/purge.1 || die
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
	sed -i 's:/var/run/:/run/:g' tools/systemd/squid.service || die

	sed -i -e 's:_LTDL_SETUP:LTDL_INIT([installable]):' \
		libltdl/configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--datadir=/usr/share/squid
		--libexecdir=/usr/libexec/squid
		--localstatedir=/var
		--sysconfdir=/etc/squid
		--with-default-user=squid
		--with-logdir=/var/log/squid
		--with-pidfile=/run/squid.pid

		--enable-build-info="Gentoo ${PF} (r: ${r:-NONE})"
		--enable-log-daemon-helpers
		--enable-url-rewrite-helpers
		--enable-cache-digests
		--enable-delay-pools
		--enable-disk-io
		--enable-eui
		--enable-icmp
		--enable-ipv6
		--enable-follow-x-forwarded-for
		--enable-removal-policies="lru,heap"
		--disable-strict-error-checking
		--disable-arch-native

		--with-large-files
		--with-build-environment=default

		--with-tdb

		--without-included-ltdl
		--with-ltdl-include="${ESYSROOT}"/usr/include
		--with-ltdl-lib="${ESYSROOT}"/usr/$(get_libdir)

		$(use_with caps libcap)
		$(use_enable snmp)
		$(use_with ssl openssl)
		$(use_with ssl nettle)
		$(use_with gnutls)
		$(use_enable ssl-crtd)
		$(use_with systemd)
		$(use_with test cppunit)
		$(use_enable ecap)
		$(use_enable esi)
		$(use_enable esi expat)
		$(use_enable esi libxml2)
		$(use_enable htcp)
		$(use_enable wccp)
		$(use_enable wccpv2)
	)

	# Basic modules
	local basic_modules=(
		NCSA
		POP3
		getpwnam

		$(usev samba 'SMB')
		$(usev ldap 'SMB_LM LDAP')
		$(usev pam 'PAM')
		$(usev sasl 'SASL')
		$(usev nis 'NIS')
		$(usev radius 'RADIUS')
	)

	use nis && append-cppflags "-I${ESYSROOT}/usr/include/tirpc"

	if use mysql || use postgres || use sqlite; then
		basic_modules+=( DB )
	fi

	# Digests
	local digest_modules=(
		file

		$(usev ldap 'LDAP eDirectory')
	)

	# Kerberos
	local negotiate_modules=( none )

	myeconfargs+=( --without-mit-krb5 --without-heimdal-krb5 )

	if use kerberos; then
		# We intentionally overwrite negotiate_modules here to lose
		# the 'none'.
		negotiate_modules=( kerberos wrapper )

		if has_version app-crypt/heimdal; then
			myeconfargs+=(
				--without-mit-krb5
				--with-heimdal-krb5
			)
		else
			myeconfargs+=(
				--with-mit-krb5
				--without-heimdal-krb5
			)
		fi
	fi

	# NTLM modules
	local ntlm_modules=( none )

	if use samba ; then
		# We intentionally overwrite ntlm_modules here to lose
		# the 'none'.
		ntlm_modules=( SMB_LM )
	fi

	# External helpers
	local ext_helpers=(
		file_userip
		session
		unix_group
		delayer
		time_quota

		$(usev samba 'wbinfo_group')
		$(usev ldap 'LDAP_group eDirectory_userip')
	)

	use ldap && use kerberos && ext_helpers+=( kerberos_ldap_group )
	if use mysql || use postgres || use sqlite; then
		ext_helpers+=( SQL_session )
	fi

	# Storage modules
	local storeio_modules=(
		aufs
		diskd
		rock
		ufs
	)

	#
	local transparent
	if use kernel_linux; then
		myeconfargs+=(
			--enable-linux-netfilter
			$(usev qos '--enable-zph-qos --with-netfilter-conntrack')
		)
	fi

	tc-export_build_env BUILD_CXX
	export BUILDCXX="${BUILD_CXX}"
	export BUILDCXXFLAGS="${BUILD_CXXFLAGS}"
	tc-export CC AR

	# Should be able to drop this workaround with newer versions.
	# https://bugs.squid-cache.org/show_bug.cgi?id=4224
	tc-is-cross-compiler && export squid_cv_gnu_atomics=no

	# Bug #719662
	append-atomic-flags

	print_options_without_comma() {
		# IFS as ',' will cut off any trailing commas
		(
			IFS=','
			options=( $(printf "%s," "${@}") )
			echo "${options[*]}"
		)
	}

	myeconfargs+=(
		--enable-storeio=$(print_options_without_comma "${storeio_modules[@]}")
		--enable-auth-basic=$(print_options_without_comma "${basic_modules[@]}")
		--enable-auth-digest=$(print_options_without_comma "${digest_modules[@]}")
		--enable-auth-ntlm=$(print_options_without_comma "${ntlm_modules[@]}")
		--enable-auth-negotiate=$(print_options_without_comma "${negotiate_modules[@]}")
		--enable-external-acl-helpers=$(print_options_without_comma "${ext_helpers[@]}")
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	systemd_dounit tools/systemd/squid.service

	# Need suid root for looking into /etc/shadow
	fowners root:squid /usr/libexec/squid/basic_ncsa_auth
	fperms 4750 /usr/libexec/squid/basic_ncsa_auth

	if use pam; then
		fowners root:squid /usr/libexec/squid/basic_pam_auth
		fperms 4750 /usr/libexec/squid/basic_pam_auth
	fi

	# Pinger needs suid as well
	fowners root:squid /usr/libexec/squid/pinger
	fperms 4750 /usr/libexec/squid/pinger

	# These scripts depend on perl
	if ! use perl; then
		local perl_scripts=(
			basic_pop3_auth ext_delayer_acl helper-mux
			log_db_daemon security_fake_certverify
			storeid_file_rewrite url_lfs_rewrite
		)

		local script
		for script in "${perl_scripts[@]}"; do
			rm "${ED}"/usr/libexec/squid/${script} || die
		done
	fi

	# Cleanup
	rm -r "${D}"/run "${D}"/var/cache || die

	dodoc CONTRIBUTORS CREDITS ChangeLog INSTALL QUICKSTART README SPONSORS doc/*.txt
	newdoc src/auth/negotiate/kerberos/README README.kerberos
	newdoc src/auth/basic/RADIUS/README README.RADIUS
	newdoc src/acl/external/kerberos_ldap_group/README README.kerberos_ldap_group
	dodoc RELEASENOTES.html

	if use pam; then
		newpamd "${FILESDIR}"/squid.pam squid
	fi

	newconfd "${FILESDIR}"/squid.confd-r2 squid
	newinitd "${FILESDIR}"/squid.initd-r5 squid

	if use logrotate ; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/squid.logrotate squid
	else
		exeinto /etc/cron.weekly
		newexe "${FILESDIR}"/squid.cron squid.cron
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
