# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils user systemd

DESCRIPTION="Versatile Postfix policy server with a flexible ruleset based configuration"
HOMEPAGE="http://www.postfwd.org/"
SRC_URI="http://www.postfwd.org/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+tools"

DEPEND=""
RDEPEND=">=dev-lang/perl-5.16.3
	virtual/perl-Sys-Syslog
	dev-perl/Net-DNS
	dev-perl/Net-Server
"

pkg_setup() {
	enewgroup postfwd
	enewuser postfwd -1 -1 -1 postfwd
}

src_install() {
	local BIN="postfwd2"
	# programs and tools
	dosbin "${S}"/sbin/${BIN}

	# man pages and documentation
	doman "${S}"/man/man8/${BIN}.8
	dodoc "${S}"/doc/{${BIN}.CHANGELOG,${BIN}.txt}

	# example configuration(s)
	insinto /usr/share/doc/${PF}/examples
	newins "${S}"/etc/${PN}.cf.sample ${PN}.cf.dist

	# plugins
	dodoc -r "${S}"/plugins

	# tools
	if use tools; then
		dodoc -r "${S}"/tools
	fi

	# start scripts script and respective configuration file
	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_postinst() {
	einfo
	einfo "${PN} has no default configuration for safety reasons. Every"
	einfo "mail system is different, so you should craft a set of rules"
	einfo "that is suitable for your environment and save it to:"
	einfo "   /etc/postfix/postfwd.cf"
	einfo "You can find example configurations in:"
	einfo "   /usr/share/doc/${PF}/examples"
	einfo
	einfo "If you want ${PN} to start on system boot, you have to add it your"
	einfo "default run level:"
	einfo "   # rc-update add postfwd default"
	einfo "Also remember to edit /etc/conf.d/${PN} to your liking."
	einfo
	einfo "A plugins sampe folder has been placed under:"
	einfo
	einfo "   /usr/share/doc/${PF}/plugins"

	if use tools; then
		einfo
		einfo "You can find additional tools for testing ${PN} in:"
		einfo "   /usr/share/doc/${PF}/tools"
	fi

	ewarn
	ewarn "Please read the documentation carefully and properly test new"
	ewarn "rulesets before putting them into production use. Otherwise you"
	ewarn "risk accidental mail loss or worse."
	ewarn
	ewarn "Visit http://www.postfwd.org/ for more information."
	ewarn
}
