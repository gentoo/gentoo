# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/ptlink-ircd/ptlink-ircd-6.19.6-r2.ebuild,v 1.1 2015/03/21 13:55:32 jlec Exp $

EAPI=5

inherit eutils ssl-cert user

MY_P="PTlink${PV}"

DESCRIPTION="Secure IRC daemon with many advanced features"
HOMEPAGE="http://www.ptlink.net/"
SRC_URI="ftp://ftp.sunsite.dk/projects/ptlink/ircd/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~sparc ~x86"
IUSE="ssl"

DEPEND="
	sys-libs/zlib
	ssl? ( dev-libs/openssl:0= )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	ecvs_clean
}

src_configure() {
	econf \
		--disable-ipv6 \
		$(use_with ssl ssl openssl)
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	newbin src/ircd ptlink-ircd
	newbin tools/fixklines ptlink-ircd-fixklines
	newbin tools/mkpasswd ptlink-ircd-mkpasswd

	insinto /etc/ptlink-ircd
	fperms 700 /etc/ptlink-ircd
	doins samples/{kline.conf,{opers,ptlink}.motd,help.{admin,oper,user}}
	newins samples/example.conf.short ircd.conf
	newins samples/example.conf.trillian ircd.conf.trillian
	newins samples/main.dconf.sample main.dconf
	newins samples/network.dconf.sample network.dconf

	insinto /usr/share/ptlink-ircd/codepage
	doins src/codepage/*.enc
	dosym /usr/share/ptlink-ircd/codepage /etc/ptlink-ircd/codepage

	rm -rf doc/old
	dodoc doc/* doc_hybrid6/* ircdcron/* CHANGES README

	keepdir /var/log/ptlink-ircd /var/lib/ptlink-ircd
	dosym /var/log/ptlink-ircd /var/lib/ptlink-ircd/log

	newinitd "${FILESDIR}/ptlink-ircd.initd" ptlink-ircd
	newconfd "${FILESDIR}/ptlink-ircd.confd" ptlink-ircd
}

pkg_postinst() {
	# Move docert from src_install() to install_cert for bug #201678
	use ssl && (
		if [[ ! -f "${ROOT}"/etc/ptlink-ircd/server.key.pem ]]; then
			install_cert /etc/ptlink-ircd/server || die "install_cert failed"
			mv "${ROOT}"/etc/ptlink-ircd/server.{crt,cert.pem}
			mv "${ROOT}"/etc/ptlink-ircd/server.{csr,req.pem}
			mv "${ROOT}"/etc/ptlink-ircd/server.key{,.pem}
		fi
	)

	enewuser ptlink-ircd

	chown ptlink-ircd \
		"${ROOT}"/{etc,var/{log,lib}}/ptlink-ircd \
		"${ROOT}"/etc/ptlink-ircd/server.key.pem

	echo
	elog "PTlink IRCd will run without configuration, although this is strongly"
	elog "advised against."
	echo
	elog "You can find example cron script ircd.cron here:"
	elog "   /usr/share/doc/${PF}"
	echo
	elog "You can also use /etc/init.d/ptlink-ircd to start at boot"
	echo
}
