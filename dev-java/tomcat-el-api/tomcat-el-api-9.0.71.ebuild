# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.tomcat:tomcat-el-api:9.0.71"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Tomcat's EL API 3.0 implementation"
HOMEPAGE="https://tomcat.apache.org/"
SRC_URI="mirror://apache/tomcat/tomcat-$(ver_cut 1)/v${PV}/src/apache-tomcat-${PV}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/tomcat/tomcat-$(ver_cut 1)/v${PV}/src/apache-tomcat-${PV}-src.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="3.0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

BDEPEND="verify-sig? ( ~sec-keys/openpgp-keys-apache-tomcat-${PV}:${PV} )"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/tomcat-${PV}.apache.org.asc"

S="${WORKDIR}/apache-tomcat-${PV}-src"

JAVA_RESOURCE_DIRS="resources"
JAVA_SRC_DIR="java/javax/el"

src_prepare() {
	default
	# remove anything related to "el" or "jsp"
	find java/javax \( -name 'jsp' -o -name 'servlet' \) \
		-exec rm -rf {} + || die "removing jsp failed"

	mkdir resources || "creating \"resources\" failed"
	cp -r java/javax resources || "cannot copy to \"resources\" dir"
	find resources -name '*.java' -exec rm -rf {} + || die "removing *.java files failed"
}
