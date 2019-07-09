# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd user

DESCRIPTION="Versatile Postfix policy server with a flexible ruleset based configuration"
HOMEPAGE="https://www.postfwd.org/"
SRC_URI="https://www.postfwd.org/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=">=dev-lang/perl-5.16.3
	dev-perl/Net-CIDR-Lite
	dev-perl/Net-DNS
	dev-perl/Net-Server
	dev-perl/NetAddr-IP
	virtual/perl-Digest-MD5
	virtual/perl-Storable
	virtual/perl-Sys-Syslog
	virtual/perl-Time-HiRes
"

S=${WORKDIR}/${PN}

pkg_setup() {
	enewgroup postfwd
	enewuser postfwd -1 -1 -1 postfwd
}

src_install() {
	local BIN="postfwd3"
	# program
	dosbin sbin/${BIN}

	# man pages and documentation
	doman man/man8/${BIN}.8
	dodoc doc/{${BIN}.CHANGELOG,${BIN}.txt}

	# example configuration
	dodoc etc/${PN}.cf.sample

	# plugins and tools
	dodoc -r plugins tools

	# start scripts script and respective configuration file
	newinitd "${FILESDIR}"/${PN}.init.3-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.conf.3 ${PN}
	systemd_newunit "${FILESDIR}"/${PN}.service.3 ${PN}.service
}

pkg_postinst() {
	einfo
	einfo "${PN} has no default configuration for safety reasons. Every"
	einfo "mail system is different, so you should craft a set of rules"
	einfo "that is suitable for your environment and save it to:"
	einfo "   ${EROOT}/etc/postfwd.cf"
	einfo "You can find a sample configuration in:"
	einfo "   ${EROOT}/usr/share/doc/${PF}"
	einfo
	einfo "If you want ${PN} to start on system boot, you have to add it your"
	einfo "default run level if using OpenRC:"
	einfo "   # rc-update add postfwd default"
	einfo "Also remember to edit ${EROOT}/etc/conf.d/${PN} to your liking."
	einfo
	einfo "Or - if you are using systemd - enable the service:"
	einfo "   # systemctl enable postfwd"
	einfo
	einfo "A plugins sample folder has been placed under:"
	einfo
	einfo "   ${EROOT}/usr/share/doc/${PF}/plugins"
	einfo
	einfo "You can find additional tools for testing ${PN} in:"
	einfo "   ${EROOT}/usr/share/doc/${PF}/tools"

	ewarn
	ewarn "Please read the documentation carefully and properly test new"
	ewarn "rulesets before putting them into production use. Otherwise you"
	ewarn "risk accidental mail loss or worse."
	ewarn
	ewarn "Visit https://www.postfwd.org/ for more information."
	ewarn
}
