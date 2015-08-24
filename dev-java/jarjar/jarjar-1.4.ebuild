# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Tool for repackaging third-party jars"
SRC_URI="https://jarjar.googlecode.com/files/${PN}-src-${PV}.zip"
HOMEPAGE="http://jarjar.sourceforge.net"
LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64 x86 ppc ppc64 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE=""

CDEPEND="
	dev-java/asm:4
	dev-java/gnu-regexp:1
	dev-java/java-getopt:1
	dev-java/ant-core:0"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

RESTRICT='test'

# FIXME: tests fail to pass.
#src_test() {
#	# regenerates this
#	cp -i dist/${P}.jar "${T}" || die
#	cd lib || die
#	java-pkg_jar-from junit
#	cd ..
#	ANT_TASKS="ant-junit" eant test
#	cp "${T}/${P}.jar" dist || die
#}

src_unpack() {
	unpack ${A}

	cd "${S}" || die
	rm -v src/main/com/tonicsystems/jarjar/JarJarMojo.java || die

	cd "${S}/lib" || die
	rm -v *.jar || die

	java-pkg_jar-from asm-4
	java-pkg_jar-from gnu-regexp-1
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from java-getopt-1
}

src_prepare() {
	epatch "${FILESDIR}/0.9-system-jars.patch"

	# bug #191378
	epatch "${FILESDIR}/0.9-bootclasspath.patch"
}

ANT_TASKS="none"
EANT_BUILD_TARGET="jar-nojarjar"

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	java-pkg_register-ant-task
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/main/*
}
