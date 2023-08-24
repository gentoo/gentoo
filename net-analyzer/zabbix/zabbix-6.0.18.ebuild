# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# To create the go modules tarball:
#   cd src/go
#   GOMODCACHE="${PWD}"/go-mod go mod download -modcacherw
#   tar -acf zabbix-${PV}-go-deps.tar.xz go-mod

EAPI=8

GO_OPTIONAL="yes"
# needed to make webapp-config dep optional
WEBAPP_OPTIONAL="yes"
inherit webapp java-pkg-opt-2 systemd tmpfiles toolchain-funcs go-module user-info

DESCRIPTION="ZABBIX is software for monitoring of your applications, network and servers"
HOMEPAGE="https://www.zabbix.com/"
MY_P=${P/_/}
MY_PV=${PV/_/}
SRC_URI="https://cdn.zabbix.com/${PN}/sources/stable/$(ver_cut 1-2)/${P}.tar.gz
	agent2? ( https://dev.gentoo.org/~fordfrog/distfiles/${P}-go-deps.tar.xz )
"

LICENSE="GPL-2"
SLOT="0/$(ver_cut 1-2)"
WEBAPP_MANUAL_SLOT="yes"
KEYWORDS="amd64 x86"
IUSE="agent +agent2 curl frontend gnutls ipv6 java ldap libxml2 mysql odbc openipmi +openssl oracle +postgres proxy selinux server snmp sqlite ssh static"
REQUIRED_USE="|| ( agent agent2 frontend proxy server )
	?? ( gnutls openssl )
	agent2? ( !gnutls )
	proxy? ( ^^ ( mysql oracle postgres sqlite ) )
	server? ( ^^ ( mysql oracle postgres ) !sqlite )
	static? ( !oracle !snmp )"

COMMON_DEPEND="
	curl? ( net-misc/curl )
	gnutls? ( net-libs/gnutls:0= )
	java? ( >=virtual/jdk-1.8:* )
	ldap? (
		=dev-libs/cyrus-sasl-2*
		net-libs/gnutls:=
		net-nds/openldap:=
	)
	libxml2? ( dev-libs/libxml2 )
	mysql? ( dev-db/mysql-connector-c:= )
	odbc? ( dev-db/unixODBC )
	openipmi? ( sys-libs/openipmi )
	openssl? ( dev-libs/openssl:=[-bindist(-)] )
	oracle? ( dev-db/oracle-instantclient[odbc,sdk] )
	postgres? ( dev-db/postgresql:* )
	proxy?  (
		dev-libs/libevent:=
		sys-libs/zlib
	)
	server? (
		dev-libs/libevent:=
		sys-libs/zlib
	)
	snmp? ( net-analyzer/net-snmp:= )
	sqlite? ( dev-db/sqlite )
	ssh? ( net-libs/libssh2 )
"

RDEPEND="${COMMON_DEPEND}
	acct-group/zabbix
	acct-user/zabbix
	java? ( >=virtual/jre-1.8:* )
	mysql? ( virtual/mysql )
	proxy? (
		dev-libs/libpcre2:=
		net-analyzer/fping[suid]
	)
	selinux? ( sec-policy/selinux-zabbix )
	server? (
		app-admin/webapp-config
		dev-libs/libpcre2:=
		net-analyzer/fping[suid]
	)
	frontend? (
		app-admin/webapp-config
		dev-lang/php:*[bcmath,ctype,sockets,gd,truetype,xml,session,xmlreader,xmlwriter,nls,sysvipc,unicode]
		media-libs/gd[png]
		virtual/httpd-php:*
		mysql? ( dev-lang/php[mysqli] )
		odbc? ( dev-lang/php[odbc] )
		oracle? ( dev-lang/php[oci8-instant-client] )
		postgres? ( dev-lang/php[postgres] )
		sqlite? ( dev-lang/php[sqlite] )
	)
"
DEPEND="${COMMON_DEPEND}
	static? (
		curl? ( net-misc/curl[static-libs] )
		ldap? (
			=dev-libs/cyrus-sasl-2*[static-libs]
			net-libs/gnutls[static-libs]
			net-nds/openldap[static-libs]
		)
		libxml2? ( dev-libs/libxml2[static-libs] )
		mysql? ( dev-db/mysql-connector-c[static-libs] )
		odbc? ( dev-db/unixODBC[static-libs] )
		postgres? ( dev-db/postgresql:*[static-libs] )
		sqlite? ( dev-db/sqlite[static-libs] )
		ssh? ( net-libs/libssh2 )
	)
"
BDEPEND="
	virtual/pkgconfig
	agent2? (
		>=dev-lang/go-1.12
		app-arch/unzip
	)
"

# upstream tests fail for agent2
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.18-modulepathfix.patch"
	"${FILESDIR}/${PN}-3.0.30-security-disable-PidFile.patch"
	"${FILESDIR}/${PN}-6.0.3-system.sw.packages.patch"
)

S=${WORKDIR}/${MY_P}

ZABBIXJAVA_BASE="opt/zabbix_java"

pkg_setup() {
	if use oracle; then
		if [ -z "${ORACLE_HOME}" ]; then
			eerror
			eerror "The environment variable ORACLE_HOME must be set"
			eerror "and point to the correct location."
			eerror "It looks like you don't have Oracle installed."
			eerror
			die "Environment variable ORACLE_HOME is not set"
		fi
	fi

	if use frontend; then
		webapp_pkg_setup
	fi

	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	default
}

src_configure() {
	local econf_args=(
		--with-libpcre2
		"$(use_enable agent)"
		"$(use_enable agent2)"
		"$(use_enable ipv6)"
		"$(use_enable java)"
		"$(use_enable proxy)"
		"$(use_enable server)"
		"$(use_enable static)"
		"$(use_with curl libcurl)"
		"$(use_with gnutls)"
		"$(use_with ldap)"
		"$(use_with libxml2)"
		"$(use_with mysql)"
		"$(use_with odbc unixodbc)"
		"$(use_with openipmi openipmi)"
		"$(use_with openssl)"
		"$(use_with oracle)"
		"$(use_with postgres postgresql)"
		"$(use_with snmp net-snmp)"
		"$(use_with sqlite sqlite3)"
		"$(use_with ssh ssh2)"
	)

	econf ${econf_args[@]}
}

src_compile() {
	if [ -f Makefile ] || [ -f GNUmakefile ] || [ -f makefile ]; then
		emake AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"
	fi
}

src_install() {
	local dirs=(
		/etc/zabbix
		/var/lib/zabbix
		/var/lib/zabbix/home
		/var/lib/zabbix/scripts
		/var/lib/zabbix/alertscripts
		/var/lib/zabbix/externalscripts
		/var/log/zabbix
	)

	for dir in "${dirs[@]}"; do
		keepdir "${dir}"
	done

	if use server; then
		insinto /etc/zabbix
		doins "${S}"/conf/zabbix_server.conf
		fperms 0640 /etc/zabbix/zabbix_server.conf
		fowners root:zabbix /etc/zabbix/zabbix_server.conf

		newinitd "${FILESDIR}"/zabbix-server-r1.init zabbix-server

		dosbin src/zabbix_server/zabbix_server

		insinto /usr/share/zabbix
		doins -r "${S}"/database/

		systemd_dounit "${FILESDIR}"/zabbix-server.service
		newtmpfiles "${FILESDIR}"/zabbix-server.tmpfiles zabbix-server.conf
	fi

	if use proxy; then
		insinto /etc/zabbix
		doins "${S}"/conf/zabbix_proxy.conf
		fperms 0640 /etc/zabbix/zabbix_proxy.conf
		fowners root:zabbix /etc/zabbix/zabbix_proxy.conf

		newinitd "${FILESDIR}"/zabbix-proxy.init zabbix-proxy

		dosbin src/zabbix_proxy/zabbix_proxy

		insinto /usr/share/zabbix
		doins -r "${S}"/database/

		systemd_dounit "${FILESDIR}"/zabbix-proxy.service
		newtmpfiles "${FILESDIR}"/zabbix-proxy.tmpfiles zabbix-proxy.conf
	fi

	if use agent; then
		insinto /etc/zabbix
		doins "${S}"/conf/zabbix_agentd.conf
		fperms 0640 /etc/zabbix/zabbix_agentd.conf
		fowners root:zabbix /etc/zabbix/zabbix_agentd.conf

		newinitd "${FILESDIR}"/zabbix-agentd.init zabbix-agentd

		dosbin src/zabbix_agent/zabbix_agentd
		dobin \
			src/zabbix_sender/zabbix_sender \
			src/zabbix_get/zabbix_get

		systemd_dounit "${FILESDIR}"/zabbix-agentd.service
		newtmpfiles "${FILESDIR}"/zabbix-agentd.tmpfiles zabbix-agentd.conf
	fi
	if use agent2; then
		insinto /etc/zabbix
		doins "${S}"/src/go/conf/zabbix_agent2.conf
		fperms 0640 /etc/zabbix/zabbix_agent2.conf
		fowners root:zabbix /etc/zabbix/zabbix_agent2.conf
		keepdir /etc/zabbix/zabbix_agent2.d/plugins.d

		newinitd "${FILESDIR}"/zabbix-agent2.init zabbix-agent2

		dosbin src/go/bin/zabbix_agent2

		systemd_dounit "${FILESDIR}"/zabbix-agent2.service
		newtmpfiles "${FILESDIR}"/zabbix-agent2.tmpfiles zabbix-agent2.conf
	fi

	fowners root:zabbix /etc/zabbix
	fowners zabbix:zabbix \
		/var/lib/zabbix \
		/var/lib/zabbix/home \
		/var/lib/zabbix/scripts \
		/var/lib/zabbix/alertscripts \
		/var/lib/zabbix/externalscripts \
		/var/log/zabbix
	fperms 0750 \
		/etc/zabbix \
		/var/lib/zabbix \
		/var/lib/zabbix/home \
		/var/lib/zabbix/scripts \
		/var/lib/zabbix/alertscripts \
		/var/lib/zabbix/externalscripts \
		/var/log/zabbix

	dodoc README INSTALL NEWS ChangeLog \
		conf/zabbix_agentd.conf \
		conf/zabbix_proxy.conf \
		conf/zabbix_agentd/userparameter_examples.conf \
		conf/zabbix_agentd/userparameter_mysql.conf \
		conf/zabbix_server.conf

	if use frontend; then
		webapp_src_preinst
		cp -R ui/* "${D}/${MY_HTDOCSDIR}"
		webapp_configfile \
			"${MY_HTDOCSDIR}"/include/db.inc.php \
			"${MY_HTDOCSDIR}"/include/config.inc.php
		webapp_src_install
	fi

	if use java; then
		dodir \
			/${ZABBIXJAVA_BASE} \
			/${ZABBIXJAVA_BASE}/bin \
			/${ZABBIXJAVA_BASE}/lib
		keepdir /${ZABBIXJAVA_BASE}
		exeinto /${ZABBIXJAVA_BASE}/bin
		doexe src/zabbix_java/bin/zabbix-java-gateway-"${MY_PV}".jar
		exeinto /${ZABBIXJAVA_BASE}/lib
		doexe \
			src/zabbix_java/lib/logback-classic-1.2.9.jar \
			src/zabbix_java/lib/logback-console.xml \
			src/zabbix_java/lib/logback-core-1.2.9.jar \
			src/zabbix_java/lib/logback.xml \
			src/zabbix_java/lib/android-json-4.3_r3.1.jar \
			src/zabbix_java/lib/slf4j-api-1.7.32.jar
		newinitd "${FILESDIR}"/zabbix-jmx-proxy.init zabbix-jmx-proxy
		newconfd "${FILESDIR}"/zabbix-jmx-proxy.conf zabbix-jmx-proxy
	fi
}

pkg_postinst() {
	if use server || use proxy ; then
		elog
		elog "You may need to configure your database for Zabbix"
		elog "if you have not already done so."
		elog

		zabbix_homedir=$(egethome zabbix)
		if [ -n "${zabbix_homedir}" ] && \
			[ "${zabbix_homedir}" != "/var/lib/zabbix/home" ]; then
			ewarn
			ewarn "The user 'zabbix' should have his homedir changed"
			ewarn "to /var/lib/zabbix/home if you want to use"
			ewarn "custom alert scripts."
			ewarn
			ewarn "A real homedir might be needed for configfiles"
			ewarn "for custom alert scripts."
			ewarn
			ewarn "To change the homedir use:"
			ewarn "  usermod -d /var/lib/zabbix/home zabbix"
			ewarn
		fi
	fi

	if use server; then
		tmpfiles_process zabbix-server.conf

		elog
		elog "For distributed monitoring you have to run:"
		elog
		elog "zabbix_server -n <nodeid>"
		elog
		elog "This will convert database data for use with Node ID"
		elog "and also adds a local node."
		elog
	fi

	if use proxy; then
		tmpfiles_process zabbix-proxy.conf
	fi

	if use agent; then
		tmpfiles_process zabbix-agentd.conf
	fi

	if use agent2; then
		tmpfiles_process zabbix-agent2.conf
	fi

	elog "--"
	elog
	elog "You may need to add these lines to /etc/services:"
	elog
	elog "zabbix-agent     10050/tcp Zabbix Agent"
	elog "zabbix-agent     10050/udp Zabbix Agent"
	elog "zabbix-trapper   10051/tcp Zabbix Trapper"
	elog "zabbix-trapper   10051/udp Zabbix Trapper"
	elog

	if use server || use proxy ; then
		# check for fping
		fping_perms=$(stat -c %a /usr/sbin/fping 2>/dev/null)
		case "${fping_perms}" in
			4[157][157][157])
				;;
			*)
				ewarn
				ewarn "If you want to use the checks 'icmpping' and 'icmppingsec',"
				ewarn "you have to make /usr/sbin/fping setuid root and executable"
				ewarn "by everyone. Run the following command to fix it:"
				ewarn
				ewarn "  chmod u=rwsx,g=rx,o=rx /usr/sbin/fping"
				ewarn
				ewarn "Please be aware that this might impose a security risk,"
				ewarn "depending on the code quality of fping."
				ewarn
				;;
		esac
	fi
}

pkg_prerm() {
	(use frontend || use server) && webapp_pkg_prerm
}
