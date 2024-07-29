# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/eclipse-ee4j/injection-api/archive/2.0.1.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild injection-api-2.0.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.inject:jakarta.inject-api:2.0.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Dependency Injection"
HOMEPAGE="https://jakarta.ee/specifications/dependency-injection/"
SRC_URI="https://github.com/jakartaee/inject/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/inject-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,NOTICE}.md )

JAVA_SRC_DIR="src/main/java"
