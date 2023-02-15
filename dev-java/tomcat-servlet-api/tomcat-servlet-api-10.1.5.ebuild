# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.tomcat:tomcat-servlet-api:10.1.5"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Tomcat's Servlet API 6.0 implementation"
HOMEPAGE="https://tomcat.apache.org/"
SRC_URI="mirror://apache/tomcat/tomcat-$(ver_cut 1)/v${PV}/src/apache-tomcat-${PV}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/tomcat/tomcat-$(ver_cut 1)/v${PV}/src/apache-tomcat-${PV}-src.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="6.0"
KEYWORDS="~amd64 ~arm ~arm64 ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"

CP_DEPEND="~dev-java/tomcat-el-api-${PV}:5.0"

DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}"

RDEPEND="
	>=virtual/jre-11:*
	${CP_DEPEND}"

BDEPEND="verify-sig? ( ~sec-keys/openpgp-keys-apache-tomcat-${PV}:${PV} )"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/tomcat-${PV}.apache.org.asc"

S="${WORKDIR}/apache-tomcat-${PV}-src"

JAVA_RESOURCE_DIRS="resources"
JAVA_SRC_DIR="java/jakarta/servlet"

src_prepare() {
	default
	# remove anything related to "el" or "jsp"
	find java/jakarta \( -name 'el' -o -name 'jsp' \) \
		-exec rm -rf {} + || die "removing jsp failed"

	mkdir resources || "creating \"resources\" failed"
	cp -r java/jakarta resources || "cannot copy to \"resources\" dir"
	find resources -name '*.java' -exec rm -rf {} + || die "removing *.java files failed"
}
