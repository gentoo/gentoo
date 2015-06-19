# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-discovery/commons-discovery-0.4.ebuild,v 1.7 2011/12/19 12:52:20 sera Exp $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Commons Discovery: Service Discovery component"
HOMEPAGE="http://commons.apache.org/discovery/"
SRC_URI="mirror://apache/jakarta/commons/discovery/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc source test"

RDEPEND=">=virtual/jre-1.4
	dev-java/commons-logging"

DEPEND=">=virtual/jdk-1.4
	${RDEPEND}
	dev-java/ant-core
	source? ( app-arch/zip )
	test? ( =dev-java/junit-3* )"

S="${WORKDIR}/${P}-src/"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# https://issues.apache.org/jira/browse/DISCOVERY-10
	epatch "${FILESDIR}/0.4-jar-target.patch"
}

src_compile() {
	java-pkg-2_src_compile \
		-Dlogger.jar="$(java-pkg_getjar commons-logging commons-logging.jar)"
}

src_test() {
	eant test.discovery \
		-Djunit.jar="$(java-pkg_getjar --build-only junit junit.jar)" \
		-Dlogger.jar="$(java-pkg_getjar commons-logging commons-logging.jar)"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	dodoc NOTICE.txt RELEASE-NOTES.txt || die

	use doc && 	java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
