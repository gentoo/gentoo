# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2 java-ant-2

MY_P="${PN}-${PV/_beta/b}"
DESCRIPTION="Ant tasks to compile various source languages and produce executables, shared and static libraries"
HOMEPAGE="http://ant-contrib.sourceforge.net/"
SRC_URI="mirror://sourceforge/ant-contrib/${MY_P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc source examples"

RDEPEND=">=virtual/jre-1.4
	 >=dev-java/ant-core-1.7
	 >=dev-java/xerces-2.7"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}
	source? ( app-arch/zip )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	# https://sourceforge.net/tracker/index.php?func=detail&aid=829906&group_id=36177&atid=416920
	# https://bugs.gentoo.org/show_bug.cgi?id=156596
	epatch "${FILESDIR}/1.0b4-profiling.patch"

	cd "${S}"
	# in svn but missing from the release
	cp "${FILESDIR}/antlib.xml" src/net/sf/antcontrib/cpptasks/antlib.xml || die
	rm -v *.jar || die
	java-ant_rewrite-classpath
}

EANT_BUILD_TARGET="jars"
EANT_DOC_TARGET="javadocs -Dbuild.javadocs=build/api"
EANT_GENTOO_CLASSPATH="ant-core,xerces-2"

#The actual files for testing are not part of the release
#src_test() {
#	eant run-tests
#}

src_install() {
	java-pkg_dojar build/lib/${PN}.jar

	java-pkg_register-ant-task

	dodoc NOTICE || die
	use doc && java-pkg_dojavadoc build/api
	use examples && dodoc samples/*
	use source && java-pkg_dosrc src/net

}
