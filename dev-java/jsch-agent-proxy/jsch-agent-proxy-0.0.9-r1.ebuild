# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.jcraft:jsch.agentproxy.jsch:0.0.9"

inherit java-pkg-2 java-pkg-simple

MY_COMMIT="12c3d64fc2b0a4fd37659369edfdee26e48954e2"
DESCRIPTION="a proxy to ssh-agent and Pageant in Java"
HOMEPAGE="http://www.jcraft.com/jsch-agent-proxy/"
SRC_URI="https://github.com/ymnk/jsch-agent-proxy/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/jsch-agent-proxy-${MY_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64"

CP_DEPEND="
	dev-java/jna:4
	dev-java/jsch:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( LICENSE.txt README README.md )

JAVA_GENTOO_CLASSPATH="jna-4,jsch"
JAVA_GENTOO_CLASSPATH_EXTRA="jsch-agentproxy-core.jar:jsch-agentproxy-pageant.jar:jsch-agentproxy-sshagent.jar"
JAVA_GENTOO_CLASSPATH_EXTRA+=":jsch-agentproxy-usocket-jna.jar:jsch-agentproxy-usocket-nc.jar"
JAVADOC_CLASSPATH="${JAVA_GENTOO_CLASSPATH}"
JAVADOC_SRC_DIRS=(
	"${PN}-core"
	"${PN}-jsch"
	"${PN}-pageant"
	"${PN}-sshagent"
	"${PN}-usocket-jna"
	"${PN}-usocket-nc"
	"${PN}-connector-factory"
)

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

	use doc && ejavadoc
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
		java-pkg_dosrc "${PN}-core" "${PN}-jsch" "${PN}-pageant" "${PN}-sshagent" "${PN}-usocket-jna" \
			"${PN}-usocket-nc" "${PN}-connector-factory"
	fi
}
