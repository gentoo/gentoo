# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.tomcat:tomcat-jsp-api:8.5.85"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Tomcat's JSP API 2.3 implementation"
HOMEPAGE="https://tomcat.apache.org/"
SRC_URI="mirror://apache/tomcat/tomcat-$(ver_cut 1)/v${PV}/src/apache-tomcat-${PV}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/tomcat/tomcat-$(ver_cut 1)/v${PV}/src/apache-tomcat-${PV}-src.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="2.3"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"

CP_DEPEND="
	~dev-java/tomcat-el-api-${PV}:3.0
	~dev-java/tomcat-servlet-api-${PV}:3.1
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

BDEPEND="verify-sig? ( ~sec-keys/openpgp-keys-apache-tomcat-${PV}:${PV} )"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/tomcat-${PV}.apache.org.asc"

S="${WORKDIR}/apache-tomcat-${PV}-src"

JAVA_RESOURCE_DIRS="resources"
JAVA_SRC_DIR="java/javax/servlet/jsp"

src_prepare() {
	default
	mkdir -p resources/javax/servlet || "creating \"resources\" failed"
	cp -r {java,resources}/javax/servlet/jsp || "cannot copy to \"resources\" dir"
	find resources \( -name '*.java' -o -name 'tagext' \) \
		-exec rm -rf {} + || die "removing *.java files failed"
}
