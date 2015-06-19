# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jinput/jinput-2.0.6-r1.ebuild,v 1.1 2015/04/13 22:21:38 chewi Exp $

EAPI=5

COMMIT="790b666"
JAVA_PKG_IUSE="doc source"

inherit eutils toolchain-funcs java-pkg-2 java-ant-2 vcs-snapshot

DESCRIPTION="An implementation of an API for game controller discovery and polled input"
HOMEPAGE="https://java.net/projects/jinput"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/jutils:0"

RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.4
	${CDEPEND}"

JAVA_PKG_BSFIX="off"
EANT_BUILD_TARGET="dist"

src_prepare() {
	# http://java.net/jira/browse/JINPUT-44
	# http://java.net/jira/browse/JINPUT-45
	epatch "${FILESDIR}"/{javah-classpath,nostrip,remove-getDeviceUsageBits,unbundle}.patch

	sed -i \
		-e "s/\"cc\"/\"$(tc-getCC)\"/g" \
		-e "s/-O[0-9]/${CFLAGS} ${LDFLAGS}/g" \
		plugins/linux/src/native/build.xml || die

	java-pkg_jar-from --into lib jutils
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_doso dist/lib${PN}-*.so

	# Only core API docs, others would conflict.
	use doc && java-pkg_dojavadoc coreAPI/apidocs
	use source && java-pkg_dosrc */src/java/* */**/src/java/*
}
