# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit autotools python-any-r1 eutils multilib systemd versionator

MY_PV=${PV/_/}
MY_PV_MM=$(get_version_component_range 1-2)
DESCRIPTION="syslog replacement with advanced filtering features"
HOMEPAGE="http://www.balabit.com/network-security/syslog-ng"
SRC_URI="https://github.com/balabit/syslog-ng/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="amqp caps dbi geoip ipv6 json libressl mongodb pacct python redis smtp spoof-source systemd tcpd"
RESTRICT="test"

RDEPEND="
	caps? ( sys-libs/libcap )
	dbi? ( >=dev-db/libdbi-0.8.3 )
	geoip? ( >=dev-libs/geoip-1.5.0 )
	json? ( >=dev-libs/json-c-0.9 )
	python? ( ${PYTHON_DEPS} )
	redis? ( dev-libs/hiredis )
	smtp? ( net-libs/libesmtp )
	spoof-source? ( net-libs/libnet:1.1 )
	systemd? ( sys-apps/systemd )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	dev-libs/libpcre
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
	>=dev-libs/eventlog-0.2.12
	>=dev-libs/glib-2.10.1:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/flex"

S=${WORKDIR}/${PN}-${MY_PV}

pkg_setup() {
	use python && python-any-r1_pkg_setup
}

src_prepare() {
	epatch_user
	use python && python_fix_shebang .

	if use !json ; then
		sed -i \
			-e '1 s/cim //' \
			scl/Makefile.am || die
		eautoreconf
	fi

	cp "${FILESDIR}"/*logrotate*.in "${TMPDIR}" || die
	cd "${TMPDIR}" || die

	for f in *logrotate*.in ; do
		if use systemd ; then
			sed \
				's/@GENTOO_RESTART@/systemctl kill -s HUP syslog-ng/' \
				$f > ${f/.in/} || die
		else
			sed \
				's:@GENTOO_RESTART@:/etc/init.d/syslog-ng reload:' \
				$f > ${f/.in/} || die
		fi
	done
}

src_configure() {
	econf \
		--disable-java \
		--disable-docs \
		--enable-manpages \
		--with-embedded-crypto \
		--with-ivykis=internal \
		--with-libmongo-client=internal \
		--sysconfdir=/etc/syslog-ng \
		--localstatedir=/var/lib/syslog-ng \
		--with-pidfile-dir=/var/run \
		--with-module-dir=/usr/$(get_libdir)/syslog-ng \
		$(systemd_with_unitdir) \
		$(use_enable systemd) \
		$(use_enable caps linux-caps) \
		$(use_enable geoip) \
		$(use_enable ipv6) \
		$(use_enable json) \
		$(use_enable mongodb) \
		$(use_enable pacct) \
		$(use_enable python) \
		$(use_enable redis) \
		$(use_enable smtp) \
		$(use_enable amqp) \
		$(usex amqp --with-librabbitmq-client=internal --without-librabbitmq-client) \
		$(use_enable spoof-source) \
		$(use_enable dbi sql) \
		$(use_enable tcpd tcp-wrapper)
}

src_install() {
	# -j1 for bug #484470
	emake -j1 DESTDIR="${D}" install

	dodoc AUTHORS NEWS.md CONTRIBUTING.md contrib/syslog-ng.conf* \
		contrib/syslog2ng "${FILESDIR}/${MY_PV_MM}/syslog-ng.conf.gentoo.hardened" \
		"${TMPDIR}/syslog-ng.logrotate.hardened" "${FILESDIR}/README.hardened"

	# Install default configuration
	insinto /etc/syslog-ng
	if use userland_BSD ; then
		newins "${FILESDIR}/${MY_PV_MM}/syslog-ng.conf.gentoo.fbsd" syslog-ng.conf
	else
		newins "${FILESDIR}/${MY_PV_MM}/syslog-ng.conf.gentoo" syslog-ng.conf
	fi

	insinto /etc/logrotate.d
	newins "${TMPDIR}/syslog-ng.logrotate" syslog-ng

	newinitd "${FILESDIR}/${MY_PV_MM}/syslog-ng.rc6" syslog-ng
	newconfd "${FILESDIR}/${MY_PV_MM}/syslog-ng.confd" syslog-ng
	keepdir /etc/syslog-ng/patterndb.d /var/lib/syslog-ng
	prune_libtool_files --modules

	use python && python_optimize
}

pkg_postinst() {
	elog "For detailed documentation please see the upstream website:"
	elog "http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.7-guides/en/syslog-ng-ose-v3.7-guide-admin/html/index.html"

	# bug #355257
	if ! has_version app-admin/logrotate ; then
		echo
		elog "It is highly recommended that app-admin/logrotate be emerged to"
		elog "manage the log files.  ${PN} installs a file in /etc/logrotate.d"
		elog "for logrotate to use."
		echo
	fi
}
