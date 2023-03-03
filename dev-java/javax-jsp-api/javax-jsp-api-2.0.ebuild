# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="javax.servlet.jsp:jsp-api:2.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JavaServer Pages(TM) API JSR-000152 JSR-000245"
HOMEPAGE="https://jcp.org/aboutJava/communityprocess/final/jsr152/"
SRC_URI="https://repo1.maven.org/maven2/javax/servlet/jsp/jsp-api/${PV}/jsp-api-${PV}-sources.jar"

LICENSE="CDDL GPL-2-with-classpath-exception"
SLOT="2.0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

CP_DEPEND="dev-java/javax-servlet-api:2.5"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

JAVA_RESOURCE_DIRS="resources"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p "${JAVA_RESOURCE_DIRS}/javax/servlet/jsp/resources" || die
	mv dtd/* "${JAVA_RESOURCE_DIRS}/javax/servlet/jsp/resources" || die
}
