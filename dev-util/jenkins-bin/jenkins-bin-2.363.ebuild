# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Extensible continuous integration server"
HOMEPAGE="https://jenkins.io/"
LICENSE="MIT"
SRC_URI="http://mirrors.jenkins-ci.org/war/${PV}/${PN/-bin/}.war -> ${P}.war"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="acct-group/jenkins
	acct-user/jenkins"

RDEPEND="acct-group/jenkins
	acct-user/jenkins
	media-fonts/dejavu
	media-libs/freetype
	!dev-util/jenkins-bin:lts
	|| ( virtual/jre:17 virtual/jre:11 )"

S="${WORKDIR}"

src_install() {
	local JENKINS_DIR=/var/lib/jenkins

	keepdir /var/log/jenkins ${JENKINS_DIR}/backup ${JENKINS_DIR}/home

	insinto /opt/jenkins
	newins "${DISTDIR}"/${P}.war ${PN/-bin/}.war

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}-r2.logrotate ${PN/-bin/}

	newinitd "${FILESDIR}"/${PN}-r2.init jenkins
	newconfd "${FILESDIR}"/${PN}.confd jenkins

	systemd_newunit "${FILESDIR}"/${PN}-r3.service jenkins.service

	fowners jenkins:jenkins /var/log/jenkins ${JENKINS_DIR} ${JENKINS_DIR}/home ${JENKINS_DIR}/backup
}
