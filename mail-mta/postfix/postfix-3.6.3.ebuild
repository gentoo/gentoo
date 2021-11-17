# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit pam systemd toolchain-funcs

MY_PV="${PV/_rc/-RC}"
MY_SRC="${PN}-${MY_PV}"
MY_URI="ftp://ftp.porcupine.org/mirrors/postfix-release/official"
RC_VER="2.7"

DESCRIPTION="A fast and secure drop-in replacement for sendmail"
HOMEPAGE="http://www.postfix.org/"
SRC_URI="${MY_URI}/${MY_SRC}.tar.gz"

LICENSE="|| ( IBM EPL-2.0 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 ~sparc x86"
IUSE="+berkdb cdb dovecot-sasl +eai ldap ldap-bind lmdb memcached mbox mysql nis pam postgres sasl selinux sqlite ssl"

DEPEND="
	acct-group/postfix
	acct-group/postdrop
	acct-user/postfix
	>=dev-libs/libpcre-3.4
	dev-lang/perl
	berkdb? ( >=sys-libs/db-3.2:* )
	cdb? ( || ( >=dev-db/tinycdb-0.76 >=dev-db/cdb-0.75-r4 ) )
	eai? ( dev-libs/icu:= )
	ldap? ( net-nds/openldap )
	ldap-bind? ( net-nds/openldap[sasl] )
	lmdb? ( >=dev-db/lmdb-0.9.11:= )
	mysql? ( dev-db/mysql-connector-c:0= )
	nis? ( net-libs/libnsl:= )
	pam? ( sys-libs/pam )
	postgres? ( dev-db/postgresql:* )
	sasl? (  >=dev-libs/cyrus-sasl-2 )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( >=dev-libs/openssl-1.1.1:0= )
	"

RDEPEND="${DEPEND}
	memcached? ( net-misc/memcached )
	net-mail/mailbase
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/msmtp[mta]
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/sendmail
	!mail-mta/opensmtpd
	!mail-mta/ssmtp[mta]
	selinux? ( sec-policy/selinux-postfix )"

REQUIRED_USE="ldap-bind? ( ldap sasl )"

S="${WORKDIR}/${MY_SRC}"

PATCHES=(
	"${FILESDIR}/${PN}-glibc-2.34.patch"
)

src_prepare() {
	default
	sed -i -e "/^#define ALIAS_DB_MAP/s|:/etc/aliases|:/etc/mail/aliases|" \
		src/util/sys_defs.h || die "sed failed"
	# change default paths to better comply with portage standard paths
	sed -i -e "s:/usr/local/:/usr/:g" conf/master.cf || die "sed failed"
}

src_configure() {
	for name in CDB LDAP LMDB MYSQL PCRE PGSQL SDBM SQLITE
	do
		local AUXLIBS_${name}=""
	done

	# Make sure LDFLAGS get passed down to the executables.
	local mycc="-DHAS_PCRE" mylibs="${LDFLAGS} -ldl"
	AUXLIBS_PCRE="$(pcre-config --libs)"

	use pam && mylibs="${mylibs} -lpam"

	if use ldap; then
		mycc="${mycc} -DHAS_LDAP"
		AUXLIBS_LDAP="-lldap -llber"
	fi

	if use mysql; then
		mycc="${mycc} -DHAS_MYSQL $(mysql_config --include)"
		AUXLIBS_MYSQL="$(mysql_config --libs)"
	fi

	if use postgres; then
		mycc="${mycc} -DHAS_PGSQL -I$(pg_config --includedir)"
		AUXLIBS_PGSQL="-L$(pg_config --libdir) -lpq"
	fi

	if use sqlite; then
		mycc="${mycc} -DHAS_SQLITE"
		AUXLIBS_SQLITE="-lsqlite3 -lpthread"
	fi

	if use ssl; then
		mycc="${mycc} -DUSE_TLS"
		mylibs="${mylibs} -lssl -lcrypto"
	fi

	if use lmdb; then
		mycc="${mycc} -DHAS_LMDB"
		AUXLIBS_LMDB="-llmdb -lpthread"
	fi

	if ! use eai; then
		mycc="${mycc} -DNO_EAI"
	fi

	# broken. and "in other words, not supported" by upstream.
	# Use inet_protocols setting in main.cf
	#if ! use ipv6; then
	#	mycc="${mycc} -DNO_IPV6"
	#fi

	if use sasl; then
		if use dovecot-sasl; then
			# Set dovecot as default.
			mycc="${mycc} -DDEF_SASL_SERVER=\\\"dovecot\\\""
		fi
		if use ldap-bind; then
			mycc="${mycc} -DUSE_LDAP_SASL"
		fi
		mycc="${mycc} -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I/usr/include/sasl"
		mylibs="${mylibs} -lsasl2"
	elif use dovecot-sasl; then
		mycc="${mycc} -DUSE_SASL_AUTH -DDEF_SERVER_SASL_TYPE=\\\"dovecot\\\""
	fi

	if ! use nis; then
		mycc="${mycc} -DNO_NIS"
	fi

	if ! use berkdb; then
		mycc="${mycc} -DNO_DB"
		if use cdb; then
			# change default hash format from Berkeley DB to cdb
			mycc="${mycc} -DDEF_DB_TYPE=\\\"cdb\\\""
		fi
	fi

	if use cdb; then
		mycc="${mycc} -DHAS_CDB -I/usr/include/cdb"
		# Tinycdb is preferred.
		if has_version dev-db/tinycdb ; then
			einfo "Building with dev-db/tinycdb"
			AUXLIBS_CDB="-lcdb"
		else
			einfo "Building with dev-db/cdb"
			CDB_PATH="/usr/$(get_libdir)"
			for i in cdb.a alloc.a buffer.a unix.a byte.a ; do
				AUXLIBS_CDB="${AUXLIBS_CDB} ${CDB_PATH}/${i}"
			done
		fi
	fi

	sed -i -e "/^RANLIB/s/ranlib/$(tc-getRANLIB)/g" "${S}"/makedefs
	sed -i -e "/^AR/s/ar/$(tc-getAR)/g" "${S}"/makedefs

	emake makefiles shared=yes dynamicmaps=no pie=yes \
		shlib_directory="/usr/$(get_libdir)/postfix/MAIL_VERSION" \
		DEBUG="" CC="$(tc-getCC)" OPT="${CFLAGS}" CCARGS="${mycc}" AUXLIBS="${mylibs}" \
		AUXLIBS_CDB="${AUXLIBS_CDB}" AUXLIBS_LDAP="${AUXLIBS_LDAP}" \
		AUXLIBS_LMDB="${AUXLIBS_LMDB}" AUXLIBS_MYSQL="${AUXLIBS_MYSQL}" \
		AUXLIBS_PCRE="${AUXLIBS_PCRE}" AUXLIBS_PGSQL="${AUXLIBS_PGSQL}" \
		AUXLIBS_SQLITE="${AUXLIBS_SQLITE}"
}

src_install() {
	LD_LIBRARY_PATH="${S}/lib" \
	/bin/sh postfix-install \
		-non-interactive \
		install_root="${D}" \
		config_directory="/etc/postfix" \
		manpage_directory="/usr/share/man" \
		command_directory="/usr/sbin" \
		mailq_path="/usr/bin/mailq" \
		newaliases_path="/usr/bin/newaliases" \
		sendmail_path="/usr/sbin/sendmail" \
		|| die "postfix-install failed"

	# Fix spool removal on upgrade
	rm -Rf "${D}"/var
	keepdir /var/spool/postfix

	# Install rmail for UUCP, closes bug #19127
	dobin auxiliary/rmail/rmail

	# Provide another link for legacy FSH
	dosym ../sbin/sendmail /usr/$(get_libdir)/sendmail

	# Install qshape, posttls-finger and collate and tlstype
	dobin auxiliary/qshape/qshape.pl
	doman man/man1/qshape.1
	dobin bin/posttls-finger
	doman man/man1/posttls-finger.1
	dobin auxiliary/collate/collate.pl
	newdoc auxiliary/collate/README README.collate
	dobin auxiliary/collate/tlstype.pl
	dodoc auxiliary/collate/README.tlstype

	# Performance tuning tools and their manuals
	dosbin bin/smtp-{source,sink} bin/qmqp-{source,sink}
	doman man/man1/smtp-{source,sink}.1 man/man1/qmqp-{source,sink}.1

	# Set proper permissions on required files/directories
	keepdir /var/lib/postfix
	fowners -R postfix:postfix /var/lib/postfix
	fperms 0750 /var/lib/postfix
	fowners root:postdrop /usr/sbin/post{drop,queue}
	fperms 02755 /usr/sbin/post{drop,queue}

	keepdir /etc/postfix
	keepdir /etc/postfix/postfix-files.d
	if use mbox; then
		mypostconf="mail_spool_directory=/var/spool/mail"
	else
		mypostconf="home_mailbox=.maildir/"
	fi
	LD_LIBRARY_PATH="${S}/lib" \
	"${D}"/usr/sbin/postconf -c "${D}"/etc/postfix \
		-e ${mypostconf} || die "postconf failed"

	insinto /etc/postfix
	newins "${FILESDIR}"/smtp.pass saslpass
	fperms 600 /etc/postfix/saslpass

	newinitd "${FILESDIR}"/postfix.rc6.${RC_VER} postfix
	# do not start mysql/postgres unnecessarily - bug #359913
	use mysql || sed -i -e "s/mysql //" "${D}/etc/init.d/postfix"
	use postgres || sed -i -e "s/postgresql //" "${D}/etc/init.d/postfix"

	dodoc *README COMPATIBILITY HISTORY PORTING RELEASE_NOTES*
	mv "${S}"/examples "${D}"/usr/share/doc/${PF}/
	# postfix set-permissions expects uncompressed man files
	docompress -x /usr/share/man

	if use pam; then
		pamd_mimic_system smtp auth account
	fi

	if use sasl; then
		insinto /etc/sasl2
		newins "${FILESDIR}"/smtp.sasl smtpd.conf
	fi

	# header files
	insinto /usr/include/postfix
	doins include/*.h

	if has_version mail-mta/postfix; then
		# let the sysadmin decide when to change the compatibility_level
		sed -i -e /^compatibility_level/"s/^/#/" "${D}"/etc/postfix/main.cf || die
	fi

	systemd_dounit "${FILESDIR}/${PN}.service"
}

pkg_postinst() {
	if [[ ! -e /etc/mail/aliases.db ]] ; then
		ewarn
		ewarn "You must edit /etc/mail/aliases to suit your needs"
		ewarn "and then run /usr/bin/newaliases. Postfix will not"
		ewarn "work correctly without it."
		ewarn
	fi

	# check and fix file permissions
	"${EROOT}"/usr/sbin/postfix set-permissions

	# configure tls
	if use ssl ; then
		if "${EROOT}"/usr/sbin/postfix tls all-default-client; then
			elog "To configure client side TLS settings:"
			elog "${EROOT}"/usr/sbin/postfix tls enable-client
		fi
		if "${EROOT}"/usr/sbin/postfix tls all-default-server; then
			elog "To configure server side TLS settings:"
			elog "${EROOT}"/usr/sbin/postfix tls enable-server
		fi
	fi
}
