# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit autotools flag-o-matic linux-info python-any-r1 systemd

DESCRIPTION="An enhanced multi-threaded syslogd with database support and more"
HOMEPAGE="https://www.rsyslog.com/
	https://github.com/rsyslog/rsyslog/"

if [[ "${PV}" == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/rsyslog/${PN}"

	inherit git-r3
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 arm ~arm64 ~ppc64 ~riscv x86"
fi

LICENSE="GPL-3 LGPL-3 Apache-2.0"
SLOT="0"

IUSE="clickhouse curl dbi debug doc elasticsearch +gcrypt gnutls imdocker imhttp"
IUSE+=" impcap jemalloc kafka kerberos kubernetes mdblookup"
IUSE+=" mongodb mysql normalize omhttp omhttpfs omudpspoof +openssl"
IUSE+=" postgres rabbitmq redis relp rfc3195 rfc5424hmac snmp +ssl"
IUSE+=" systemd test usertools +uuid xxhash zeromq"

RESTRICT="!test? ( test )"

REQUIRED_USE="
	kubernetes? ( normalize )
	ssl? ( || ( gnutls openssl ) )
"

BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
	dev-build/autoconf-archive
	sys-apps/lsb-release
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		jemalloc? ( <sys-libs/libfaketime-0.9.7 )
		!jemalloc? ( sys-libs/libfaketime )
	)
	doc? (
		${PYTHON_DEPS}
		dev-python/accessible-pygments
		dev-python/furo
		dev-python/sphinx
		dev-python/sphinxcontrib-mermaid
	)
"
RDEPEND="
	>=dev-libs/libfastjson-1.2304.0-r1:=
	>=dev-libs/libestr-0.1.9
	>=virtual/zlib-1.2.5:=
	curl? ( >=net-misc/curl-7.35.0 )
	dbi? ( >=dev-db/libdbi-0.8.3 )
	elasticsearch? ( >=net-misc/curl-7.35.0 )
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:= )
	imdocker? ( >=net-misc/curl-7.40.0 )
	imhttp? (
		dev-libs/apr-util
		www-servers/civetweb
		virtual/libcrypt:=
	)
	impcap? ( net-libs/libpcap )
	jemalloc? ( >=dev-libs/jemalloc-3.3.1:= )
	kafka? ( >=dev-libs/librdkafka-0.9.0.99:= )
	kerberos? ( virtual/krb5 )
	kubernetes? ( >=net-misc/curl-7.35.0 )
	mdblookup? ( dev-libs/libmaxminddb:= )
	mongodb? ( >=dev-libs/mongo-c-driver-1.1.10:= )
	mysql? ( dev-db/mysql-connector-c:= )
	normalize? (
		>=dev-libs/liblognorm-2.0.3:=
	)
	clickhouse? ( >=net-misc/curl-7.35.0 )
	omhttpfs? ( >=net-misc/curl-7.35.0 )
	omudpspoof? ( >=net-libs/libnet-1.1.6 )
	postgres? ( >=dev-db/postgresql-8.4.20:= )
	rabbitmq? ( >=net-libs/rabbitmq-c-0.3.0:= )
	redis? (
		>=dev-libs/hiredis-0.11.0:=
		dev-libs/libevent[threads(+)]
	)
	relp? ( >=dev-libs/librelp-1.2.17:= )
	rfc3195? ( >=dev-libs/liblogging-1.0.1:=[rfc3195(+)] )
	rfc5424hmac? (
		>=dev-libs/openssl-0.9.8y:0=
	)
	snmp? ( >=net-analyzer/net-snmp-5.7.2 )
	ssl? (
		gnutls? ( >=net-libs/gnutls-2.12.23:0= )
		openssl? (
			dev-libs/openssl:0=
		)
	)
	systemd? ( >=sys-apps/systemd-234 )
	uuid? ( sys-apps/util-linux:0= )
	xxhash? ( dev-libs/xxhash:= )
	zeromq? (
		>=net-libs/czmq-4:=[drafts]
	)
"
DEPEND="
	${RDEPEND}
	elibc_musl? ( sys-libs/queue-standalone )
"

CONFIG_CHECK="~INOTIFY_USER"
WARNING_INOTIFY_USER="CONFIG_INOTIFY_USER isn't set. Imfile module on this system will only support polling mode!"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_fetch
		git-r3_checkout
	else
		unpack "${P}.tar.gz"
	fi
}

src_prepare() {
	default

	# Bug: https://github.com/rsyslog/rsyslog/issues/3626
	sed -i \
		-e '\|^#!/bin/bash$|a exit 77' \
		tests/mmkubernetes-cache-expir*.sh \
		|| die "Failed to disable known test failure mmkubernetes-cache-expir*.sh"

	local -a bad_tests=(
		omfwd-lb-1target-retry-1_byte_buf-TargetFail
		omprog-close-unresponsive
		omprog-restart-terminated
		omprog-restart-terminated-outfile
		uxsock_multiple
		uxsock_simple
	)
	local bad_test=""
	for bad_test in "${bad_tests[@]}" ; do
		sed -i -e '\|^#!/bin/bash$|a exit 0' tests/${bad_test}*.sh || die
	done

	eautoreconf
}

src_configure() {
	# https://github.com/rsyslog/rsyslog/issues/5507 (bug #943899)
	append-cflags -std=gnu17

	# Maintainer notes:
	# * Guardtime support is missing because libgt isn't yet available
	#   in portage.
	# * Hadoop's HDFS file system output module is currently not
	#   supported in Gentoo because nobody is able to test it
	#   (JAVA dependency).
	# * dev-libs/hiredis doesn't provide pkg-config (see #504614,
	#   upstream PR 129 and 136) so we need to export HIREDIS_*
	#   variables because rsyslog's build system depends on pkg-config.

	if use redis ; then
		export HIREDIS_LIBS="-L${EPREFIX}/usr/$(get_libdir) -lhiredis"
		export HIREDIS_CFLAGS="-I${EPREFIX}/usr/include"
	fi

	local -a myeconfargs=(
		--disable-debug-symbols
		--disable-generate-man-pages
		--without-valgrind-testbench
		--disable-liblogging-stdlog
		--disable-imfile-tests  # Some imfile tests fail (noticed in version 8.2208.0)
		$(use_enable test testbench)
		$(use_enable test libfaketime)
		$(use_enable test extended-tests)
		# Input Plugins without dependencies
		--enable-imbatchreport
		--enable-imdiag
		--enable-imfile
		--enable-improg
		--enable-impstats
		--enable-imptcp
		# Message Modificiation Plugins without dependencies
		--enable-mmanon
		--enable-mmaudit
		--enable-mmcount
		--enable-mmfields
		--enable-mmjsonparse
		--enable-mmpstrucdata
		--enable-mmrm1stspace
		--enable-mmsequence
		--enable-mmtaghostname
		--enable-mmutf8fix
		# Output Modification Plugins without dependencies
		--enable-mail
		--enable-omprog
		--enable-omruleset
		--enable-omstdout
		--enable-omuxsock
		# Misc
		--enable-fmhash
		--enable-fmunflatten
		$(use_enable xxhash fmhash-xxhash)
		--enable-pmaixforwardedfrom
		--enable-pmciscoios
		--enable-pmcisconames
		--enable-pmdb2diag
		--enable-pmlastmsg
		$(use_enable normalize pmnormalize)
		--enable-pmnull
		--enable-pmpanngfw
		--enable-pmsnare
		# DB
		$(use_enable dbi libdbi)
		$(use_enable mongodb ommongodb)
		$(use_enable mysql)
		$(use_enable postgres pgsql)
		$(use_enable redis imhiredis)
		$(use_enable redis omhiredis)
		# Debug
		$(use_enable debug)
		$(use_enable debug diagtools)
		$(use_enable debug valgrind)
		# Transport security
		$(use_enable openssl imdtls)
		$(use_enable openssl omdtls)
		$(use_enable openssl)
		# Misc
		$(use_enable clickhouse)
		$(use_enable curl fmhttp)
		$(use_enable elasticsearch)
		$(use_enable gcrypt libgcrypt)
		$(use_enable gnutls)
		$(use_enable imdocker)
		$(use_enable imhttp)
		$(use_enable impcap)
		$(use_enable jemalloc)
		$(use_enable kafka imkafka)
		$(use_enable kafka omkafka)
		$(use_enable kerberos gssapi-krb5)
		$(use_enable kubernetes mmkubernetes)
		$(use_enable mdblookup mmdblookup)
		$(use_enable normalize mmnormalize)
		$(use_enable omhttp)
		$(use_enable omhttpfs)
		$(use_enable omudpspoof)
		$(use_enable rabbitmq omrabbitmq)
		$(use_enable relp)
		$(use_enable rfc3195)
		$(use_enable rfc5424hmac mmrfc5424addhmac)
		$(use_enable snmp mmsnmptrapd)
		$(use_enable snmp)
		$(use_enable systemd imjournal)
		$(use_enable systemd omjournal)
		$(use_enable usertools)
		$(use_enable uuid)
		$(use_enable zeromq imczmq)
		$(use_enable zeromq omczmq)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use doc ; then
		einfo "Building documentation ..."
		sphinx-build -b html doc/source doc/_build/html || die "Building documentation failed!"
	fi
}

src_test() {
	local _has_increased_ulimit=

	# Sometimes tests aren't executable (i.e. when added via patch)
	einfo "Adjusting permissions of test scripts ..."
	find "${S}"/tests -type f -name '*.sh' \! -perm -111 -exec chmod a+x '{}' \; || \
		die "Failed to adjust test scripts permission"

	if ulimit -n 3072; then
		_has_increased_ulimit="true"
	fi

	if ! emake --jobs 1 check; then
		eerror "Test suite failed! :("

		if [[ -z "${_has_increased_ulimit}" ]]; then
			eerror "Probably because open file limit couldn't be set to 3072."
		fi

		if has userpriv ${FEATURES}; then
			eerror "Please try to reproduce the test suite failure with FEATURES=-userpriv " \
				"before you submit a bug report."
		fi

	fi
}

src_install() {
	local -a DOCS=( AUTHORS	ChangeLog "${FILESDIR}/README.gentoo-r1" )

	if use doc ; then
		local -a HTML_DOCS=( "${S}/doc/_build/html/." )
	fi

	default

	newconfd "${FILESDIR}/${PN}.confd-r1" ${PN}
	newinitd "${FILESDIR}/${PN}.initd-r1" ${PN}

	systemd_newunit "${FILESDIR}/${PN}.service" ${PN}.service

	keepdir /var/spool/${PN}
	keepdir /etc/ssl/${PN}
	keepdir /etc/${PN}.d

	insinto /etc
	newins "${FILESDIR}/${PN}.conf" ${PN}.conf

	insinto /etc/rsyslog.d/
	newins "${FILESDIR}/50-default-r2.conf" 50-default.conf

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/${PN}-r1.logrotate" ${PN}

	if use mysql; then
		insinto /usr/share/${PN}/scripts/mysql
		doins plugins/ommysql/createDB.sql
	fi

	if use postgres; then
		insinto /usr/share/${PN}/scripts/pgsql
		doins plugins/ompgsql/createDB.sql
	fi

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	local advertise_readme=0

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation

		advertise_readme=1

		if use mysql || use postgres; then
			echo
			elog "Sample SQL scripts for MySQL & PostgreSQL have been installed to:"
			elog "  /usr/share/doc/${PF}/scripts"
		fi

		if use ssl; then
			echo
			elog "To create a default CA and certificates for your server and clients, run:"
			elog "  emerge --config =${PF}"
			elog "on your logging server. You can run it several times,"
			elog "once for each logging client. The client certificates will be signed"
			elog "using the CA certificate generated during the first run."
		fi
	fi

	if [[ ${advertise_readme} -gt 0 ]]; then
		# We need to show the README file location

		echo ""
		elog "Please read"
		elog ""
		elog "  ${EPREFIX}/usr/share/doc/${PF}/README.gentoo*"
		elog ""
		elog "for more details."
	fi
}

pkg_config() {
	if ! use ssl ; then
		einfo "There is nothing to configure for rsyslog unless you"
		einfo "used USE=ssl to build it."

		return 0
	fi

	if ! hash certtool &>/dev/null; then
		die "certtool not found! Is net-libs/gnutls[tools] is installed?"
	fi

	# Make sure the certificates directory exists
	local CERTDIR="${EROOT}/etc/ssl/${PN}"
	if [[ ! -d "${CERTDIR}" ]]; then
		mkdir "${CERTDIR}" || die
	fi
	einfo "Your certificates will be stored in ${CERTDIR}"

	# Create a default CA if needed
	if [[ ! -f "${CERTDIR}/${PN}_ca.cert.pem" ]]; then
		einfo "No CA key and certificate found in ${CERTDIR}, creating them for you..."
		certtool --generate-privkey \
			--outfile "${CERTDIR}/${PN}_ca.privkey.pem" || die
		chmod 400 "${CERTDIR}/${PN}_ca.privkey.pem"

		cat > "${T}/${PF}.$$" <<- _EOF
		cn = Portage automated CA
		ca
		cert_signing_key
		expiration_days = 3650
		_EOF

		certtool --generate-self-signed \
			--load-privkey "${CERTDIR}/${PN}_ca.privkey.pem" \
			--outfile "${CERTDIR}/${PN}_ca.cert.pem" \
			--template "${T}/${PF}.$$" || die
		chmod 400 "${CERTDIR}/${PN}_ca.privkey.pem"

		# Create the server certificate
		echo
		einfon "Please type the Common Name of the SERVER you wish to create a certificate for: "
		read -r CN

		einfo "Creating private key and certificate for server ${CN}..."
		certtool --generate-privkey \
			--outfile "${CERTDIR}/${PN}_${CN}.key.pem" || die
		chmod 400 "${CERTDIR}/${PN}_${CN}.key.pem"

		cat > "${T}/${PF}.$$" <<- _EOF
		cn = ${CN}
		tls_www_server
		dns_name = ${CN}
		expiration_days = 3650
		_EOF

		certtool --generate-certificate \
			--outfile "${CERTDIR}/${PN}_${CN}.cert.pem" \
			--load-privkey "${CERTDIR}/${PN}_${CN}.key.pem" \
			--load-ca-certificate "${CERTDIR}/${PN}_ca.cert.pem" \
			--load-ca-privkey "${CERTDIR}/${PN}_ca.privkey.pem" \
			--template "${T}/${PF}.$$" &>/dev/null
		chmod 400 "${CERTDIR}/${PN}_${CN}.cert.pem"

	else
		einfo "Found existing ${CERTDIR}/${PN}_ca.cert.pem, skipping CA and SERVER creation."
	fi

	# Create a client certificate
	echo
	einfon "Please type the Common Name of the CLIENT you wish to create a certificate for: "
	read -r CN

	einfo "Creating private key and certificate for client ${CN}..."
	certtool --generate-privkey \
		--outfile "${CERTDIR}/${PN}_${CN}.key.pem" || die
	chmod 400 "${CERTDIR}/${PN}_${CN}.key.pem"

	cat > "${T}/${PF}.$$" <<- _EOF
	cn = ${CN}
	tls_www_client
	dns_name = ${CN}
	expiration_days = 3650
	_EOF

	certtool --generate-certificate \
		--outfile "${CERTDIR}/${PN}_${CN}.cert.pem" \
		--load-privkey "${CERTDIR}/${PN}_${CN}.key.pem" \
		--load-ca-certificate "${CERTDIR}/${PN}_ca.cert.pem" \
		--load-ca-privkey "${CERTDIR}/${PN}_ca.privkey.pem" \
		--template "${T}/${PF}.$$" || die
	chmod 400 "${CERTDIR}/${PN}_${CN}.cert.pem"

	rm -f "${T}/${PF}.$$"

	echo
	einfo "Here is the documentation on how to encrypt your log traffic:"
	einfo " https://www.rsyslog.com/doc/rsyslog_tls.html"
}
