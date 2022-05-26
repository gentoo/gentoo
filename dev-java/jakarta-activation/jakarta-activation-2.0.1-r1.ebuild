# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/eclipse-ee4j/jaf/archive/refs/tags/2.0.1.tar.gz --slot 2 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jakarta-activation-2.0.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.sun.activation:jakarta.activation:2.0.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Activation"
HOMEPAGE="https://github.com/eclipse-ee4j/jaf"
SRC_URI="https://github.com/eclipse-ee4j/jaf/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-11:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/jaf-${PV}/activation"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS=(
	"src/main/resources"
)
