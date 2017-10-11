# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Annotations for the Java Jackson data processor"
HOMEPAGE="https://github.com/FasterXML/jackson-annotations"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${PN}-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.7"

DEPEND=">=virtual/jdk-1.7
	dev-java/asm
	dev-java/jackson
	dev-java/jackson-databind"

S="${WORKDIR}/${PN}-${P}"
JAVA_SRC_DIR="mrbean/src/main/java"
JAVA_GENTOO_CLASSPATH="asm-4,jackson-2,jackson-databind-2"

src_prepare() {
	default

	sed -e 's:@package@:com.fasterxml.jackson.module.mrbean:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.core:g' \
		-e 's:@projectartifactid@:MrBeanModule:g' \
		"${JAVA_SRC_DIR}/com/fasterxml/jackson/module/mrbean/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/module/mrbean/PackageVersion.java"

	java-pkg-2_src_prepare
}

src_install() {
	java-pkg-simple_src_install
	dodoc README.md release-notes/VERSION
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar mrbean/src/main/resources
}
