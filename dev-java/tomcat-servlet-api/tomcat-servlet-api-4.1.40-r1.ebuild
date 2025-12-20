# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="apache-${P/-servlet-api/}-src"
DESCRIPTION="Tomcat's Servlet API 2.3/JSP API 1.2 implementation"
HOMEPAGE="https://tomcat.apache.org/"
SRC_URI="https://archive.apache.org/dist/tomcat/tomcat-4/v${PV}/src/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}/servletapi"

LICENSE="Apache-2.0"
SLOT="2.3"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"

DEPEND=">=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8"

JAVA_RESOURCE_DIRS="res/src/share"
JAVA_SRC_DIR="src/share"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir src/share/javax/servlet/{,jsp/}resources || die
	mv src/share/dtd/web-app* src/share/javax/servlet/resources || die
	mv src/share/dtd/* src/share/javax/servlet/jsp/resources || die
	mkdir res || die
	find src -type f ! -name '*.java' ! -name '*.gif' \
		| xargs cp --parent -t res || die
}
