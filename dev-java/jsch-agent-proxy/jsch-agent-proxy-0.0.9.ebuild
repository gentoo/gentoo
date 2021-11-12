# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom jsch-agent-proxy-12c3d64fc2b0a4fd37659369edfdee26e48954e2/jsch-agent-proxy-jsch/pom.xml --download-uri https://github.com/ymnk/jsch-agent-proxy/archive/12c3d64fc2b0a4fd37659369edfdee26e48954e2.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild jsch-agent-proxy-0.0.9.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.jcraft:jsch.agentproxy.jsch:0.0.9"

inherit java-pkg-2 java-pkg-simple

MY_COMMIT="12c3d64fc2b0a4fd37659369edfdee26e48954e2"
DESCRIPTION="a proxy to ssh-agent and Pageant in Java"
HOMEPAGE="http://www.jcraft.com/jsch-agent-proxy/"
SRC_URI="https://github.com/ymnk/jsch-agent-proxy/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

# Common dependencies
# POM: ${PN}-12c3d64fc2b0a4fd37659369edfdee26e48954e2/${PN}-jsch/pom.xml
# com.jcraft:jsch:0.1.49 -> >=dev-java/jsch-0.1.54:0
# com.jcraft:jsch.agentproxy.core:0.0.9 -> >=dev-java/jsch-agentproxy-core-0.0.9:0

CDEPEND="
	dev-java/jna:4
	dev-java/jsch:0
"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DOCS=( LICENSE.txt README README.md )

S="${WORKDIR}/jsch-agent-proxy-${MY_COMMIT}"

JAVA_GENTOO_CLASSPATH="jna-4,jsch"
JAVA_GENTOO_CLASSPATH_EXTRA="jsch-agentproxy-core.jar:jsch-agentproxy-pageant.jar:jsch-agentproxy-sshagent.jar:jsch-agentproxy-usocket-jna.jar:jsch-agentproxy-usocket-nc.jar"

src_compile() {
	JAVA_SRC_DIR="${PN}-core"
	JAVA_JAR_FILENAME="jsch-agentproxy-core.jar"
	java-pkg-simple_src_compile
	rm -fr target || die

	JAVA_SRC_DIR="${PN}-jsch"
	JAVA_JAR_FILENAME="jsch-agentproxy-jsch.jar"
	java-pkg-simple_src_compile
	rm -fr target || die

	JAVA_SRC_DIR="${PN}-pageant"
	JAVA_JAR_FILENAME="jsch-agentproxy-pageant.jar"
	java-pkg-simple_src_compile
	rm -fr target || die

	JAVA_SRC_DIR="${PN}-sshagent"
	JAVA_JAR_FILENAME="jsch-agentproxy-sshagent.jar"
	java-pkg-simple_src_compile
	rm -fr target || die

	JAVA_SRC_DIR="${PN}-usocket-jna"
	JAVA_JAR_FILENAME="jsch-agentproxy-usocket-jna.jar"
	java-pkg-simple_src_compile
	rm -fr target || die

	JAVA_SRC_DIR="${PN}-usocket-nc"
	JAVA_JAR_FILENAME="jsch-agentproxy-usocket-nc.jar"
	java-pkg-simple_src_compile
	rm -fr target || die

	JAVA_SRC_DIR="${PN}-connector-factory"
	JAVA_JAR_FILENAME="jsch-agentproxy-connector-factory.jar"
	java-pkg-simple_src_compile
	rm -fr target || die

	JAVA_SRC_DIR=(
		"${PN}-core"
		"${PN}-jsch"
		"${PN}-pageant"
		"${PN}-sshagent"
		"${PN}-usocket-jna"
		"${PN}-usocket-nc"
		"${PN}-connector-factory"
	)
	JAVA_JAR_FILENAME="ignoreme.jar"
	java-pkg-simple_src_compile
}

src_install() {
	default
	java-pkg_dojar "jsch-agentproxy-core.jar"
	java-pkg_dojar "jsch-agentproxy-jsch.jar"
	java-pkg_dojar "jsch-agentproxy-pageant.jar"
	java-pkg_dojar "jsch-agentproxy-sshagent.jar"
	java-pkg_dojar "jsch-agentproxy-usocket-jna.jar"
	java-pkg_dojar "jsch-agentproxy-usocket-nc.jar"
	java-pkg_dojar "jsch-agentproxy-connector-factory.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi
	if use source; then
		java-pkg_dosrc "${PN}-core" "${PN}-jsch" "${PN}-pageant" "${PN}-sshagent" "${PN}-usocket-jna" "${PN}-usocket-nc" "${PN}-connector-factory"
	fi
}
