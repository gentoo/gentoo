# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/eclipse-ee4j/jaf/archive/refs/tags/1.2.2.tar.gz --slot 1 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jakarta-activation-1.2.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.sun.activation:jakarta.activation:1.2.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Activation"
HOMEPAGE="https://github.com/eclipse-ee4j/jaf/jakarta.activation"
SRC_URI="https://github.com/eclipse-ee4j/jaf/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="1"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~x86"

CDEPEND="dev-java/jakarta-activation-api:1"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"
BDEPEND="app-arch/zip"

DOCS=( ../{CONTRIBUTING,LICENSE,NOTICE,README}.md )

S="${WORKDIR}/jaf-${PV}/activation"

JAVA_ENCODING="iso-8859-1"

JAVA_GENTOO_CLASSPATH="jakarta-activation-api-1"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

src_prepare() {
	default
	find ${JAVA_RESOURCE_DIRS} -name "*.default" -delete || die "Failed to delete *.default files"
}

src_compile() {
	java-pkg-simple_src_compile

	# we remove API classes from the jar file
	# removing javax sources in src_prepare does not work - compilation fails with:
	# src/main/java/module-info.java:12: error: package is empty or does not exist: javax.activation
	#    exports javax.activation;

	zip -d ${PN}.jar "javax/*" || die "Failed to remove API classes"
}
