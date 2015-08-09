# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="source test"
inherit base java-pkg-2 java-ant-2

DESCRIPTION="Provides Java values for common platform C constants"
HOMEPAGE="http://kenai.com/projects/constantine"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=virtual/jre-1.5"

DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/ant-junit4 )"

src_compile() {
	# ecj doesn't like some cast for some reason
	java-pkg_force-compiler javac
	java-pkg-2_src_compile
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	use source && java-pkg_dosrc src/*
}

src_test() {
	ANT_TASKS="ant-junit4" eant test -Dlibs.junit_4.classpath="$(java-pkg_getjars --with-dependencies junit-4)"
}
