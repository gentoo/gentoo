# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/eclipse-ee4j/jaf/archive/refs/tags/2.0.1.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jakarta-activation-2.0.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.activation:jakarta.activation-api:2.1.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Activation API jar"
HOMEPAGE="https://eclipse-ee4j.github.io/jaf/"
SRC_URI="https://github.com/eclipse-ee4j/jaf/archive/refs/tags/${PV}.tar.gz -> jakarta-activation-${PV}.tar.gz"

LICENSE="EPL-1.0"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,LICENSE,NOTICE,README}.md )

S="${WORKDIR}/jaf-${PV}/api"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
