# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="a SVG engine for Java"
HOMEPAGE="https://svgsalamander.dev.java.net/"
# Created from
# https://svgsalamander.dev.java.net/svn/svgsalamander/tags/release-${PV}
# with bundled jars removed.
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="
	dev-java/ant-core:0
	dev-java/javacc:0
"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_ANT_REWRITE_CLASSPATH="yes"

java_prepare() {
	# Delete these so that we don't need junit
	# They run a dialog any way so not useful for us
	rm -vr test/* || die

	cd lib || die
	java-pkg_jar-from --build-only javacc
	java-pkg_jar-from ant-core
}

src_install() {
	java-pkg_dojar build/jar/*.jar
	java-pkg_register-ant-task

	use doc && java-pkg_dojavadoc build/javadoc
	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc src/com
}
