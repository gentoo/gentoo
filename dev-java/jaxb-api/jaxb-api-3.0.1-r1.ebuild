# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/eclipse-ee4j/jaxb-api/archive/refs/tags/3.0.1.tar.gz --slot 2 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jaxb-api-3.0.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.xml.bind:jakarta.xml.bind-api:3.0.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta XML Binding API"
HOMEPAGE="https://github.com/eclipse-ee4j/jaxb-api"
SRC_URI="https://github.com/eclipse-ee4j/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="3"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# com.sun.activation:jakarta.activation:2.0.1 -> >=dev-java/jakarta-activation-2.0.1:2

CDEPEND="dev-java/jakarta-activation:2"

DEPEND="${CDEPEND}
	>=virtual/jdk-11:*"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

S="${WORKDIR}/${P}/${PN}"

JAVA_GENTOO_CLASSPATH="jakarta-activation-2"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"
