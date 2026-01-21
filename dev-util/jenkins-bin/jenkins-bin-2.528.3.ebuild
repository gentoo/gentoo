# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="The leading open source automation server"
HOMEPAGE="https://jenkins.io/"
SRC_URI="https://get.jenkins.io/war-stable/${PV}/${PN/-bin/}.war -> ${P}.war"
S="${WORKDIR}"
LICENSE="MIT"
SLOT="lts"

KEYWORDS="amd64 arm64 ~x86"

DEPEND="acct-group/jenkins
	acct-user/jenkins"

RDEPEND="acct-group/jenkins
	acct-user/jenkins
	media-fonts/dejavu
	media-libs/freetype
	!dev-util/jenkins-bin:0
	|| ( virtual/jre:21 virtual/jre:17 )"

src_install() {
	local JENKINS_DIR=/var/lib/jenkins

	keepdir /var/log/jenkins ${JENKINS_DIR}/backup ${JENKINS_DIR}/home

	insinto /opt/jenkins
	newins "${DISTDIR}"/${P}.war ${PN/-bin/}.war

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}-r3.logrotate ${PN/-bin/}

	newinitd "${FILESDIR}"/${PN}-r3.init jenkins
	newconfd "${FILESDIR}"/${PN}-r1.confd jenkins

	systemd_newunit "${FILESDIR}"/${PN}-r5.service jenkins.service

	fowners jenkins:jenkins /var/log/jenkins ${JENKINS_DIR} ${JENKINS_DIR}/home ${JENKINS_DIR}/backup
}
