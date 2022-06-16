# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom byte-buddy-1.12.8.pom --download-uri https://repo1.maven.org/maven2/net/bytebuddy/byte-buddy/1.12.8/byte-buddy-1.12.8-sources.jar --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild byte-buddy-1.12.8.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="net.bytebuddy:byte-buddy:1.12.8"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Byte Buddy is a Java library for creating Java classes at run time"
HOMEPAGE="https://bytebuddy.net/"
SRC_URI="https://repo1.maven.org/maven2/net/bytebuddy/${PN}/${PV}/${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

# Compile dependencies
# POM: ${P}.pom
# com.google.code.findbugs:findbugs-annotations:3.0.1 -> >=dev-java/findbugs-annotations-3.0.1:0
# com.google.code.findbugs:jsr305:3.0.2 -> >=dev-java/jsr305-3.0.2:0
# net.java.dev.jna:jna:5.8.0 -> >=dev-java/jna-5.10.0:4
# net.java.dev.jna:jna-platform:5.8.0 -> !!!artifactId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/findbugs-annotations:0
	>=dev-java/jna-5.10.0:4
"

RDEPEND="
	>=virtual/jre-1.8:*
"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

JAVA_CLASSPATH_EXTRA="findbugs-annotations,jna-4"

src_prepare() {
	default
	java-pkg_clean
}
