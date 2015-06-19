# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/shadowircd/shadowircd-6.3.3.ebuild,v 1.3 2013/01/03 11:49:25 ago Exp $

EAPI=4

inherit eutils multilib user

DESCRIPTION="An IRCd based on charybdis that adds several useful features"
HOMEPAGE="http://shadowircd.net"
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug +ipv6 largenet ssl zlib"

RDEPEND="ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/yacc
	sys-devel/flex"

S="${WORKDIR}/${PN}-${P}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 "${EPREFIX}"/usr ${PN}
}

src_prepare() {
	# Fill the example configuration file with proper paths.
	sed -i \
		-e "s:path =.*modules:path = \"$(get_libdir)/${PN}/modules:g" \
		-e "s:etc/:../etc/${PN}/:g" \
		-e "s:logs/:../var/log/shadowircd/:g" \
		-e "s:test\.\(cert\|key\):ssl.\1:g" \
		doc/example.conf \
		doc/reference.conf \
		|| die
}

src_configure() {
	econf \
		ac_cv_prog_cc_g=no \
		--disable-gnutls \
		$(use_enable debug assert soft) \
		$(use_enable debug iodebug) \
		$(use_enable ipv6) \
		$(use_enable !largenet small-net) \
		$(use_enable ssl openssl) \
		$(use_enable zlib) \
		--with-program-prefix=shadowircd- \
		\
		--enable-fhs-paths \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--libdir="${EPREFIX}"/usr/"$(get_libdir)"/${PN} \
		--with-logdir="${EPREFIX}"/var/log/${PN} \
		--with-moduledir="${EPREFIX}"/usr/"$(get_libdir)"/${PN}/modules \
		--with-rundir="${EPREFIX}"/var/run
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	insinto etc/${PN}
	newins doc/reference.conf ircd.conf

	keepdir var/{lib,log}/${PN}

	# Ensure that if `make install' created /var/run/${PN}, we still
	# force the initscript to create that directory.
	rm -rf "${D}"/var/run || die

	# shadowircd needs writing to its state (bandb) and log directories
	fowners :shadowircd /var/{lib,log}/${PN}
	fperms 770 /var/{lib,log}/${PN}

	# ensure that shadowircd can access but not modify its configuration
	# while protecting it from others
	fowners :shadowircd /etc/${PN}{,/ircd.conf}
	fperms 750 /etc/${PN}
	fperms 640 /etc/${PN}/ircd.conf
}

pkg_postinst() {
	elog "All of the shadowircd binaries in PATH have been prefixed with"
	elog "'shadowircd-' to prevent file collisions."
}
