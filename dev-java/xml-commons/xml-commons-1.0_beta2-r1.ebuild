# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

MY_PV=${PV/_beta/.b}
MY_P=${PN}-${MY_PV}
DESCRIPTION="Jakarta project for for XML bindings for java"
HOMEPAGE="http://xml.apache.org/commons/"
SRC_URI="mirror://apache/xml/commons/${MY_P}.tar.gz"

# Resolver is under Apache-1.1
# SAX2 is public-domain
# DOM documentation is under W3C-document
# DOM software is under W3C
# See ${S}/java/external for the license files
LICENSE="Apache-1.1 public-domain W3C-document W3C"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PV}-jdk15.patch"
}

src_compile() {
	local antflags="jar"
	use doc && antflags="${antflags} javadocs"

	cd "${S}"/java
	eant -f resolver.xml ${antflags} || die "XML-Resolver Compile failed"
	eant -f which.xml ${antflags} || die "XML-Which Compile failed"
}

src_install() {
	java-pkg_dojar java/build/which.jar
	java-pkg_dojar java/build/resolver.jar
	java-pkg_dojar java/external/build/xml-apis.jar

	dodoc README.html || die
	use doc && java-pkg_dojavadoc java/build/docs/javadocs
	use source && java-pkg_dosrc java/src/org
}
