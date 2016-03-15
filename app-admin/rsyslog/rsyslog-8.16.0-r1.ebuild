# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils systemd

DESCRIPTION="An enhanced multi-threaded syslogd with database support and more"
HOMEPAGE="http://www.rsyslog.com/"

BRANCH="8-stable"

PATCHES=(
	"${FILESDIR}"/8-stable/50-rsyslog-8.15.0-imtcp-tls-basic-vg-test-workaround.patch
	"${FILESDIR}"/8-stable/50-rsyslog-8.15.0-imfile-readmode2-vg-test-workaround.patch
	"${FILESDIR}"/8-stable/50-rsyslog-8.16.0-fix-queue-engine-issue-262.patch
	"${FILESDIR}"/8-stable/50-rsyslog-8.16.0-fix-leap-year-handling.patch
)

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="
		git://github.com/rsyslog/${PN}.git
		https://github.com/rsyslog/${PN}.git
	"

	DOC_REPO_URI="
		git://github.com/rsyslog/${PN}-doc.git
		https://github.com/rsyslog/${PN}-doc.git
	"

	inherit git-r3
else
	SRC_URI="
		http://www.rsyslog.com/files/download/${PN}/${P}.tar.gz
		doc? ( http://www.rsyslog.com/files/download/${PN}/${PN}-doc-${PV}.tar.gz )
	"
	KEYWORDS="~amd64 ~arm ~hppa ~x86"
fi

LICENSE="GPL-3 LGPL-3 Apache-2.0"
SLOT="0"
IUSE="dbi debug doc elasticsearch +gcrypt jemalloc kerberos libressl mongodb mysql normalize omudpspoof"
IUSE+=" postgres rabbitmq redis relp rfc3195 rfc5424hmac snmp ssl systemd test usertools zeromq"

RDEPEND="
	>=dev-libs/json-c-0.11:=
	>=dev-libs/libestr-0.1.9
	>=dev-libs/liblogging-1.0.1:=[stdlog]
	>=sys-libs/zlib-1.2.5
	dbi? ( >=dev-db/libdbi-0.8.3 )
	elasticsearch? ( >=net-misc/curl-7.35.0 )
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:= )
	jemalloc? ( >=dev-libs/jemalloc-3.3.1 )
	kerberos? ( virtual/krb5 )
	mongodb? ( >=dev-libs/libmongo-client-0.1.4 )
	mysql? ( virtual/mysql )
	normalize? (
		>=dev-libs/libee-0.4.0
		>=dev-libs/liblognorm-1.1.2:=
	)
	omudpspoof? ( >=net-libs/libnet-1.1.6 )
	postgres? ( >=dev-db/postgresql-8.4.20:= )
	rabbitmq? ( >=net-libs/rabbitmq-c-0.3.0 )
	redis? ( >=dev-libs/hiredis-0.11.0 )
	relp? ( >=dev-libs/librelp-1.2.5 )
	rfc3195? ( >=dev-libs/liblogging-1.0.1:=[rfc3195] )
	rfc5424hmac? (
		!libressl? ( >=dev-libs/openssl-0.9.8y:0= )
		libressl? ( dev-libs/libressl:= )
	)
	snmp? ( >=net-analyzer/net-snmp-5.7.2 )
	ssl? ( >=net-libs/gnutls-2.12.23:0= )
	systemd? ( >=sys-apps/systemd-208 )
	zeromq? ( >=net-libs/czmq-1.2.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

if [[ ${PV} == "9999" ]]; then
	DEPEND+=" doc? ( >=dev-python/sphinx-1.1.3-r7 )"
	DEPEND+=" >=sys-devel/flex-2.5.39-r1"
	DEPEND+=" >=sys-devel/bison-2.4.3"
	DEPEND+=" >=dev-python/docutils-0.12"
fi

# Maitainer note : open a bug to upstream
# showing that building in a separate dir fails
AUTOTOOLS_IN_SOURCE_BUILD=1

AUTOTOOLS_PRUNE_LIBTOOL_FILES="modules"

DOCS=(
	AUTHORS
	ChangeLog
	"${FILESDIR}"/${BRANCH}/README.gentoo
)

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${P}.tar.gz
	fi

	if use doc; then
		if [[ ${PV} == "9999" ]]; then
			local _EGIT_BRANCH=
			if [ -n "${EGIT_BRANCH}" ]; then
				# Cannot use rsyslog commits/branches for documentation repository
				_EGIT_BRANCH=${EGIT_BRANCH}
				unset EGIT_BRANCH
			fi

			git-r3_fetch "${DOC_REPO_URI}"
			git-r3_checkout "${DOC_REPO_URI}" "${S}"/docs

			if [ -n "${_EGIT_BRANCH}" ]; then
				# Restore previous EGIT_BRANCH information
				EGIT_BRANCH=${_EGIT_BRANCH}
			fi
		else
			local doc_tarball="${PN}-doc-${PV}.tar.gz"

			cd "${S}" || die "Cannot change dir into '$S'"
			mkdir docs || die "Failed to create docs directory"
			cd docs || die "Failed to change dir into '${S}/docs'"
			unpack ${doc_tarball}
		fi
	fi
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# Maintainer notes:
	# * Guardtime support is missing because libgt isn't yet available
	#   in portage.
	# * Hadoop's HDFS file system output module is currently not
	#   supported in Gentoo because nobody is able to test it
	#   (JAVA dependency).
	# * dev-libs/hiredis doesn't provide pkg-config (see #504614,
	#   upstream PR 129 and 136) so we need to export HIREDIS_*
	#   variables because rsyslog's build system depends on pkg-config.

	if use redis; then
		export HIREDIS_LIBS="-L${EPREFIX}/usr/$(get_libdir) -lhiredis"
		export HIREDIS_CFLAGS="-I${EPREFIX}/usr/include"
	fi

	local myeconfargs=(
		--disable-debug-symbols
		--disable-generate-man-pages
		--without-valgrind-testbench
		$(use_enable test testbench)
		# Input Plugins without depedencies
		--enable-imdiag
		--enable-imfile
		--enable-impstats
		--enable-imptcp
		# Message Modificiation Plugins without depedencies
		--enable-mmanon
		--enable-mmaudit
		--enable-mmfields
		--enable-mmjsonparse
		--enable-mmpstrucdata
		--enable-mmsequence
		--enable-mmutf8fix
		# Output Modification Plugins without dependencies
		--enable-mail
		--enable-omprog
		--enable-omruleset
		--enable-omstdout
		--enable-omuxsock
		# Misc
		--disable-omkafka
		--enable-pmaixforwardedfrom
		--enable-pmciscoios
		--enable-pmcisconames
		--enable-pmlastmsg
		--enable-pmsnare
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		# DB
		$(use_enable dbi libdbi)
		$(use_enable mongodb ommongodb)
		$(use_enable mysql)
		$(use_enable postgres pgsql)
		$(use_enable redis omhiredis)
		# Debug
		$(use_enable debug)
		$(use_enable debug diagtools)
		$(use_enable debug memcheck)
		$(use_enable debug rtinst)
		$(use_enable debug valgrind)
		# Misc
		$(use_enable elasticsearch)
		$(use_enable gcrypt libgcrypt)
		$(use_enable jemalloc)
		$(use_enable kerberos gssapi-krb5)
		$(use_enable normalize mmnormalize)
		$(use_enable omudpspoof)
		$(use_enable rabbitmq omrabbitmq)
		$(use_enable relp)
		$(use_enable rfc3195)
		$(use_enable rfc5424hmac mmrfc5424addhmac)
		$(use_enable snmp)
		$(use_enable snmp mmsnmptrapd)
		$(use_enable ssl gnutls)
		$(use_enable systemd imjournal)
		$(use_enable systemd omjournal)
		$(use_enable usertools)
		$(use_enable zeromq imzmq3)
		$(use_enable zeromq omzmq3)
	)

	econf ${myeconfargs[@]}
}

src_compile() {
	default

	if use doc && [[ "${PV}" == "9999" ]]; then
		einfo "Building documentation ..."
		local doc_dir="${S}/docs"
		cd "${doc_dir}" || die "Cannot chdir into \"${doc_dir}\"!"
		sphinx-build -b html source build || die "Building documentation failed!"
	fi
}

src_test() {
	local _has_increased_ulimit=

	# When adding new tests via patches we have to make them executable
	einfo "Adjusting permissions of test scripts ..."
	find "${S}"/tests -type f -name '*.sh' \! -perm -111 -exec chmod a+x '{}' \; || \
		die "Failed to adjust test scripts permission"

	if ulimit -n 3072; then
		_has_increased_ulimit="true"
	fi

	if ! emake --jobs 1 check; then
		eerror "Test suite failed! :("

		if [ -z "${_has_increased_ulimit}" ]; then
			eerror "Probably because open file limit couldn't be set to 3072."
		fi

		if has userpriv $FEATURES; then
			eerror "Please try to reproduce the test suite failure with FEATURES=-userpriv " \
				"before you submit a bug report."
		fi

	fi
}

src_install() {
	default

	newconfd "${FILESDIR}/${BRANCH}/${PN}.confd-r1" ${PN}
	newinitd "${FILESDIR}/${BRANCH}/${PN}.initd-r1" ${PN}

	keepdir /var/empty/dev
	keepdir /var/spool/${PN}
	keepdir /etc/ssl/${PN}
	keepdir /etc/${PN}.d

	insinto /etc
	newins "${FILESDIR}/${BRANCH}/${PN}.conf" ${PN}.conf

	insinto /etc/rsyslog.d/
	doins "${FILESDIR}/${BRANCH}/50-default.conf"

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/${BRANCH}/${PN}.logrotate" ${PN}

	if use mysql; then
		insinto /usr/share/doc/${PF}/scripts/mysql
		doins plugins/ommysql/createDB.sql
	fi

	if use postgres; then
		insinto /usr/share/doc/${PF}/scripts/pgsql
		doins plugins/ompgsql/createDB.sql
	fi

	use doc && dohtml -r "${S}/docs/build/"
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

	if [[ -z "${REPLACING_VERSIONS}" ]] || [[ ${REPLACING_VERSIONS} < 8.0 ]]; then
		# Show this message until rsyslog-8.x
		echo
		elog "Since ${PN}-7.6.3 we no longer use the catch-all log target"
		elog "\"/var/log/syslog\" due to its redundancy to the other log targets."

		advertise_readme=1
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

	# Make sure the certificates directory exists
	CERTDIR="${EROOT}/etc/ssl/${PN}"
	if [ ! -d "${CERTDIR}" ]; then
		mkdir "${CERTDIR}" || die
	fi
	einfo "Your certificates will be stored in ${CERTDIR}"

	# Create a default CA if needed
	if [ ! -f "${CERTDIR}/${PN}_ca.cert.pem" ]; then
		einfo "No CA key and certificate found in ${CERTDIR}, creating them for you..."
		certtool --generate-privkey \
			--outfile "${CERTDIR}/${PN}_ca.privkey.pem" &>/dev/null
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
			--template "${T}/${PF}.$$" &>/dev/null
		chmod 400 "${CERTDIR}/${PN}_ca.privkey.pem"

		# Create the server certificate
		echo
		einfon "Please type the Common Name of the SERVER you wish to create a certificate for: "
		read -r CN

		einfo "Creating private key and certificate for server ${CN}..."
		certtool --generate-privkey \
			--outfile "${CERTDIR}/${PN}_${CN}.key.pem" &>/dev/null
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
		--outfile "${CERTDIR}/${PN}_${CN}.key.pem" &>/dev/null
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
		--template "${T}/${PF}.$$" &>/dev/null
	chmod 400 "${CERTDIR}/${PN}_${CN}.cert.pem"

	rm -f "${T}/${PF}.$$"

	echo
	einfo "Here is the documentation on how to encrypt your log traffic:"
	einfo " http://www.rsyslog.com/doc/rsyslog_tls.html"
}
