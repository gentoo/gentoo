# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdom-jaxen/jdom-jaxen-1.0-r1.ebuild,v 1.16 2015/07/11 09:25:27 chewi Exp $

JAVA_PKG_IUSE=""

inherit base java-pkg-2

MY_PN="jdom"

DESCRIPTION="Jaxen binding for jdom"
HOMEPAGE="http://www.jdom.org"
SRC_URI="http://www.jdom.org/dist/source/${MY_PN}-${PV}.tar.gz"

LICENSE="JDOM"
SLOT="${PV}"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

IUSE=""

COMMON_DEP="~dev-java/jdom-${SLOT}
			=dev-java/jaxen-1.1*
			dev-java/saxpath"

RDEPEND=">=virtual/jre-1.4
		${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
		app-arch/unzip
		${COMMON_DEP}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	cd "${S}/src/java/org/jdom/xpath/"
	mv JaxenXPath.java JaxenXPath.java.bak
	sed 's/SAXPathException/Exception/g' JaxenXPath.java.bak > JaxenXPath.java

	cd "${S}"

	mkdir -p "${S}/build/org/jdom/xpath" || die "Unable to create dir."
	ejavac -d "${S}/build/" \
		-classpath $(java-config -p jdom-${SLOT},jaxen-1.1,saxpath) \
		src/java/org/jdom/xpath/JaxenXPath.java

	jar cf jdom-jaxen.jar -C build org || die "Failed to create jar."
}

src_install() {
	java-pkg_dojar "${PN}.jar"
}
