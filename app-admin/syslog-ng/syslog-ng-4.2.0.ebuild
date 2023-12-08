# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit autotools python-single-r1 systemd

MY_PV_MM=$(ver_cut 1-2)
DESCRIPTION="syslog replacement with advanced filtering features"
HOMEPAGE="https://www.syslog-ng.com/products/open-source-log-management/"
SRC_URI="https://github.com/balabit/syslog-ng/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="amqp caps dbi geoip2 http ipv6 json kafka mongodb pacct python redis smtp snmp test spoof-source systemd tcpd"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	test? ( python )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.10.1:2
	>=dev-libs/ivykis-0.42.4
	>=dev-libs/libpcre-6.1
	dev-libs/openssl:0=
	!dev-libs/eventlog
	amqp? ( >=net-libs/rabbitmq-c-0.8.0:=[ssl] )
	caps? ( sys-libs/libcap )
	dbi? ( >=dev-db/libdbi-0.9.0 )
	geoip2? ( dev-libs/libmaxminddb:= )
	http? ( net-misc/curl )
	json? ( >=dev-libs/json-c-0.9:= )
	kafka? ( >=dev-libs/librdkafka-1.0.0:= )
	mongodb? ( >=dev-libs/mongo-c-driver-1.2.0 )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
	)
	redis? ( >=dev-libs/hiredis-0.11.0:= )
	smtp? ( net-libs/libesmtp:= )
	snmp? ( net-analyzer/net-snmp:0= )
	spoof-source? ( net-libs/libnet:1.1 )
	systemd? ( sys-apps/systemd:= )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )"
DEPEND="${RDEPEND}
	test? ( dev-libs/criterion )"
BDEPEND="
	>=sys-devel/bison-3.7.6
	sys-devel/flex
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS.md CONTRIBUTING.md contrib/syslog-ng.conf.{HP-UX,RedHat,SunOS,doc}
	contrib/syslog2ng "${T}/syslog-ng.conf.gentoo.hardened"
	"${T}/syslog-ng.logrotate.hardened" "${FILESDIR}/README.hardened" )
PATCHES=(
	"${FILESDIR}"/${PN}-3.28.1-net-snmp.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	local f

	# disable python-modules test as it requires additional python modules not
	# packaged in Gentoo
	sed -i '/MAKE/s/.*/exit 0/g' modules/python-modules/test_pymodules.sh || die

	use python && python_fix_shebang .

	# remove bundled libs
	rm -r lib/ivykis || die

	# drop scl modules requiring json
	if use !json; then
		sed -i -r '/cim|elasticsearch|ewmm|graylog2|loggly|logmatic|netskope|nodejs|osquery|slack/d' scl/Makefile.am || die
	fi

	# drop scl modules requiring http
	if use !http; then
		sed -i -r '/slack|telegram/d' scl/Makefile.am || die
	fi

	# use gentoo default path
	if use systemd; then
		sed -e 's@/etc/syslog-ng.conf@/etc/syslog-ng/syslog-ng.conf@g;s@/var/run@/run@g' \
			-i contrib/systemd/syslog-ng@default || die
	fi

	for f in syslog-ng.logrotate.hardened.in syslog-ng.logrotate.in; do
		sed \
			-e "s#@GENTOO_RESTART@#$(usex systemd "systemctl kill -s HUP syslog-ng@default" \
				"/etc/init.d/syslog-ng reload")#g" \
			"${FILESDIR}/${f}" > "${T}/${f/.in/}" || die
	done

	for f in syslog-ng.conf.gentoo.hardened.in-r1 \
			syslog-ng.conf.gentoo.in-r1; do
		sed -e "s/@SYSLOGNG_VERSION@/${MY_PV_MM}/g" "${FILESDIR}/${f}" > "${T}/${f/.in-r1/}" || die
	done

	default
	eautoreconf
}

src_configure() {
	# Needs bison/flex.
	unset YACC LEX

	local myconf=(
		--disable-docs
		--disable-java
		--disable-java-modules
		--disable-riemann
		--enable-manpages
		--localstatedir=/var/lib/syslog-ng
		--sysconfdir=/etc/syslog-ng
		--with-embedded-crypto
		--with-ivykis=system
		--with-module-dir=/usr/$(get_libdir)/syslog-ng
		--with-pidfile-dir=/var/run
		--with-python-packages=none
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(use_enable amqp)
		$(usex amqp --with-librabbitmq-client=system --without-librabbitmq-client)
		$(use_enable caps linux-caps)
		$(use_enable dbi sql)
		$(use_enable geoip2)
		$(use_enable http)
		$(use_enable ipv6)
		$(use_enable json)
		$(use_enable kafka)
		$(use_enable mongodb)
		$(usex mongodb --with-mongoc=system "--without-mongoc --disable-legacy-mongodb-options")
		$(use_enable pacct)
		$(use_enable python)
		$(use_enable redis)
		$(use_enable smtp)
		$(use_enable snmp afsnmp)
		$(use_enable spoof-source)
		$(use_enable systemd)
		$(use_enable tcpd tcp-wrapper)
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	# Install default configuration
	insinto /etc/default
	doins contrib/systemd/syslog-ng@default

	insinto /etc/syslog-ng
	newins "${T}/syslog-ng.conf.gentoo" syslog-ng.conf

	insinto /etc/logrotate.d
	newins "${T}/syslog-ng.logrotate" syslog-ng

	newinitd "${FILESDIR}/syslog-ng.rc" syslog-ng
	newconfd "${FILESDIR}/syslog-ng.confd" syslog-ng
	keepdir /etc/syslog-ng/patterndb.d /var/lib/syslog-ng
	find "${D}" -name '*.la' -delete || die

	use python && python_optimize
}

pkg_postinst() {
	# bug #355257
	if ! has_version app-admin/logrotate ; then
		elog "It is highly recommended that app-admin/logrotate be emerged to"
		elog "manage the log files.  ${PN} installs a file in /etc/logrotate.d"
		elog "for logrotate to use."
	fi

	if use systemd; then
		ewarn "The service file for systemd has changed to support multiple instances."
		ewarn "To start the default instance issue:"
		ewarn "# systemctl start syslog-ng@default"
	fi
}
