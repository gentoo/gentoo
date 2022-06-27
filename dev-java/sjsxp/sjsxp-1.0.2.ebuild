# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom sjsxp-1.0.2.pom --download-uri https://repo1.maven.org/maven2/com/sun/xml/stream/sjsxp/1.0.2/sjsxp-1.0.2.jar --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild sjsxp-1.0.2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.sun.xml.stream:sjsxp:1.0.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Sun Java Streaming XML Parser (SJSXP) is the implementation of JSR 173"
HOMEPAGE="https://sjsxp.java.net/"
SRC_URI="https://repo1.maven.org/maven2/com/sun/xml/stream/${PN}/${PV}/${P}-sources.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: ${P}.pom
# javax.xml.stream:stax-api:1.0 -> !!!groupId-not-found!!!

CP_DEPEND="dev-java/xpp3:0"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

#	JAVA_SRC_DIR="src/main/java"
