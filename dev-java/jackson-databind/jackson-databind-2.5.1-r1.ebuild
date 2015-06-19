# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jackson-databind/jackson-databind-2.5.1-r1.ebuild,v 1.1 2015/06/14 15:30:26 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-pkg-simple

DESCRIPTION="High-performance JSON processor"
HOMEPAGE="https://github.com/FasterXML/jackson-databind"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test" # 27/1306 failures :(

CDEPEND="~dev-java/jackson-${PV}:${SLOT}
	~dev-java/jackson-annotations-${PV}:${SLOT}"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}
	test? (
		dev-java/cglib:3
		dev-java/groovy:0
		dev-java/junit:4
	)"

S="${WORKDIR}/${PN}-${P}/src"
JAVA_SRC_DIR="main/java"
JAVA_GENTOO_CLASSPATH="jackson-${SLOT},jackson-annotations-${SLOT}"

java_prepare() {
	epatch "${FILESDIR}/real-cglib.patch"

	sed -e 's:@package@:com.fasterxml.jackson.databind.cfg:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.core:g' \
		-e 's:@projectartifactid@:jackson-databind:g' \
		"${S}/main/java/com/fasterxml/jackson/databind/cfg/PackageVersion.java.in" \
		> "${S}/main/java/com/fasterxml/jackson/databind/cfg/PackageVersion.java" || die

	# Requires newer JScience. Could be any class but they chose this!
	rm "${S}/test/java/com/fasterxml/jackson/databind/deser/TestNoClassDefFoundDeserializer.java" || die
}

src_install() {
	java-pkg-simple_src_install
	dodoc ../README.md ../release-notes/{CREDITS,VERSION}
}

src_test() {
	cd test/java || die

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars --with-dependencies cglib-2.2,groovy,junit-4,${JAVA_GENTOO_CLASSPATH})"
	local TESTS=$(find * -name "Test*.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
