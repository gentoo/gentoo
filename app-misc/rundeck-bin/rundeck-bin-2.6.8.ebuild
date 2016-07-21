# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils java-pkg-2 rpm user

DESCRIPTION="Job Scheduler and Runbook Automation"
HOMEPAGE="http://www.rundeck.org"
SRC_URI="http://download.rundeck.org/rpm/rundeck-${PV}-1.20.GA.noarch.rpm
	http://download.rundeck.org/rpm/rundeck-config-${PV}-1.20.GA.noarch.rpm"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.8"

S="${WORKDIR}"

java_prepare() {
	epatch "${FILESDIR}"/${P}-profile.patch
}

pkg_setup() {
	enewgroup rundeck
	enewuser rundeck -1 /bin/bash /var/lib/rundeck rundeck
}

src_install() {
	insinto /etc
	doins -r etc/rundeck
	insinto /var/lib
	doins -r var/lib/rundeck
	dodir /var/log/rundeck
	dodir /var/rundeck/projects
	fowners -R rundeck:rundeck /var/lib/rundeck /var/log/rundeck
	fowners -R rundeck:rundeck /var/rundeck

	newinitd "${FILESDIR}"/rundeckd.initd rundeckd
	echo . \"${EPREFIX}\"/etc/rundeck/profile > "${T}"/launcher-pre.sh

	java-pkg_regjar "${ED}"/var/lib/rundeck/bootstrap/*.jar
	java-pkg_dolauncher rundeckd \
						-pre "${T}"/launcher-pre.sh \
						--main com.dtolabs.rundeck.RunServer \
						--java_args "\${RDECK_JVM}" \
						--pkg_args "${EPREFIX}/var/lib/rundeck \${RDECK_HTTP_PORT}"
}
