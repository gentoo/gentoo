# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/exim/exim-4.85.ebuild,v 1.6 2015/06/11 14:27:10 ago Exp $

EAPI="5"

inherit eutils toolchain-funcs multilib pam systemd

IUSE="dcc +dkim dlfunc dmarc +dnsdb doc dovecot-sasl dsn exiscan-acl gnutls ipv6 ldap lmtp maildir mbx mysql nis pam perl pkcs11 postgres +prdr proxy radius redis sasl selinux spf sqlite srs ssl syslog tcpd tpda X"
REQUIRED_USE="spf? ( exiscan-acl ) srs? ( exiscan-acl ) dmarc? ( spf dkim ) pkcs11? ( gnutls )"

COMM_URI="ftp://ftp.exim.org/pub/exim/exim4$([[ ${PV} == *_rc* ]] && echo /test)"

DESCRIPTION="A highly configurable, drop-in replacement for sendmail"
SRC_URI="${COMM_URI}/${P//rc/RC}.tar.bz2
	mirror://gentoo/system_filter.exim.gz
	doc? ( ${COMM_URI}/${PN}-html-${PV//rc/RC}.tar.bz2 )"
HOMEPAGE="http://www.exim.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 ~sparc x86 ~x86-fbsd ~x86-solaris"

COMMON_DEPEND=">=sys-apps/sed-4.0.5
	>=sys-libs/db-3.2
	dev-libs/libpcre
	perl? ( dev-lang/perl:= )
	pam? ( virtual/pam )
	tcpd? ( sys-apps/tcp-wrappers )
	ssl? ( dev-libs/openssl )
	gnutls? ( net-libs/gnutls[pkcs11?]
			  dev-libs/libtasn1 )
	ldap? ( >=net-nds/openldap-2.0.7 )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	sasl? ( >=dev-libs/cyrus-sasl-2.1.26-r2 )
	redis? ( dev-libs/hiredis )
	spf? ( >=mail-filter/libspf2-1.2.5-r1 )
	dmarc? ( mail-filter/opendmarc )
	srs? ( mail-filter/libsrs_alt )
	X? ( x11-proto/xproto
		x11-libs/libX11
		x11-libs/libXmu
		x11-libs/libXt
		x11-libs/libXaw
	)
	sqlite? ( dev-db/sqlite )
	radius? ( net-dialup/radiusclient )
	virtual/libiconv
	"
	# added X check for #57206
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/mini-qmail
	!<mail-mta/msmtp-1.4.19-r1
	!>=mail-mta/msmtp-1.4.19-r1[mta]
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/sendmail
	!mail-mta/opensmtpd
	!<mail-mta/ssmtp-2.64-r2
	!>=mail-mta/ssmtp-2.64-r2[mta]
	!net-mail/mailwrapper
	>=net-mail/mailbase-0.00-r5
	virtual/logger
	dcc? ( mail-filter/dcc )
	selinux? ( sec-policy/selinux-exim )
	"

S=${WORKDIR}/${P//rc/RC}

src_prepare() {
	epatch "${FILESDIR}"/exim-4.14-tail.patch
	epatch "${FILESDIR}"/exim-4.74-localscan_dlopen.patch
	epatch "${FILESDIR}"/exim-4.69-r1.27021.patch
	epatch "${FILESDIR}"/exim-4.74-radius-db-ENV-clash.patch # 287426
	epatch "${FILESDIR}"/exim-4.82-makefile-freebsd.patch # 235785
	epatch "${FILESDIR}"/exim-4.77-as-needed-ldflags.patch # 352265, 391279
	epatch "${FILESDIR}"/exim-4.76-crosscompile.patch # 266591

	if use maildir ; then
		epatch "${FILESDIR}"/exim-4.20-maildir.patch
	else
		epatch "${FILESDIR}"/exim-4.80-spool-mail-group.patch # 438606
	fi

	# user Exim believes it should be
	MAILUSER=mail
	MAILGROUP=mail
	if use prefix && [[ ${EUID} != 0 ]] ; then
		MAILUSER=$(id -un)
		MAILGROUP=$(id -gn)
	fi
}

src_configure() {
	# general config and paths

	sed -i.orig \
		-e "/SYSTEM_ALIASES_FILE/s'SYSTEM_ALIASES_FILE'${EPREFIX}/etc/mail/aliases'" \
		"${S}"/src/configure.default || die

	sed -i -e 's/^buildname=.*/buildname=exim-gentoo/g' Makefile || die

	sed -e "48i\CFLAGS=${CFLAGS}" \
		-e "s:BIN_DIRECTORY=/usr/exim/bin:BIN_DIRECTORY=${EPREFIX}/usr/sbin:" \
		-e "s:EXIM_USER=:EXIM_USER=${MAILUSER}:" \
		-e "s:CONFIGURE_FILE=/usr/exim/configure:CONFIGURE_FILE=${EPREFIX}/etc/exim/exim.conf:" \
		-e "s:ZCAT_COMMAND=.*$:ZCAT_COMMAND=${EPREFIX}/bin/zcat:" \
		-e "s:COMPRESS_COMMAND=.*$:COMPRESS_COMMAND=${EPREFIX}/bin/gzip:" \
		src/EDITME > Local/Makefile

	cd Local

	cat >> Makefile <<- EOC
		INFO_DIRECTORY=${EPREFIX}/usr/share/info
		PID_FILE_PATH=${EPREFIX}/run/exim.pid
		SPOOL_DIRECTORY=${EPREFIX}/var/spool/exim
		HAVE_ICONV=yes
	EOC

	# if we use libiconv, now is the time to tell so
	use !elibc_glibc && echo "EXTRALIBS_EXIM=-liconv" >> Makefile

	# support for IPv6
	if use ipv6; then
		cat >> Makefile <<- EOC
			HAVE_IPV6=YES
		EOC
	fi

	#
	# mail storage formats

	# mailstore is Exim's traditional storage format
	cat >> Makefile <<- EOC
		SUPPORT_MAILSTORE=yes
	EOC

	# mbox
	if use mbx; then
		cat >> Makefile <<- EOC
			SUPPORT_MBX=yes
		EOC
	fi

	# maildir
	if use maildir; then
		cat >> Makefile <<- EOC
			SUPPORT_MAILDIR=yes
		EOC
	fi

	#
	# lookup methods

	# use the "native" interfaces to the DBM and CDB libraries, support
	# passwd and directory lookups by default
	cat >> Makefile <<- EOC
		USE_DB=yes
		DBMLIB=-ldb
		LOOKUP_CDB=yes
		LOOKUP_PASSWD=yes
		LOOKUP_DSEARCH=yes
	EOC

	if ! use dnsdb; then
		# DNSDB lookup is enabled by default
		sed -i "s:^LOOKUP_DNSDB=yes:# LOOKUP_DNSDB=yes:" Makefile
	fi

	if use ldap; then
		cat >> Makefile <<- EOC
			LOOKUP_LDAP=yes
			LDAP_LIB_TYPE=OPENLDAP2
			LOOKUP_INCLUDE += -I"${EROOT}"usr/include/ldap
			LOOKUP_LIBS += -lldap -llber
		EOC
	fi

	if use mysql; then
		cat >> Makefile <<- EOC
			LOOKUP_MYSQL=yes
			LOOKUP_INCLUDE += $(mysql_config --include)
			LOOKUP_LIBS += $(mysql_config --libs)
		EOC
	fi

	if use nis; then
		cat >> Makefile <<- EOC
			LOOKUP_NIS=yes
			LOOKUP_NISPLUS=yes
		EOC
	fi

	if use postgres; then
		cat >> Makefile <<- EOC
			LOOKUP_PGSQL=yes
			LOOKUP_INCLUDE += -I$(pg_config --includedir)
			LOOKUP_LIBS += -L$(pg_config --libdir) -lpq
		EOC
	fi

	if use sqlite; then
		cat >> Makefile <<- EOC
			LOOKUP_SQLITE=yes
			LOOKUP_SQLITE_PC=sqlite3
		EOC
	fi

	if use redis; then
		cat >> Makefile <<- EOC
			EXPERIMENTAL_REDIS=yes
			LOOKUP_LIBS += -lhiredis
		EOC
	fi

	#
	# Exim monitor, enabled by default, controlled via X USE-flag,
	# disable if not requested, bug #46778
	if use X; then
		cp ../exim_monitor/EDITME eximon.conf || die
	else
		sed -i -e '/^EXIM_MONITOR=/s/^/# /' Makefile
	fi

	#
	# features

	# content scanning support
	if use exiscan-acl; then
		cat >> Makefile <<- EOC
			WITH_CONTENT_SCAN=yes
			WITH_OLD_DEMIME=yes
		EOC
	fi

	# DomainKeys Identified Mail, RFC4871
	if ! use dkim; then
		# DKIM is enabled by default
		cat >> Makefile <<- EOC
			DISABLE_DKIM=yes
		EOC
	fi

	# Per-Recipient-Data-Response
	if ! use prdr; then
		# PRDR is enabled by default
		cat >> Makefile <<- EOC
			DISABLE_PRDR=yes
		EOC
	fi

	# log to syslog
	if use syslog; then
		sed -i "s:LOG_FILE_PATH=/var/log/exim/exim_%s.log:LOG_FILE_PATH=syslog:" Makefile
		cat >> Makefile <<- EOC
			LOG_FILE_PATH=syslog
		EOC
	else
		cat >> Makefile <<- EOC
			LOG_FILE_PATH=${EPREFIX}/var/log/exim/exim_%s.log
		EOC
	fi

	# starttls support (ssl)
	if use ssl; then
		echo "SUPPORT_TLS=yes" >> Makefile
		if use gnutls; then
			echo "USE_GNUTLS=yes" >> Makefile
			echo "USE_GNUTLS_PC=gnutls" >> Makefile
			use pkcs11 || echo "AVOID_GNUTLS_PKCS11=yes" >> Makefile
		else
			echo "USE_OPENSSL_PC=openssl" >> Makefile
		fi
	fi

	# TCP wrappers
	if use tcpd; then
		cat >> Makefile <<- EOC
			USE_TCP_WRAPPERS=yes
			EXTRALIBS_EXIM += -lwrap
		EOC
	fi

	# Light Mail Transport Protocol
	if use lmtp; then
		cat >> Makefile <<- EOC
			TRANSPORT_LMTP=yes
		EOC
	fi

	# embedded Perl
	if use perl; then
		cat >> Makefile <<- EOC
			EXIM_PERL=perl.o
		EOC
	fi

	# dlfunc
	if use dlfunc; then
		cat >> Makefile <<- EOC
			EXPAND_DLFUNC=yes
		EOC
	fi

	#
	# experimental features

	# Distributed Checksum Clearinghouse
	if use dcc; then
		echo "EXPERIMENTAL_DCC=yes">> Makefile
	fi

	# Sender Policy Framework
	if use spf; then
		cat >> Makefile <<- EOC
			EXPERIMENTAL_SPF=yes
			EXTRALIBS_EXIM += -lspf2
		EOC
	fi

	# Sender Rewriting Scheme
	if use srs; then
		cat >> Makefile <<- EOC
			EXPERIMENTAL_SRS=yes
			EXTRALIBS_EXIM += -lsrs_alt
		EOC
	fi

	# DMARC
	if use dmarc; then
		cat >> Makefile <<- EOC
			EXPERIMENTAL_DMARC=yes
			EXTRALIBS_EXIM += -lopendmarc
		EOC
	fi

	# Transport post-delivery actions
	if use tpda; then
		cat >> Makefile <<- EOC
			EXPERIMENTAL_EVENT=yes
		EOC
	fi

	# Proxy Protocol
	if use proxy; then
		cat >> Makefile <<- EOC
			EXPERIMENTAL_PROXY=yes
		EOC
	fi

	# Delivery Sender Notifications
	if use dsn; then
		cat >> Makefile <<- EOC
			EXPERIMENTAL_DSN=yes
		EOC
	fi

	#
	# authentication (SMTP AUTH)

	# standard bits
	cat >> Makefile <<- EOC
		AUTH_SPA=yes
		AUTH_CRAM_MD5=yes
		AUTH_PLAINTEXT=yes
	EOC

	# Cyrus SASL
	if use sasl; then
		cat >> Makefile <<- EOC
			CYRUS_SASLAUTHD_SOCKET=${EPREFIX}/run/saslauthd/mux
			AUTH_CYRUS_SASL=yes
			AUTH_LIBS += -lsasl2
		EOC
	fi

	# Dovecot
	if use dovecot-sasl; then
		cat >> Makefile <<- EOC
			AUTH_DOVECOT=yes
		EOC
	fi

	# Pluggable Authentication Modules
	if use pam; then
		cat >> Makefile <<- EOC
			SUPPORT_PAM=yes
			AUTH_LIBS += -lpam
		EOC
	fi

	# Radius
	if use radius; then
		cat >> Makefile <<- EOC
			RADIUS_CONFIG_FILE=${EPREFIX}/etc/radiusclient/radiusclient.conf
			RADIUS_LIB_TYPE=RADIUSCLIENT
			AUTH_LIBS += -lradiusclient
		EOC
	fi
}

src_compile() {
	emake -j1 CC="$(tc-getCC)" HOSTCC="$(tc-getCC $CBUILD)" \
		AR="$(tc-getAR) cq" RANLIB="$(tc-getRANLIB)" FULLECHO='' \
		|| die "make failed"
}

src_install () {
	cd "${S}"/build-exim-gentoo || die
	dosbin exim
	if use X; then
		dosbin eximon.bin
		dosbin eximon
	fi
	fperms 4755 /usr/sbin/exim

	dosym exim /usr/sbin/sendmail
	dosym exim /usr/sbin/rsmtp
	dosym exim /usr/sbin/rmail
	dosym /usr/sbin/exim /usr/bin/mailq
	dosym /usr/sbin/exim /usr/bin/newaliases
	dosym /usr/sbin/sendmail /usr/lib/sendmail

	for i in exicyclog exim_dbmbuild exim_dumpdb exim_fixdb exim_lock \
		exim_tidydb exinext exiwhat exigrep eximstats exiqsumm exiqgrep \
		convert4r3 convert4r4 exipick
	do
		dosbin $i
	done

	dodoc "${S}"/doc/*
	doman "${S}"/doc/exim.8
	use dsn && dodoc "${S}"/README.DSN
	use doc && dohtml -r "${WORKDIR}"/${PN}-html-${PV//rc/RC}/doc/html/spec_html/*

	# conf files
	insinto /etc/exim
	newins "${S}"/src/configure.default exim.conf.dist
	if use exiscan-acl; then
		newins "${S}"/src/configure.default exim.conf.exiscan-acl
	fi
	doins "${WORKDIR}"/system_filter.exim
	doins "${FILESDIR}"/auth_conf.sub

	pamd_mimic system-auth exim auth account

	# headers, #436406
	if use dlfunc ; then
		# fixup includes so they actually can be found when including
		sed -i \
			-e '/#include "\(config\|store\|mytypes\).h"/s:"\(.\+\)":<exim/\1>:' \
			local_scan.h || die
		insinto /usr/include/exim
		doins {config,local_scan}.h ../src/{mytypes,store}.h
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}/exim.logrotate" exim

	newinitd "${FILESDIR}"/exim.rc9 exim
	newconfd "${FILESDIR}"/exim.confd exim

	systemd_dounit "${FILESDIR}"/{exim.service,exim.socket,exim-submission.socket}
	systemd_newunit "${FILESDIR}"/exim_at.service 'exim@.service'
	systemd_newunit "${FILESDIR}"/exim-submission_at.service 'exim-submission@.service'

	DIROPTIONS="-m 0750 -o ${MAILUSER} -g ${MAILGROUP}"
	dodir /var/log/${PN}
}

pkg_postinst() {
	if [[ ! -f ${EROOT}etc/exim/exim.conf ]] ; then
		einfo "${EROOT}etc/exim/system_filter.exim is a sample system_filter."
		einfo "${EROOT}etc/exim/auth_conf.sub contains the configuration sub for using smtp auth."
		einfo "Please create ${EROOT}etc/exim/exim.conf from ${EROOT}etc/exim/exim.conf.dist."
	fi
	if use dcc ; then
		einfo "DCC support is experimental, you can find some limited"
		einfo "documentation at the bottom of this prerelease message:"
		einfo "http://article.gmane.org/gmane.mail.exim.devel/3579"
	fi
	use spf && einfo "SPF support is experimental"
	use srs && einfo "SRS support is experimental"
	if use dmarc ; then
		einfo "DMARC support is experimental.  See global settings to"
		einfo "configure DMARC, for usage see the documentation at "
		einfo "experimental-spec.txt."
	fi
	use tpda && einfo "TPDA/EVENT support is experimental"
	use proxy && einfo "proxy support is experimental"
	if use dsn ; then
		einfo "Starting from Exim 4.83, DSN support comes from upstream."
		einfo "DSN support is an experimental feature.  If you used DSN"
		einfo "support prior to 4.83, make sure to remove all dsn_process"
		einfo "switches from your routers, see http://bugs.gentoo.org/511818"
	fi
	einfo "Exim maintains some db files under its spool directory that need"
	einfo "cleaning from time to time.  (${EROOT}var/spool/exim/db)"
	einfo "Please use the exim_tidydb tool as documented in the Exim manual:"
	einfo "http://www.exim.org/exim-html-current/doc/html/spec_html/ch-exim_utilities.html#SECThindatmai"
}
