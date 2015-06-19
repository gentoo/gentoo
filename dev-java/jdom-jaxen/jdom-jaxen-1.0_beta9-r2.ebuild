# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdom-jaxen/jdom-jaxen-1.0_beta9-r2.ebuild,v 1.11 2014/08/10 20:18:05 slyfox Exp $

JAVA_PKG_IUSE=""

inherit base java-pkg-2

MY_PN="jdom"
MY_PV="b9"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Jaxen binding for jdom"
HOMEPAGE="http://www.jdom.org"
SRC_URI="http://www.jdom.org/dist/source/archive/${MY_P}.tar.gz"

LICENSE="JDOM"
SLOT="${PV}"
KEYWORDS="amd64 ppc ppc64 ~x86"

IUSE=""

COMMON_DEP="~dev-java/jdom-1.0_beta9
			=dev-java/jaxen-1.1*
			dev-java/saxpath"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	cd "${S}/src/java/org/jdom/xpath/"
	mv JaxenXPath.java JaxenXPath.java.bak
	sed 's/SAXPathException/Exception/g' JaxenXPath.java.bak > JaxenXPath.java

	cd "${S}"

	mkdir -p "${S}/build/org/jdom/xpath" || die "Unable to create dir."
	ejavac -d "${S}/build/" \
		-classpath $(java-config -p jdom-1.0_beta9,jaxen-1.1,saxpath) \
		src/java/org/jdom/xpath/JaxenXPath.java

	jar cf jdom-jaxen.jar -C build org || die "Failed to create jar."
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	#use doc && java-pkg_dojavadoc build/javadoc
	#use source && java-pkg_dosrc src
}
