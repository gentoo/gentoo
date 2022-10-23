# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.tomcat:tomcat-servlet-api:8.5.83"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Tomcat's Servlet API 6.0 implementation"
HOMEPAGE="https://tomcat.apache.org/"
SRC_URI="mirror://apache/tomcat/tomcat-$(ver_cut 1)/v${PV}/src/apache-tomcat-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="3.1"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"

# we can't use the exact same version of el as tomcat 9 implements the same slot and
# it would prevent from installing both tomcat 8.5 and 9 at the same time
CP_DEPEND=">=dev-java/tomcat-el-api-${PV}:3.0"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/apache-tomcat-${PV}-src"

JAVA_RESOURCE_DIRS="resources"
JAVA_SRC_DIR="java/javax/servlet"

src_prepare() {
	default
	# remove anything related to "el" or "jsp"
	find java/javax \( -name 'el' -o -name 'jsp' \) \
		-exec rm -rf {} + || die "removing jsp failed"

	mkdir resources || "creating \"resources\" failed"
	cp -r java/javax resources || "cannot copy to \"resources\" dir"
	find resources -name '*.java' -exec rm -rf {} + || die "removing *.java files failed"
}
