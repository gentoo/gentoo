# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="javax.servlet.jsp:jsp-api:2.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JavaServer Pages(TM) API"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://repo1.maven.org/maven2/javax/servlet/jsp/jsp-api/${PV}/jsp-api-${PV}-sources.jar"

LICENSE="CDDL GPL-2-with-classpath-exception"
SLOT="2.2"
KEYWORDS="~amd64 ~arm ~arm64"

CP_DEPEND="
	dev-java/javax-el-api:2.2
	dev-java/javax-servlet-api:2.5
"

RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"
DEPEND=">=virtual/jdk-1.8:*
	${CP_DEPEND}"
