# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jackson-module-jaxb-annotations/jackson-module-jaxb-annotations-2.5.1.ebuild,v 1.1 2015/03/05 23:04:04 chewi Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JAXB alternative to native Jackson annotations"
HOMEPAGE="https://github.com/FasterXML/jackson-module-jaxb-annotations"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="~dev-java/jackson-${PV}:${SLOT}
	~dev-java/jackson-annotations-${PV}:${SLOT}
	~dev-java/jackson-databind-${PV}:${SLOT}
	dev-java/stax2-api:0"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${PN}-${P}/src"
JAVA_SRC_DIR="main/java"
JAVA_GENTOO_CLASSPATH="jackson-${SLOT},jackson-annotations-${SLOT},jackson-databind-${SLOT}"

java_prepare() {
	sed -e 's:@package@:com.fasterxml.jackson.module.jaxb:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.module:g' \
		-e 's:@projectartifactid@:jackson-module-jaxb-annotations:g' \
		  "${S}/main/java/com/fasterxml/jackson/module/jaxb/PackageVersion.java.in" \
		> "${S}/main/java/com/fasterxml/jackson/module/jaxb/PackageVersion.java" || die

	# Requires jax-rs, which isn't packaged yet.
	rm "${S}/test/java/com/fasterxml/jackson/module/jaxb/introspect"/{Content,TestPropertyVisibility}.java || die
}

src_install() {
	java-pkg-simple_src_install
	dodoc ../README.md ../release-notes/{CREDITS,VERSION}
}

src_test() {
	cd test/java || die

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars junit-4,${JAVA_GENTOO_CLASSPATH})"
	local TESTS=$(find * -name "Test*.java" ! -path "*/failing/*")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
