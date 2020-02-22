# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit systemd

DESCRIPTION="A lightweight system monitoring tool"
HOMEPAGE="https://www.monitorix.org/"
SRC_URI="https://www.monitorix.org/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	acct-user/monitorix
	acct-group/monitorix
	dev-perl/Config-General
	dev-perl/DBI
	dev-perl/HTTP-Server-Simple
	dev-perl/IO-Socket-SSL
	dev-perl/libwww-perl
	dev-perl/MIME-Lite
	dev-perl/XML-Simple
	net-analyzer/rrdtool[graph,perl]
	dev-perl/CGI"

src_prepare() {
	# Put better Gentoo defaults in the configuration file.
	sed -e "s|\(base_dir.*\)/usr/share/${PN}|\1/usr/share/${PN}/htdocs|" \
		-e "s|\(secure_log.*\)/var/log/secure|\1/var/log/auth.log|" \
		-e "s|nobody|${PN}|g" -i ${PN}.conf || die
	# Update systemd binary location
	sed -e "s|/usr/bin|/usr/sbin|g" -i docs/${PN}.service || die
	eapply_user
}

# Override compile phase
src_compile() { :; }

src_install() {
	dosbin ${PN}

	newinitd "${FILESDIR}/monitorix" ${PN}

	insinto /etc/monitorix
	doins ${PN}.conf

	keepdir /etc/${PN}/conf.d

	insinto /etc/logrotate.d
	newins docs/${PN}.logrotate ${PN}

	dodoc Changes README{,.nginx} docs/${PN}-{alert.sh,apache.conf,lighttpd.conf}
	doman man/man5/${PN}.conf.5
	doman man/man8/${PN}.8

	insinto /var/lib/${PN}/www
	doins logo_bot.png logo_top.png ${PN}ico.png

	keepdir /var/lib/${PN}/www/imgs
	fowners monitorix:monitorix /var/lib/${PN}/www/imgs

	exeinto /var/lib/${PN}/www/cgi
	doexe ${PN}.cgi

	dodir /usr/lib/${PN}
	exeinto /usr/lib/${PN}
	doexe lib/*.pm

	keepdir /var/lib/${PN}/usage
	insinto /var/lib/${PN}/reports
	doins -r reports

	systemd_dounit docs/${PN}.service
}

pkg_postinst() {
	if has_version '<=www-misc/monitorix-3.5.1' ; then
		ewarn "WARNING: ${PN} has changed its config format twice, in versions"
		ewarn "3.0.0 and 3.4.0; this format may be incompatible with your existing"
		ewarn "config file. Please take care if upgrading from an old version."
		ewarn
		elog "${PN} includes its own web server as of version 3.0.0."
		elog "For this reason, the dependency on the webapp framework"
		elog "has been removed."
		elog
	fi
	elog "Optional dependencies:"
	elog "  app-admin/hddtemp   (disk drive temperatures and health)"
	elog "  mail-mta/postfix    (email reports/statics)"
	elog "  mail-mta/sendmail   (email reports/statics)"
	elog "  sys-apps/lm-sensors (lm-sensors and GPU temperatures)"
	elog "  sys-power/apcupsd   (APC UPS statistics)"
	elog "  sys-power/nut       (Network UPS Tools statistics)"
	elog
	elog "If you wish to use your own web server:"
	elog "  Web data can be found at: ${EROOT}/var/lib/${PN}/www/"
	elog "  Also please check the correct user and group ownership"
	elog "  of ${EROOT}/var/lib/${PN}/www/imgs/"
}
