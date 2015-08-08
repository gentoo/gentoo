# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

JAVA_PKG_IUSE="doc source examples"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Ant-tasks to compile various source languages and produce executables, shared and static libraries"
HOMEPAGE="http://ant-contrib.sourceforge.net/"
SRC_URI="mirror://sourceforge/ant-contrib/ant-contrib/${P/_/-}/${P/_beta/b}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEP="
	dev-java/ant-core:0
	dev-java/xerces:2"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.4"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.4"

S="${WORKDIR}/${P/_beta/b}"

java_prepare() {
	find -name '*.jar' -exec rm -v {} + || die

# Doesn't apply any longer.
#	# https://sourceforge.net/tracker/index.php?func=detail&aid=829906&group_id=36177&atid=416920
#	# https://bugs.gentoo.org/show_bug.cgi?id=156596
#	epatch "${FILESDIR}/1.0b4-profiling.patch"
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_BUILD_TARGET="jars"
EANT_DOC_TARGET="javadocs -Dbuild.javadocs=build/api"
EANT_GENTOO_CLASSPATH="ant-core,xerces-2"

# TODO
#src_test() {
#	eant run-tests
#}

src_install() {
	java-pkg_dojar target/lib/${PN}.jar

	java-pkg_register-ant-task

	dodoc NOTICE
	use doc && java-pkg_dojavadoc build/api
	use examples && java-pkg_doexamples src/samples/*
	use source && java-pkg_dosrc src/main/java/*
}
