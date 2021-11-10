# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom jaf-1.2.2/activationapi/pom.xml --download-uri https://github.com/eclipse-ee4j/jaf/archive/refs/tags/1.2.2.tar.gz --slot 1 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jakarta-activation-api-1.2.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.activation:jakarta.activation-api:1.2.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Activation API jar"
HOMEPAGE="https://eclipse-ee4j.github.io/jaf/"
SRC_URI="https://github.com/eclipse-ee4j/jaf/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="1"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/zip"

DOCS=( ../{CONTRIBUTING,LICENSE,NOTICE,README}.md )

S="${WORKDIR}/jaf-${PV}/activation"

JAVA_ENCODING="iso-8859-1"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

src_prepare() {
	default
	# these files are not present in the upstream jar
	find ${JAVA_RESOURCE_DIRS} -name "*.default" -delete || die "Failed to delete *.default files"
}

src_compile() {
	java-pkg-simple_src_compile
	# we remove implementation classes from the api
	zip -d ${PN}.jar "com/*" || die "Failed to remove implementation classes"
}

src_install() {
	default
	# we remove the implementation sources so that they don't land in sources
	rm -fr ${JAVA_SRC_DIR}/com || "Failed to delete implementation sources"
	java-pkg-simple_src_install
}
