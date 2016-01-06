# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java API to manipulate XML data"
SRC_URI="http://www.jdom.org/dist/binary/archive/${P}.tar.gz"
HOMEPAGE="http://www.jdom.org"
LICENSE="JDOM"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/${PN}"

java_prepare() {
	java-pkg_clean

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

src_install() {
	java-pkg_dojar build/*.jar
	dodoc CHANGES.txt COMMITTERS.txt README.txt TODO.txt || die
	use doc && java-pkg_dojavadoc build/apidocs
	use examples && java-pkg_doexamples samples
	use source && java-pkg_dosrc src/java/org
}
