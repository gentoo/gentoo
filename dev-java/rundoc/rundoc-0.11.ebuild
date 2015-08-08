# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="A Ant helper task for keeping documentation in source files"
HOMEPAGE="http://www.martiansoftware.com/lab/index.html"
SRC_URI="http://www.martiansoftware.com/lab/${PN}/${P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

COMMON_DEP=">=dev-java/ant-core-1.5.4"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v *.jar
	java-ant_rewrite-classpath
}

EANT_GENTOO_CLASSPATH="ant-core"

src_install() {
	java-pkg_newjar dist/${P}.jar

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/java/com
}
