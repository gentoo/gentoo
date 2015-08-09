# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JUnit-addons is a collection of helper classes for JUnit"
HOMEPAGE="http://junit-addons.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux ~x86-macos"

COMMON_DEP="
	=dev-java/junit-3.8*
	dev-java/ant-core
	~dev-java/jdom-1.0
	=dev-java/jaxen-1.1*
	"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
		app-arch/unzip
		${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./src.jar
	rm -v *.jar || die
	# Not included so taken from cvs
	cp "${FILESDIR}/${PV}-build.xml" build.xml || die
	cp "${FILESDIR}/${PV}-common.properties" common.properties || die
}

_eant() {
	eant \
		-Djunit.jar="$(java-pkg_getjar junit junit.jar)" \
		-Dant.jar="$(java-pkg_getjar ant-core ant.jar)" \
		-Djdom.jar="$(java-pkg_getjar jdom-1.0 jdom.jar)" \
		-Djaxen.jar="$(java-pkg_getjar jaxen-1.1 jaxen.jar)" \
		"${@}"
}

src_compile() {
	# javadocs are bundled
	_eant release
}

# Needs junit-addons-runner that again needs this package to build
#src_test() {
#	cd src/test/
#	_eant -f AntTest.xml
#}

src_install() {
	java-pkg_newjar dist/${P}.jar
	dodoc README WHATSNEW || die
	use doc && java-pkg_dojavadoc api
	if use source; then
		insinto "${JAVA_PKG_SOURCESPATH}"
		newins dist/src.jar ${PN}-src.zip
	fi
}
