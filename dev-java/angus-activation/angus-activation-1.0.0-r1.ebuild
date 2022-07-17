# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/eclipse-ee4j/angus-activation/archive/refs/tags/1.0.0.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild angus-activation-1.0.0-r1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.eclipse.angus:angus-activation:1.0.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Provides the implementation of the Jakarta Activation Specification"
HOMEPAGE="https://github.com/eclipse-ee4j/angus-activation"
SRC_URI="https://github.com/eclipse-ee4j/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	dev-java/jakarta-activation-api:2
	>=virtual/jdk-11:*"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/${P}/activation-registry"

JAVA_CLASSPATH_EXTRA="jakarta-activation-api-2"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"
