# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/eclipse-ee4j/angus-activation/archive/refs/tags/1.0.0.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild angus-activation-1.0.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.eclipse.angus:angus-activation:1.0.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Provides the implementation of the Jakarta Activation Specification"
HOMEPAGE="https://github.com/eclipse-ee4j/angus-activation"
SRC_URI="https://github.com/eclipse-ee4j/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

# Common dependencies
# POM: pom.xml
# jakarta.activation:jakarta.activation-api:2.1.0 -> !!!suitble-mavenVersion-not-found!!!

CP_DEPEND=">=dev-java/jakarta-activation-api-2.1.0:2"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,LICENSE,NOTICE,README}.md )

S="${WORKDIR}/${P}/activation-registry"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
