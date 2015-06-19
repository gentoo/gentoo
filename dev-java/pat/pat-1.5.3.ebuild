# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/pat/pat-1.5.3.ebuild,v 1.4 2013/08/14 11:18:05 patrick Exp $

JAVA_PKG_IUSE="doc source"

inherit versionator java-pkg-2

DESCRIPTION="Regular Expressions in Java"
HOMEPAGE="http://www.javaregex.com"

MY_PV=$(delete_all_version_separators)
MAJORMINOR=$(get_version_component_range 1-2)
DOC_VER=$(delete_all_version_separators ${MAJORMINOR})
MY_P=${PN}-${PV}

SRC_URI="http://www.javaregex.com/binaries/${PN}srcfree${MY_PV}.jar
	doc? ( http://www.javaregex.com/binaries/patdocs${DOC_VER}.jar )"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
		app-arch/unzip"

S=${WORKDIR}

src_compile() {
	ejavac $(find . -name "*.java")
	jar cf ${PN}.jar $(find . -name "*.class")
}

src_install() {
	java-pkg_dojar *.jar

	if use doc; then
		dohtml docs/*.{html,jpg}
		java-pkg_dojavadoc docs/javadoc
	fi

	use source && java-pkg_dosrc com
}
