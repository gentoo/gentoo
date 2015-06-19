# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/syslog-ng/syslog-ng-3.4.8.ebuild,v 1.12 2014/11/02 09:01:28 ago Exp $

EAPI=5
inherit eutils multilib systemd

MY_PV=${PV/_/}
DESCRIPTION="syslog replacement with advanced filtering features"
HOMEPAGE="http://www.balabit.com/network-security/syslog-ng"
SRC_URI="http://www.balabit.com/downloads/files/syslog-ng/sources/${MY_PV}/source/syslog-ng_${MY_PV}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="amqp caps dbi geoip ipv6 json mongodb pacct +pcre smtp spoof-source ssl systemd tcpd"
RESTRICT="test"

RDEPEND="
	pcre? ( dev-libs/libpcre )
	spoof-source? ( net-libs/libnet:1.1 )
	ssl? ( dev-libs/openssl:= )
	smtp? ( net-libs/libesmtp )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	>=dev-libs/eventlog-0.2.12
	>=dev-libs/glib-2.10.1:2
	json? ( >=dev-libs/json-c-0.9 )
	caps? ( sys-libs/libcap )
	geoip? ( >=dev-libs/geoip-1.5.0 )
	dbi? ( >=dev-db/libdbi-0.8.3 )
	systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/flex"

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
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
		--disable-docs \
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
		$(use_enable pcre) \
		$(use_enable smtp) \
		$(use_enable amqp) \
		$(usex amqp --with-librabbitmq-client=internal --without-librabbitmq-client) \
		$(use_enable spoof-source) \
		$(use_enable dbi sql) \
		$(use_enable ssl) \
		$(use_enable tcpd tcp-wrapper)
}

src_install() {
	# -j1 for bug #484470
	emake -j1 DESTDIR="${D}" install

	dodoc AUTHORS NEWS contrib/syslog-ng.conf* contrib/syslog2ng \
		"${FILESDIR}/${PV%.*}/syslog-ng.conf.gentoo.hardened" \
		"${TMPDIR}/syslog-ng.logrotate.hardened" \
		"${FILESDIR}/README.hardened"

	# Install default configuration
	insinto /etc/syslog-ng
	if use userland_BSD ; then
		newins "${FILESDIR}/${PV%.*}/syslog-ng.conf.gentoo.fbsd" syslog-ng.conf
	else
		newins "${FILESDIR}/${PV%.*}/syslog-ng.conf.gentoo" syslog-ng.conf
	fi

	insinto /etc/logrotate.d
	newins "${TMPDIR}/syslog-ng.logrotate" syslog-ng

	newinitd "${FILESDIR}/${PV%.*}/syslog-ng.rc6" syslog-ng
	newconfd "${FILESDIR}/${PV%.*}/syslog-ng.confd" syslog-ng
	keepdir /etc/syslog-ng/patterndb.d /var/lib/syslog-ng
	prune_libtool_files --modules
}

pkg_postinst() {
	elog "For detailed documentation please see the upstream website:"
	elog "http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.4-guides/en/syslog-ng-ose-v3.4-guide-admin/html/index.html"

	# bug #355257
	if ! has_version app-admin/logrotate ; then
		echo
		elog "It is highly recommended that app-admin/logrotate be emerged to"
		elog "manage the log files.  ${PN} installs a file in /etc/logrotate.d"
		elog "for logrotate to use."
		echo
	fi
}
