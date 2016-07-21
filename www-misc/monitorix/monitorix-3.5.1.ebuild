# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils systemd user

DESCRIPTION="A lightweight system monitoring tool"
HOMEPAGE="http://www.monitorix.org/"
SRC_URI="http://www.${PN}.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apcupsd hddtemp httpd lm_sensors postfix"

DEPEND="sys-apps/sed"
RDEPEND="dev-perl/Config-General
	dev-perl/DBI
	dev-perl/HTTP-Server-Simple
	dev-perl/IO-Socket-SSL
	dev-perl/libwww-perl
	dev-perl/MIME-Lite
	dev-perl/XML-Simple
	net-analyzer/rrdtool[graph,perl]
	dev-perl/CGI
	apcupsd? ( sys-power/apcupsd )
	hddtemp? ( app-admin/hddtemp )
	httpd? ( virtual/httpd-cgi )
	lm_sensors? ( sys-apps/lm_sensors )
	postfix? ( net-mail/pflogsumm dev-perl/MailTools )"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_prepare() {
	# Put better Gentoo defaults in the configuration file.
	sed -i "s|\(base_dir.*\)/usr/share/${PN}|\1/usr/share/${PN}/htdocs|" ${PN}.conf
	sed -i "s|\(secure_log.*\)/var/log/secure|\1/var/log/auth.log|" ${PN}.conf
	sed -i "s|nobody|${PN}|g" ${PN}.conf
}

src_install() {
	dosbin ${PN}

	newinitd "${FILESDIR}"/${PN}.init ${PN}

	insinto /etc/monitorix
	doins ${PN}.conf

	dodir /etc/${PN}/conf.d

	insinto /etc/logrotate.d
	newins docs/${PN}.logrotate ${PN}

	dodoc Changes README{,.nginx} docs/${PN}.service docs/${PN}-{alert.sh,apache.conf,lighttpd.conf}
	doman man/man5/${PN}.conf.5
	doman man/man8/${PN}.8

	insinto /var/lib/${PN}/www
	doins logo_bot.png logo_top.png ${PN}ico.png

	dodir /var/lib/${PN}/imgs
	dosym /var/lib/${PN}/imgs /var/lib/${PN}/www/imgs

	exeinto /var/lib/${PN}/www/cgi
	doexe ${PN}.cgi

	dodir /usr/lib/${PN}
	exeinto /usr/lib/${PN}
	doexe lib/*.pm

	dodir /var/lib/${PN}/usage
	insinto /var/lib/${PN}/reports
	doins -r reports/*

	systemd_dounit docs/${PN}.service
}

pkg_postinst() {
	chown monitorix:monitorix /var/lib/${PN}/imgs

	elog "WARNING: ${PN} has changed its config format twice, in versions"
	elog "3.0.0 and 3.4.0; this format may be incompatible with your existing"
	elog "config file. Please take care if upgrading from an old version."
	elog ""

	elog "${PN} includes its own web server as of version 3.0.0."
	elog "For this reason, the dependency on the webapp framework"
	elog "has been removed. If you wish to use your own web server,"
	elog "the ${PN} web data can be found at:"
	elog "/var/lib/${PN}/www/"
}
