# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic multilib multilib-minimal autotools pam java-pkg-opt-2 db-use systemd

SASLAUTHD_CONF_VER="2.1.26"

DESCRIPTION="The Cyrus SASL (Simple Authentication and Security Layer)"
HOMEPAGE="http://cyrusimap.web.cmu.edu/"
SRC_URI="ftp://ftp.cyrusimap.org/cyrus-sasl/${P}.tar.gz"

LICENSE="BSD-with-attribution"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="authdaemond berkdb gdbm kerberos ldapdb openldap mysql pam postgres sample selinux sqlite
srp ssl static-libs urandom"

DEPEND="net-mail/mailbase
	authdaemond? ( || ( net-mail/courier-imap mail-mta/courier ) )
	berkdb? ( >=sys-libs/db-4.8.30-r1:=[${MULTILIB_USEDEP}] )
	gdbm? ( >=sys-libs/gdbm-1.10-r1[${MULTILIB_USEDEP}] )
	kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	openldap? ( >=net-nds/openldap-2.4.38-r1[${MULTILIB_USEDEP}] )
	mysql? ( virtual/mysql )
	pam? ( >=virtual/pam-0-r1[${MULTILIB_USEDEP}] )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( >=dev-db/sqlite-3.8.2:3[${MULTILIB_USEDEP}] )
	ssl? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] )
	java? ( >=virtual/jdk-1.4:= )"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-sasl )"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/sasl/md5global.h
)

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.1.25-sasldb_al.patch
	epatch "${FILESDIR}"/${PN}-2.1.25-saslauthd_libtool.patch
	epatch "${FILESDIR}"/${PN}-2.1.25-avoid_pic_overwrite.patch
	epatch "${FILESDIR}"/${PN}-2.1.25-autotools_fixes.patch
	epatch "${FILESDIR}"/${PN}-2.1.25-as_needed.patch
	epatch "${FILESDIR}"/${PN}-2.1.25-missing_header.patch
	epatch "${FILESDIR}"/${PN}-2.1.25-fix_heimdal.patch
	epatch "${FILESDIR}"/${PN}-2.1.25-auxprop.patch
	epatch "${FILESDIR}"/${PN}-2.1.23-gss_c_nt_hostbased_service.patch
	epatch "${FILESDIR}"/${PN}-2.1.25-service_keytabs.patch
	epatch "${FILESDIR}"/${PN}-2.1.26-missing-size_t.patch
	epatch "${FILESDIR}"/${PN}-2.1.26-CVE-2013-4122.patch
	epatch "${FILESDIR}"/${PN}-2.1.26-send-imap-logout.patch
	epatch "${FILESDIR}"/${PN}-2.1.26-canonuser-ldapdb-garbage-in-out-buffer.patch
	epatch "${FILESDIR}"/${PN}-2.1.26-fix_dovecot_authentication.patch

	# Get rid of the -R switch (runpath_switch for Sun)
	# >=gcc-4.6 errors out with unknown option
	sed -i -e '/LIB_SQLITE.*-R/s/ -R[^"]*//' \
		configure.in || die

	# Use plugindir for sasldir
	sed -i '/^sasldir =/s:=.*:= $(plugindir):' \
		"${S}"/plugins/Makefile.{am,in} || die "sed failed"

	# #486740 #468556
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g' \
		-e 's:AC_CONFIG_MACRO_DIR:AC_CONFIG_MACRO_DIRS:g' \
		configure.in || die
	sed -i -e 's:AC_CONFIG_MACRO_DIR:AC_CONFIG_MACRO_DIRS:g' \
		saslauthd/configure.in || die

	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing
	append-cppflags -D_XOPEN_SOURCE -D_XOPEN_SOURCE_EXTENDED -D_BSD_SOURCE -DLDAP_DEPRECATED

	multilib-minimal_src_configure
}

multilib_src_configure() {
	# Java support.
	multilib_is_native_abi && use java && export JAVAC="${JAVAC} ${JAVACFLAGS}"

	local myconf=()

	# Add authdaemond support (bug #56523).
	if use authdaemond ; then
		myconf+=( --with-authdaemond=/var/lib/courier/authdaemon/socket )
	fi

	# Fix for bug #59634.
	if ! use ssl ; then
		myconf+=( --without-des )
	fi

	if use sqlite || { multilib_is_native_abi && { use mysql || use postgres; }; } ; then
		myconf+=( --enable-sql )
	else
		myconf+=( --disable-sql )
	fi

	# Default to GDBM if both 'gdbm' and 'berkdb' are present.
	if use gdbm ; then
		einfo "Building with GNU DB as database backend for your SASLdb"
		myconf+=( --with-dblib=gdbm )
	elif use berkdb ; then
		einfo "Building with BerkeleyDB as database backend for your SASLdb"
		myconf+=(
			--with-dblib=berkeley
			--with-bdb-incdir="$(db_includedir)"
		)
	else
		einfo "Building without SASLdb support"
		myconf+=( --with-dblib=none )
	fi

	# Use /dev/urandom instead of /dev/random (bug #46038).
	if use urandom ; then
		myconf+=( --with-devrandom=/dev/urandom )
	fi

	ECONF_SOURCE=${S} \
	econf \
		--enable-login \
		--enable-ntlm \
		--enable-auth-sasldb \
		--disable-cmulocal \
		--disable-krb4 \
		--enable-otp \
		--without-sqlite \
		--with-saslauthd=/run/saslauthd \
		--with-pwcheck=/run/saslauthd \
		--with-configdir=/etc/sasl2 \
		--with-plugindir=/usr/$(get_libdir)/sasl2 \
		--with-dbpath=/etc/sasl2/sasldb2 \
		$(use_with ssl openssl) \
		$(use_with pam) \
		$(use_with openldap ldap) \
		$(use_enable ldapdb) \
		$(multilib_native_use_enable sample) \
		$(use_enable kerberos gssapi) \
		$(multilib_native_use_enable java) \
		$(multilib_native_use_with java javahome ${JAVA_HOME}) \
		$(multilib_native_use_with mysql mysql /usr) \
		$(multilib_native_use_with postgres pgsql) \
		$(use_with sqlite sqlite3 /usr/$(get_libdir)) \
		$(use_enable srp) \
		$(use_enable static-libs static) \
		"${myconf[@]}"
}

multilib_src_compile() {
	emake

	# Default location for java classes breaks OpenOffice (bug #60769).
	# Thanks to axxo@gentoo.org for the solution.
	if multilib_is_native_abi && use java ; then
		jar -cvf ${PN}.jar -C java $(find java -name "*.class")
	fi
}

multilib_src_install() {
	default

	if multilib_is_native_abi; then
		if use sample ; then
			docinto sample
			dodoc "${S}"/sample/*.c
			exeinto /usr/share/doc/${P}/sample
			doexe sample/client sample/server
		fi

		# Default location for java classes breaks OpenOffice (bug #60769).
		if use java ; then
			java-pkg_dojar ${PN}.jar
			java-pkg_regso "${D}/usr/$(get_libdir)/libjavasasl.so"
			# hackish, don't wanna dig through makefile
			rm -Rf "${D}/usr/$(get_libdir)/java"
			docinto "java"
			dodoc "${S}/java/README" "${FILESDIR}/java.README.gentoo" "${S}"/java/doc/*
			dodir "/usr/share/doc/${PF}/java/Test"
			insinto "/usr/share/doc/${PF}/java/Test"
			doins "${S}"/java/Test/*.java
		fi

		dosbin saslauthd/testsaslauthd
	fi
}

multilib_src_install_all() {
	keepdir /etc/sasl2

	dodoc AUTHORS ChangeLog NEWS README doc/TODO doc/*.txt
	newdoc pwcheck/README README.pwcheck
	dohtml doc/*.html

	docinto "saslauthd"
	dodoc saslauthd/{AUTHORS,ChangeLog,LDAP_SASLAUTHD,NEWS,README}

	newpamd "${FILESDIR}/saslauthd.pam-include" saslauthd

	newinitd "${FILESDIR}/pwcheck.rc6" pwcheck
	systemd_dounit "${FILESDIR}/pwcheck.service"

	newinitd "${FILESDIR}/saslauthd2.rc7" saslauthd
	newconfd "${FILESDIR}/saslauthd-${SASLAUTHD_CONF_VER}.conf" saslauthd
	systemd_dounit "${FILESDIR}/saslauthd.service"
	systemd_dotmpfilesd "${FILESDIR}/${PN}.conf"

	prune_libtool_files --modules
}

pkg_postinst () {
	# Generate an empty sasldb2 with correct permissions.
	if ( use berkdb || use gdbm ) && [[ ! -f "${ROOT}/etc/sasl2/sasldb2" ]] ; then
		einfo "Generating an empty sasldb2 with correct permissions ..."
		echo "p" | "${ROOT}/usr/sbin/saslpasswd2" -f "${ROOT}/etc/sasl2/sasldb2" -p login \
			|| die "Failed to generate sasldb2"
		"${ROOT}/usr/sbin/saslpasswd2" -f "${ROOT}/etc/sasl2/sasldb2" -d login \
			|| die "Failed to delete temp user"
		chown root:mail "${ROOT}/etc/sasl2/sasldb2" \
			|| die "Failed to chown ${ROOT}/etc/sasl2/sasldb2"
		chmod 0640 "${ROOT}/etc/sasl2/sasldb2" \
			|| die "Failed to chmod ${ROOT}/etc/sasl2/sasldb2"
	fi

	if use authdaemond ; then
		elog "You need to add a user running a service using Courier's"
		elog "authdaemon to the 'mail' group. For example, do:"
		elog "	gpasswd -a postfix mail"
		elog "to add the 'postfix' user to the 'mail' group."
	fi

	elog "pwcheck and saslauthd home directories have moved to:"
	elog "  /run/saslauthd, using tmpfiles.d"
}
