# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit user systemd

DESCRIPTION="Extensible continuous integration server"
HOMEPAGE="http://jenkins-ci.org/"
LICENSE="MIT"
SRC_URI="http://mirrors.jenkins-ci.org/war-stable/${PV}/${PN/-bin/}.war -> ${P}.war"
RESTRICT="mirror"
SLOT="lts"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-fonts/dejavu
	media-libs/freetype
	!dev-util/jenkins-bin:0
	>=virtual/jre-1.7.0"

S=${WORKDIR}

JENKINS_DIR=/var/lib/jenkins

pkg_setup() {
	enewgroup jenkins
	enewuser jenkins -1 -1 ${JENKINS_DIR} jenkins
}

src_install() {
	keepdir /var/log/jenkins ${JENKINS_DIR}/backup ${JENKINS_DIR}/home

	insinto /opt/jenkins
	newins "${DISTDIR}"/${P}.war ${PN/-bin/}.war

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}-r1.logrotate ${PN/-bin/}

	newinitd "${FILESDIR}"/${PN}.init2 jenkins
	newconfd "${FILESDIR}"/${PN}.confd jenkins

	systemd_newunit "${FILESDIR}"/${PN}.service jenkins.service

	fowners jenkins:jenkins /var/log/jenkins ${JENKINS_DIR} ${JENKINS_DIR}/home ${JENKINS_DIR}/backup
}
