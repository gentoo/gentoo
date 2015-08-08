# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Tool for repackaging third-party jars"
SRC_URI="mirror://sourceforge/jarjar/${PN}-src-${PV}.zip"
HOMEPAGE="http://jarjar.sourceforge.net"
LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE=""
COMMON_DEP="
	=dev-java/asm-2.0*
	=dev-java/gnu-regexp-1*
	>=dev-java/ant-core-1.7.0
	dev-java/java-getopt"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/ant-junit )
	app-arch/unzip
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v src/main/com/tonicsystems/jarjar/JarJarMojo.java || die
	rm -vr src/main/gnu || die

	epatch "${FILESDIR}/0.9-system-jars.patch"
	# bug #191378
	epatch "${FILESDIR}/0.9-bootclasspath.patch"

	cd "${S}/lib"
	rm -v *.jar || die
	java-pkg_jar-from asm-2
	java-pkg_jar-from gnu-regexp-1
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from java-getopt-1
}

ANT_TASKS="none"
EANT_BUILD_TARGET="jar-nojarjar"

src_test() {
	# regenerates this
	cp -i dist/${P}.jar "${T}" || die
	cd lib || die
	java-pkg_jar-from junit
	cd ..
	ANT_TASKS="ant-junit" eant test
	cp "${T}/${P}.jar" dist || die
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	java-pkg_register-ant-task
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/main/*
}
