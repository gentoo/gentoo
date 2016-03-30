# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils user

DESCRIPTION="Web UI based monitoring tool for Aerospike Community Edition Server"
HOMEPAGE="http://www.aerospike.com"
SRC_URI="http://www.aerospike.com/artifacts/${PN}/${PV}/${P}.all.x86_64.deb"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="app-crypt/gcr
	dev-python/eventlet
	dev-python/flask
	dev-python/greenlet
	dev-python/setproctitle
	www-servers/gunicorn"
DEPEND="${RDEPEND}"

src_unpack() {
	default
	mkdir "${P}"
	tar -xf data.tar.xz -C "${S}" || die
	tar -xzf "${S}"/opt/amc.tar.gz -C "${S}"/opt/ || die
}

src_install() {
	mv opt/amc/amc/* opt/amc/
	rm -rf opt/amc/amc
	rm -f opt/amc/install
	rm -f opt/amc/bin/uninstall
	rm -f opt/amc/bin/amc_*.sh
	rm -f opt/amc/bin/gunicorn
	rm -rf opt/amc/server/site-packages/
	rm -rf opt/amc/server/setups/

	insinto /etc/logrotate.d
	newins opt/amc/config/logrotate amc
	rm -f opt/amc/config/logrotate

	insinto /etc/cron.daily
	newins opt/amc/config/logcron amc
	rm -f opt/amc/config/logcron

	sed -e 's@/tmp/amc.pid@/run/amc.pid@g' -i opt/amc/config/gunicorn_config.py || die

	insinto /etc/amc/config
	doins -r opt/amc/config/*
	rm -rf opt/amc/config/

	echo "${PV}" > opt/amc/amc_version

	insinto /opt/amc/
	doins -r opt/amc/*

	keepdir /var/log/amc

	newinitd "${FILESDIR}"/amc.init amc
}
