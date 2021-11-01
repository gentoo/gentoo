# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom injection-api-2.0.1/pom.xml --download-uri https://github.com/eclipse-ee4j/injection-api/archive/refs/tags/2.0.1.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild injection-api-2.0.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.inject:jakarta.inject-api:2.0.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Dependency Injection"
HOMEPAGE="https://github.com/eclipse-ee4j/injection-api"
SRC_URI="https://github.com/eclipse-ee4j/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,NOTICE}.md LICENSE.txt )

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"
#	JAVA_RESOURCE_DIRS=( "${P}")

src_install() {
	default
	java-pkg-simple_src_install
}
