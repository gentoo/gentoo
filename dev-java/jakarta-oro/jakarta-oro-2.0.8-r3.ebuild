# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

MY_J=${PN%%-*}
MY_O=${PN##*-}

DESCRIPTION="A set of text-processing Java classes"
HOMEPAGE="http://jakarta.apache.org/oro/index.html"
SRC_URI="http://archive.apache.org/dist/${MY_J}/${MY_O}/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="2.0"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=virtual/jdk-1.3"
RDEPEND=">=virtual/jre-1.3"

java_prepare() {
	find "${WORKDIR}" -name '*.class' -delete
}

EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_newjar ${P}.jar ${PN}.jar

	dodoc CHANGES CONTRIBUTORS ISSUES README STYLE TODO

	if use doc; then
		java-pkg_dojavadoc docs/api
		dohtml -r -A gif docs/*.html docs/images
	fi
	use examples && java-pkg_doexamples src/java/examples
	use source && java-pkg_dosrc src/java/org
}
