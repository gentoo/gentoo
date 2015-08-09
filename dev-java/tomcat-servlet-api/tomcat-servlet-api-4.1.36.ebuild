# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_P="apache-${P/-servlet-api/}-src"
DESCRIPTION="Tomcat's Servlet API 2.3/JSP API 1.2 implementation"
HOMEPAGE="http://tomcat.apache.org/"
SRC_URI="mirror://apache/tomcat/tomcat-4/v${PV}/src/${MY_P}.tar.gz"
DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"
LICENSE="Apache-2.0"
SLOT="2.3"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
S="${WORKDIR}/${MY_P}/servletapi"

src_unpack() {
	unpack ${A}
	cd "${S}"

	einfo "Removing bundled jars and classes"
	find "${WORKDIR}/${MY_P}" '(' -name '*.class' -o -name '*.jar' ')' -delete
}

EANT_BUILD_TARGET="all"

src_install() {
	java-pkg_dojar dist/lib/servlet.jar

	use doc && java-pkg_dohtml -r dist/docs/*
	use source && java-pkg_dosrc src/share/javax
	dodoc dist/README.txt
}
