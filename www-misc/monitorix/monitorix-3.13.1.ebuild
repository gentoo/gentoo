# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit systemd optfeature

DESCRIPTION="A lightweight system monitoring tool"
HOMEPAGE="https://www.monitorix.org/"
SRC_URI="https://www.monitorix.org/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

	exeinto /usr/lib/${PN}
	doexe lib/*.pm

	keepdir /var/lib/${PN}/usage
	insinto /var/lib/${PN}/reports
	doins -r reports

	systemd_dounit docs/${PN}.service
}

pkg_postinst() {
	optfeature "disk drive temperatures and health" app-admin/hddtemp
	optfeature "email reports/statics" mail-mta/postfix mail-mta/sendmail
	optfeature "lm-sensors and GPU temperatures" sys-apps/lm-sensors
	optfeature "APC UPS statistics" sys-power/apcupsd
	optfeature "Network UPS Tools statistics" sys-power/nut
	elog
	elog "If you wish to use your own web server:"
	elog "  Web data can be found at: ${EROOT}/var/lib/${PN}/www/"
	elog "  Also please check the correct user and group ownership"
	elog "  of ${EROOT}/var/lib/${PN}/www/imgs/"
}
