# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/hamcrest-core/hamcrest-core-1.1.ebuild,v 1.16 2015/07/11 09:21:22 chewi Exp $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

MY_PN="hamcrest"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Library of matchers for building test expressions"
HOMEPAGE="http://code.google.com/p/${MY_PN}/"
SRC_URI="http://${MY_PN}.googlecode.com/files/${MY_P}.tgz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-macos ~x64-solaris"
IUSE=""

DEPEND=">=virtual/jdk-1.5
	>=dev-java/jarjar-0.9
	=dev-java/qdox-1.6*"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	find . -name "*.jar" -delete || die

	# These jars must be symlinked as specifying them using gentoo.classpath
	# does not work and both compilation and test fail
	java-pkg_jar-from --into lib/generator --build-only qdox-1.6 qdox.jar qdox-1.6.1.jar
}

src_compile() {
	ANT_TASKS="jarjar-1" eant core -Dversion=${PV}
}

src_install() {
	java-pkg_newjar build/${P}.jar

	dodoc README.txt CHANGES.txt || die

	use source && java-pkg_dosrc ${PN}/src/main/java/org
}
