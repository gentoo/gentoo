# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom antlr-runtime-3.5.3.pom --download-uri https://repo1.maven.org/maven2/org/antlr/antlr-runtime/3.5.3/antlr-runtime-3.5.3-sources.jar --slot 3.5 --keywords "~amd64 ~arm ~arm64~ppc64 ~x86" --ebuild antlr-runtime-3.5.3.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.antlr:antlr-runtime:3.5.3"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="ANTLR 3 Runtime"
HOMEPAGE="https://www.antlr3.org/"
SRC_URI="https://repo1.maven.org/maven2/org/antlr/${PN}/${PV}/${P}-sources.jar"

LICENSE="BSD"
SLOT="3.5"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: ${P}.pom
# org.antlr:stringtemplate:3.2.1 -> >=dev-java/stringtemplate-3.2.1:0

CP_DEPEND="
	>=dev-java/stringtemplate-3.2.1:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
