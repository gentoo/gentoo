# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom findbugs-annotations-3.0.1.pom --download-uri https://repo1.maven.org/maven2/com/google/code/findbugs/findbugs-annotations/3.0.1/findbugs-annotations-3.0.1-sources.jar --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild findbugs-annotations-3.0.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.code.findbugs:findbugs-annotations:3.0.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Annotation defined by the FindBugs tool"
HOMEPAGE="http://findbugs.sourceforge.net/"
SRC_URI="https://repo1.maven.org/maven2/com/google/code/findbugs/${PN}/${PV}/${P}-sources.jar"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

# Common dependencies
# POM: ${P}.pom
# com.google.code.findbugs:jsr305:3.0.1 -> >=dev-java/jsr305-3.0.2:0

CP_DEPEND="
	>=dev-java/jsr305-3.0.2:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
