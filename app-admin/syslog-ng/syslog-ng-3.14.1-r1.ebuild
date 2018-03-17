# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit autotools eutils fcaps multilib python-single-r1 systemd versionator

MY_PV=${PV/_/}
MY_PV_MM=$(get_version_component_range 1-2)
DESCRIPTION="syslog replacement with advanced filtering features"
HOMEPAGE="https://syslog-ng.com/open-source-log-management"
SRC_URI="https://github.com/balabit/syslog-ng/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="amqp caps dbi extra-filecaps geoip http ipv6 json libressl mongodb pacct python redis smtp spoof-source systemd tcpd"
REQUIRED_USE="
	extra-filecaps? ( filecaps )
	python? ( ${PYTHON_REQUIRED_USE} )
	caps? ( !filecaps )
"
RESTRICT="test"

RDEPEND="
	amqp? ( >=net-libs/rabbitmq-c-0.8.0 )
	caps? ( sys-libs/libcap )
	dbi? ( >=dev-db/libdbi-0.9.0 )
	geoip? ( >=dev-libs/geoip-1.5.0 )
	http? ( net-misc/curl )
	json? ( >=dev-libs/json-c-0.9:= )
	mongodb? ( >=dev-libs/mongo-c-driver-1.2.0 )
	python? ( ${PYTHON_DEPS} )
	redis? ( >=dev-libs/hiredis-0.11.0 )
	smtp? ( net-libs/libesmtp )
	spoof-source? ( net-libs/libnet:1.1 )
	systemd? ( sys-apps/systemd )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	>=dev-libs/ivykis-0.36.1
	>=dev-libs/libpcre-6.1
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	!dev-libs/eventlog
	>=dev-libs/glib-2.10.1:2"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/patches/${PN}-3.14.1-fix-tls-client.patch"
)

DOCS=( AUTHORS NEWS.md CONTRIBUTING.md contrib/syslog-ng.conf.{HP-UX,RedHat,SunOS,doc}
	contrib/syslog2ng "${FILESDIR}/${MY_PV_MM}/syslog-ng.conf.gentoo.hardened"
	"${T}/syslog-ng.logrotate.hardened" "${FILESDIR}/README.hardened" )

S=${WORKDIR}/${PN}-${MY_PV}

pkg_setup() {
	use python && python-single-r1_pkg_setup
	if use caps; then
		ewarn "\"caps\" USE flag is only useful for limiting privileges when running syslog-ng as root."
		ewarn "If you prefer running syslog-ng as a non-root user use \"filecaps\" instead."
	fi
}

src_prepare() {
	local f

	use python && python_fix_shebang .

	# remove bundled libs
	rm -rv lib/ivykis modules/afmongodb/mongo-c-driver modules/afamqp/rabbitmq-c || die

	# drop scl modules requiring json
	if use !json; then
		sed -i -r '/cim|ewmm|graylog2/d' scl/Makefile.am || die
	fi

	# use gentoo default path
	if use systemd; then
		sed -e 's@/etc/syslog-ng.conf@/etc/syslog-ng/syslog-ng.conf@g;s@/var/run@/run@g' \
			-i contrib/systemd/syslog-ng@default || die
	fi

	for f in "${FILESDIR}"/*logrotate*.in ; do
		local bn=$(basename "${f}")

		sed \
			-e "$(usex systemd \
				's/@GENTOO_RESTART@/systemctl kill -s HUP syslog-ng@default/' \
				's:@GENTOO_RESTART@:/etc/init.d/syslog-ng reload:')" \
			"${f}" > "${T}/${bn/.in/}" || die
	done

	default

	eautoreconf
}

src_configure() {
	econf \
		--disable-docs \
		--disable-java \
		--disable-java-modules \
		--disable-riemann \
		--enable-manpages \
		--localstatedir=/var/lib/syslog-ng \
		--sysconfdir=/etc/syslog-ng \
		--with-embedded-crypto \
		--with-ivykis=system \
		--with-module-dir=/usr/$(get_libdir)/syslog-ng \
		--with-pidfile-dir=/var/run \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		$(use_enable amqp) \
		$(usex amqp --with-librabbitmq-client=system --without-librabbitmq-client) \
		$(use_enable caps linux-caps) \
		$(use_enable dbi sql) \
		$(use_enable geoip) \
		$(use_enable http) \
		$(use_enable ipv6) \
		$(use_enable json) \
		$(use_enable mongodb) \
		$(usex mongodb --with-mongoc=system "--without-mongoc --disable-legacy-mongodb-options") \
		$(use_enable pacct) \
		$(use_enable python) \
		$(use_enable redis) \
		$(use_enable smtp) \
		$(use_enable spoof-source) \
		$(use_enable systemd) \
		$(use_enable tcpd tcp-wrapper)
}

src_install() {
	default

	# Install default configuration
	insinto /etc/default
	doins contrib/systemd/syslog-ng@default

	insinto /etc/syslog-ng
	if use userland_BSD ; then
		newins "${FILESDIR}/${MY_PV_MM}/syslog-ng.conf.gentoo.fbsd" syslog-ng.conf
	else
		newins "${FILESDIR}/${MY_PV_MM}/syslog-ng.conf.gentoo" syslog-ng.conf
	fi

	insinto /etc/logrotate.d
	newins "${T}/syslog-ng.logrotate" syslog-ng
	newinitd "${FILESDIR}/${MY_PV_MM}/syslog-ng.rc" syslog-ng
	newconfd "${FILESDIR}/${MY_PV_MM}/syslog-ng.confd" syslog-ng
	keepdir /etc/syslog-ng/patterndb.d /var/lib/syslog-ng
	prune_libtool_files --modules

	use python && python_optimize
}

pkg_postinst() {
	if use filecaps; then
		enewuser syslog-ng

		# Capabilities, see 'man capabilities 7' for more info:
		#
		# 'cap_syslog' is required to read /proc/kmsg, if disabled syslog-ng fails with these errors:
		# 	Error opening file for reading; filename='/proc/kmsg', error='Operation not permitted (1)'
		# 	Error initializing message pipeline;
		#
		# 'cap_dac_override' is required to read /dev/log, if disabled syslog-ng fails with these errors:
		# 	Error binding socket; addr='AF_UNIX(/dev/log)', error='Address already in use (98)'
		# 	Error initializing message pipeline;
		#
		# 'cap_chown' is required to change owners of logs

		# enable minimal required for standalone logger capabilities
		logger_caps='cap_chown,cap_dac_override,cap_syslog'

		if use pacct; then
			logger_caps+='cap_pacct'
		fi
		# enable all capabilities from syslog-ng/main.c BASE_CAPS
		use extra-filecaps && logger_caps+='cap_dac_read_search,cap_net_bind_service,cap_net_broadcast,cap_net_raw'

		chown root:syslog-ng "${EROOT}"/usr/sbin/syslog-ng || die
		fcaps -o root -g syslog-ng -m 4710 -M 0710 "${logger_caps}+ep" /usr/sbin/syslog-ng
	fi

	# bug #355257
	if ! has_version app-admin/logrotate ; then
		echo
		elog "It is highly recommended that app-admin/logrotate be emerged to"
		elog "manage the log files.  ${PN} installs a file in /etc/logrotate.d"
		elog "for logrotate to use."
		echo
	fi

	if use systemd; then
		echo
		ewarn "The service file for systemd has changed to support multiple instances."
		ewarn "To start the default instance issue:"
		ewarn "# systemctl start syslog-ng@default"
		echo
	fi
}
