# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdom/jdom-1.1.3.ebuild,v 1.4 2015/06/16 09:11:27 monsieurp Exp $

EAPI=5
JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java API to manipulate XML data"
SRC_URI="http://www.jdom.org/dist/binary/archive/${P}.tar.gz"
HOMEPAGE="http://www.jdom.org"
LICENSE="JDOM"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
COMMON_DEP="dev-java/saxpath
		>=dev-java/xerces-2.7"
RDEPEND=">=virtual/jre-1.6"
#	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6"
#	${COMMON_DEP}"
IUSE=""

S="${WORKDIR}/${PN}"

java_prepare() {
	find "${S}" -name '*.jar' -delete || die

	rm -r build/apidocs || die

	rm -v src/java/org/jdom/xpath/JaxenXPath.java \
		|| die "Unable to remove Jaxen Binding class."

	sed -i -e 's|${name}-${version.impl}|${name}|g' \
		-e 's|<jar jarfile="${build.dir}/${name}-sources|<!-- <jar jarfile="${build.dir}/${name}-sources|' \
		-e 's|build.javadocs}" />|build.javadocs}" /> -->|' \
		"${S}"/build.xml || die

	if ! use doc; then
		sed -i -e 's|depends="compile,javadoc"|depends="compile"|' \
			"${S}"/build.xml || die
	fi
}

EANT_BUILD_TARGET="package"
#EANT_GENTOO_CLASSPATH="saxpath,xerces-2"

src_install() {
	java-pkg_dojar build/*.jar

	#java-pkg_register-dependency "jdom-jaxen-${SLOT}"
	dodoc CHANGES.txt COMMITTERS.txt README.txt TODO.txt || die
	use doc && java-pkg_dojavadoc build/apidocs
	use examples && java-pkg_doexamples samples
	use source && java-pkg_dosrc src/java/org
}
