# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.activation:jakarta.activation-api:1.2.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Activation API jar"
HOMEPAGE="https://jakartaee.github.io/jaf-api/"
SRC_URI="https://github.com/jakartaee/jaf-api/archive/${PV}.tar.gz -> jakarta-activation-${PV}.tar.gz"

LICENSE="EPL-1.0"
SLOT="1"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/zip"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/jaf-api-${PV}/activation"

JAVA_ENCODING="iso-8859-1"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

src_prepare() {
	java-pkg-2_src_prepare
	# these files are not present in the upstream jar
	find ${JAVA_RESOURCE_DIRS} -name "*.default" -delete || die "Failed to delete *.default files"
}

src_compile() {
	java-pkg-simple_src_compile
	# we remove implementation classes from the api
	zip -d ${PN}.jar "com/*" || die "Failed to remove implementation classes"
}

src_install() {
	# we remove the implementation sources so that they don't land in sources
	rm -fr ${JAVA_SRC_DIR}/com || "Failed to delete implementation sources"
	java-pkg-simple_src_install
}
