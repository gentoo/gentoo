# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cyrus-sasl/cyrus-sasl-2.1.23-r7.ebuild,v 1.16 2015/03/21 21:07:10 jlec Exp $

EAPI=2

inherit eutils flag-o-matic multilib autotools pam java-pkg-opt-2 db-use

ntlm_patch="${P}-ntlm_impl-spnego.patch.gz"
SASLAUTHD_CONF_VER="2.1.21"

DESCRIPTION="The Cyrus SASL (Simple Authentication and Security Layer)"
HOMEPAGE="http://asg.web.cmu.edu/sasl/"
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/${P}.tar.gz
	ntlm_unsupported_patch? ( mirror://gentoo/${ntlm_patch} )"

LICENSE="BSD-with-attribution"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="authdaemond berkdb crypt gdbm kerberos openldap mysql ntlm_unsupported_patch pam postgres sample srp ssl urandom"

DEPEND="authdaemond? ( || ( >=net-mail/courier-imap-3.0.7 >=mail-mta/courier-0.46 ) )
	berkdb? ( >=sys-libs/db-3.2 )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )
	kerberos? ( virtual/krb5 )
	openldap? ( >=net-nds/openldap-2.0.25 )
	mysql? ( virtual/mysql )
	ntlm_unsupported_patch? ( >=net-fs/samba-3.0.9 )
	pam? ( virtual/pam )
	postgres? ( dev-db/postgresql )
	ssl? ( >=dev-libs/openssl-0.9.6d )
	java? ( >=virtual/jdk-1.4 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use gdbm && use berkdb ; then
		echo
		elog "You have both 'gdbm' and 'berkdb' USE flags enabled."
		elog "gdbm will be selected."
		echo
	fi
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	# Fix default port name for rimap auth mechanism.
	sed -e '/define DEFAULT_REMOTE_SERVICE/s:imap:imap2:' \
		-i saslauthd/auth_rimap.c || die "sed failed"

	# UNSUPPORTED ntlm patch #81342
	use ntlm_unsupported_patch && epatch "${DISTDIR}/${ntlm_patch}"
	epatch "${FILESDIR}"/${PN}-2.1.17-pgsql-include.patch
	use crypt && epatch "${FILESDIR}"/${PN}-2.1.19-checkpw.c.patch #45181
	epatch "${FILESDIR}"/${PN}-2.1.22-as-needed.patch
	epatch "${FILESDIR}/${PN}-2.1.21-keytab.patch"
	epatch "${FILESDIR}"/${PN}-2.1.22-crypt.patch #152544
	epatch "${FILESDIR}"/${PN}-2.1.22-qa.patch
	epatch "${FILESDIR}/${PN}-2.1.22-gcc44.patch" #248738
	epatch "${FILESDIR}"/${P}-authd-fix.patch
	epatch "${FILESDIR}"/${P}+db-5.0.patch
	epatch "${FILESDIR}/${PN}-0001_versioned_symbols.patch"
	epatch "${FILESDIR}/${PN}-0002_testsuite.patch"
	epatch "${FILESDIR}/${PN}-0006_library_mutexes.patch"
	epatch "${FILESDIR}/${PN}-0008_one_time_sasl_set_alloc.patch"
	epatch "${FILESDIR}/${PN}-0010_maintainer_mode.patch"
	epatch "${FILESDIR}/${PN}-0011_saslauthd_ac_prog_libtool.patch"
	epatch "${FILESDIR}/${PN}-0012_xopen_crypt_prototype.patch"
	epatch "${FILESDIR}/${PN}-0014_avoid_pic_overwrite.patch"
	epatch "${FILESDIR}/${PN}-0016_pid_file_lock_creation_mask.patch"
	epatch "${FILESDIR}/${PN}-0026_drop_krb5support_dependency.patch"
	epatch "${FILESDIR}"/${P}-rimap-loop.patch #381427
	epatch "${FILESDIR}"/${P}-gss_c_nt_hostbased_service.patch #389349
	epatch "${FILESDIR}"/${P}-CVE-2013-4122.patch

	sed -i -e '/for dbname in/s:db-4.* db:'$(db_libname)':' \
		"${S}"/cmulocal/berkdb.m4

	# Upstream doesn't even honor their own configure options... grumble
	sed -i '/^sasldir =/s:=.*:= $(plugindir):' \
		"${S}"/plugins/Makefile.{am,in} || die "sed failed"

	# make sure to use common plugin ldflags
	sed -i '/_la_LDFLAGS = /s:=:= $(AM_LDFLAGS) :' plugins/Makefile.am || die

	# Recreate configure.
	rm -f "${S}/config/libtool.m4" || die "rm libtool.m4 failed"
	AT_M4DIR="${S}/cmulocal ${S}/config" eautoreconf
}

src_configure() {
	# Fix QA issues.
	append-flags -fno-strict-aliasing
	append-cppflags -D_XOPEN_SOURCE -D_XOPEN_SOURCE_EXTENDED -D_BSD_SOURCE -DLDAP_DEPRECATED

	# Java support.
	use java && export JAVAC="${JAVAC} ${JAVACFLAGS}"

	local myconf

	# Add authdaemond support (bug #56523).
	if use authdaemond ; then
		myconf="${myconf} --with-authdaemond=/var/lib/courier/authdaemon/socket"
	fi

	# Fix for bug #59634.
	if ! use ssl ; then
		myconf="${myconf} --without-des"
	fi

	if use mysql || use postgres ; then
		myconf="${myconf} --enable-sql"
	else
		myconf="${myconf} --disable-sql"
	fi

	# Default to GDBM if both 'gdbm' and 'berkdb' are present.
	if use gdbm ; then
		einfo "Building with GNU DB as database backend for your SASLdb"
		myconf="${myconf} --with-dblib=gdbm"
	elif use berkdb ; then
		einfo "Building with BerkeleyDB as database backend for your SASLdb"
		myconf="${myconf} --with-dblib=berkeley --with-bdb-incdir=$(db_includedir)"
	else
		einfo "Building without SASLdb support"
		myconf="${myconf} --with-dblib=none"
	fi

	# Use /dev/urandom instead of /dev/random (bug #46038).
	use urandom && myconf="${myconf} --with-devrandom=/dev/urandom"

	econf \
		--enable-login \
		--enable-ntlm \
		--enable-auth-sasldb \
		--disable-krb4 \
		--disable-otp \
		--without-sqlite \
		--with-saslauthd=/var/lib/sasl2 \
		--with-pwcheck=/var/lib/sasl2 \
		--with-configdir=/etc/sasl2 \
		--with-plugindir=/usr/$(get_libdir)/sasl2 \
		--with-dbpath=/etc/sasl2/sasldb2 \
		$(use_with ssl openssl) \
		$(use_with pam) \
		$(use_with openldap ldap) \
		$(use_enable openldap ldapdb) \
		$(use_enable sample) \
		$(use_enable kerberos gssapi) \
		$(use_enable java) \
		$(use_with java javahome ${JAVA_HOME}) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_enable srp) \
		${myconf}
}

src_compile() {
	# We force -j1 for bug #110066.
	emake -j1 || die "emake failed"

	# Default location for java classes breaks OpenOffice (bug #60769).
	# Thanks to axxo@gentoo.org for the solution.
	cd "${S}"
	if use java ; then
		jar -cvf ${PN}.jar -C java $(find java -name "*.class")
	fi

	# Add testsaslauthd (bug #58768).
	cd "${S}/saslauthd"
	emake testsaslauthd || die "emake testsaslauthd failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	keepdir /var/lib/sasl2 /etc/sasl2

	# Install everything necessary so users can build sample
	# client/server (bug #64733).
	if use sample ; then
		insinto /usr/share/${PN}-2/examples
		doins aclocal.m4 config.h config.status configure.in
		dosym /usr/include/sasl /usr/share/${PN}-2/examples/include
		exeinto /usr/share/${PN}-2/examples
		doexe libtool
		insinto /usr/share/${PN}-2/examples/sample
		doins sample/*.{c,h} sample/*Makefile*
		insinto /usr/share/${PN}-2/examples/sample/.deps
		doins sample/.deps/*
		dodir /usr/share/${PN}-2/examples/lib
		dosym /usr/$(get_libdir)/libsasl2.la /usr/share/${PN}-2/examples/lib/libsasl2.la
		dodir /usr/share/${PN}-2/examples/lib/.libs
		dosym /usr/$(get_libdir)/libsasl2.so /usr/share/${PN}-2/examples/lib/.libs/libsasl2.so
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
		doins "${S}"/java/Test/*.java || die "Failed to copy java files to /usr/share/doc/${PF}/java/Test"
	fi

	docinto ""
	dodoc AUTHORS ChangeLog NEWS README doc/TODO doc/*.txt
	newdoc pwcheck/README README.pwcheck
	dohtml doc/*.html

	docinto "saslauthd"
	dodoc saslauthd/{AUTHORS,ChangeLog,LDAP_SASLAUTHD,NEWS,README}

	newpamd "${FILESDIR}/saslauthd.pam-include" saslauthd || die "Failed to install saslauthd to /etc/pam.d"

	newinitd "${FILESDIR}/pwcheck.rc6" pwcheck || die "Failed to install pwcheck to /etc/init.d"

	newinitd "${FILESDIR}/saslauthd2.rc6" saslauthd || die "Failed to install saslauthd to /etc/init.d"
	newconfd "${FILESDIR}/saslauthd-${SASLAUTHD_CONF_VER}.conf" saslauthd || die "Failed to install saslauthd to /etc/conf.d"

	newsbin "${S}/saslauthd/testsaslauthd" testsaslauthd || die "Failed to install testsaslauthd"
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

	if use sample ; then
		elog "You have chosen to install sources for the example client and server."
		elog "To build these, please type:"
		elog "\tcd /usr/share/${PN}-2/examples/sample && make"
	fi

	if use authdaemond ; then
		elog "You need to add a user running a service using Courier's"
		elog "authdaemon to the 'mail' group. For example, do:"
		elog "	gpasswd -a postfix mail"
		elog "to add the 'postfix' user to the 'mail' group."
	fi
}
