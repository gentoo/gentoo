# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/jing/jing-20091111-r1.ebuild,v 1.3 2012/10/17 03:03:05 phajdan.jr Exp $

EAPI=4

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jing: A RELAX NG validator in Java"
HOMEPAGE="http://thaiopensource.com/relaxng/jing.html"
SRC_URI="http://jing-trang.googlecode.com/files/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

COMMON_DEPEND="
	dev-java/ant-core:0
	dev-java/iso-relax:0
	dev-java/relaxng-datatype:0
	dev-java/saxon:9
	dev-java/xalan:0
	dev-java/xerces:2
	dev-java/xml-commons-resolver:0"
RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-1.5
	app-arch/unzip"

# Avoid bogous QA warning, no usable build.xml. The one that exists belongs to
# the examples.
S="${WORKDIR}/${P}/src"

src_unpack() {
	default

	mkdir -p "${S}" || die
	pushd "${S}" >/dev/null || die
		unpack ./../src.zip
	popd >/dev/null

	# get the resourses from prebuilt jar
	# http://code.google.com/p/jing-trang/issues/detail?id=84
	mkdir -p "${S}"/target/classes || die
	pushd "${S}"/target/classes >/dev/null || die
		unpack ./../../../bin/${PN}.jar
		find -name '*.class' -exec rm {} + || die
	popd >/dev/null
}

java_prepare() {
	find "${WORKDIR}" -name '*.jar' -exec rm -v {} + || die

	#remove bundled relaxng-datatype
	rm -rv org || die

	# for use with saxon:6.5
	rm -v com/thaiopensource/validate/schematron/OldSaxonSchemaReaderFactory.java || die
	sed -i -e '/OldSaxonSchemaReaderFactory/d' \
		target/classes/META-INF/services/com.thaiopensource.validate.SchemaReaderFactory || die
}

JAVA_GENTOO_CLASSPATH="ant-core,iso-relax,relaxng-datatype,saxon-9,xalan,xerces-2,xml-commons-resolver"

#src_test() {
#	# would need some test files could probably take this from the gcj version
#	#java -cp ${cp} com.thaiopensource.datatype.xsd.regex.test.TestDriver || die
#	#java -cp ${cp} com.thaiopensource.datatype.relaxng.util.TestDriver || die
#	#java -cp ${cp} com.thaiopensource.datatype.xsd.regex.test.CategoryTest \
#	#	|| die
#}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN} --main com.thaiopensource.relaxng.util.Driver

	use doc && dohtml ../doc/*html
	use examples && java-pkg_doexamples ../sample
}
