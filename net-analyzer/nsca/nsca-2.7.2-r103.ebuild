# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit multilib user eutils

DESCRIPTION="Nagios Service Check Acceptor"
HOMEPAGE="http://www.nagios.org/"
SRC_URI="mirror://sourceforge/nagios/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE="tcpd +crypt minimal"

DEPEND="crypt? ( >=dev-libs/libmcrypt-2.5.1-r4 )
	!minimal? ( tcpd? ( sys-apps/tcp-wrappers ) )"

RDEPEND="${DEPEND}
	!minimal? ( || ( net-analyzer/icinga net-analyzer/nagios ) )
	sys-apps/openrc"

pkg_setup() {
	if ! use minimal; then
		enewgroup nagios
		enewgroup icinga
		enewuser nagios -1 /bin/bash /var/nagios/home nagios
		enewuser icinga -1 -1 /var/lib/icinga "icinga,nagios"
	fi
}

src_configure() {
	use tcpd || export ac_cv_lib_wrap_main=no
	use crypt || export ac_cv_path_LIBMCRYPT_CONFIG=/bin/false

	econf \
		--localstatedir=/var/nagios \
		--sysconfdir=/etc/nagios \
		--with-nsca-user=nagios \
		--with-nsca-grp=nagios
}

src_compile() {
	emake -C src send_nsca $(use minimal || echo nsca)

	# prepare the alternative configuration file
	sed \
		-e '/nsca_\(user\|group\)/s:nagios:icinga:' \
		-e '/nsca_chroot/s:=.*:=/var/lib/icinga/rw:' \
		-e '/\(command\|alternate_dump\)_file/s:/var/nagios:/var/lib/icinga:' \
		"${S}"/sample-config/nsca.cfg > "${T}"/nsca.icinga.cfg
}

src_install() {
	dodoc LEGAL Changelog README SECURITY

	dobin src/send_nsca

	insinto /etc/nagios
	doins "${S}"/sample-config/send_nsca.cfg

	if ! use minimal; then
		exeinto /usr/libexec
		doexe src/nsca

		newinitd "${FILESDIR}"/nsca.init nsca
		newconfd "${FILESDIR}"/nsca.conf nsca

		insinto /etc/nagios
		doins "${S}"/sample-config/nsca.cfg

		insinto /etc/icinga
		newins "${T}"/nsca.icinga.cfg nsca.cfg
	fi
}

pkg_postinst() {
	if ! use minimal; then
		elog "If you are using the nsca daemon, remember to edit"
		elog "the config file /etc/nagios/nsca.cfg"
		elog ""
		elog "If you intend to use nsca with Icinga, change the"
		elog "configuration file path in /etc/conf.d/nsca so that"
		elog "it will default to the correct paths and users."
	fi
}
