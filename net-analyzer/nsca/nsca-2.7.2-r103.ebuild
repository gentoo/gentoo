# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Nagios Service Check Acceptor"
HOMEPAGE="https://www.nagios.org/"
SRC_URI="https://downloads.sourceforge.net/nagios/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ppc ppc64 sparc x86"
IUSE="tcpd +crypt minimal"

DEPEND="crypt? ( >=dev-libs/libmcrypt-2.5.1-r4 )
	!minimal? (
		tcpd? ( sys-apps/tcp-wrappers )
		acct-group/icinga
		acct-group/nagios
		acct-user/icinga
		acct-user/nagios
	)"
RDEPEND="${DEPEND}
	!minimal? (
		|| (
			net-analyzer/icinga
			net-analyzer/nagios
		)
	)
	|| ( sys-apps/openrc sys-apps/openrc-navi )"

src_configure() {
	use tcpd || export ac_cv_lib_wrap_main=no
	use crypt || export ac_cv_path_LIBMCRYPT_CONFIG=/bin/false

	econf \
		--localstatedir="${EPREFIX}"/var/nagios \
		--sysconfdir="${EPREFIX}"/etc/nagios \
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
		"${S}"/sample-config/nsca.cfg > "${T}"/nsca.icinga.cfg || die
}

src_install() {
	dodoc LEGAL Changelog README SECURITY

	dobin src/send_nsca

	insinto /etc/nagios
	doins sample-config/send_nsca.cfg

	if ! use minimal; then
		exeinto /usr/libexec
		doexe src/nsca

		newinitd "${FILESDIR}"/nsca.init nsca
		newconfd "${FILESDIR}"/nsca.conf nsca

		insinto /etc/nagios
		doins sample-config/nsca.cfg

		insinto /etc/icinga
		newins "${T}"/nsca.icinga.cfg nsca.cfg
	fi
}

pkg_postinst() {
	if ! use minimal; then
		elog "If you are using the nsca daemon, remember to edit"
		elog "the config file /etc/nagios/nsca.cfg"
		elog
		elog "If you intend to use nsca with Icinga, change the"
		elog "configuration file path in /etc/conf.d/nsca so that"
		elog "it will default to the correct paths and users."
	fi
}
