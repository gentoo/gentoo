# Copyright 1999-2016 Gentoo Foundation
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
KEYWORDS="amd64 ~arm ppc64 x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE=""
RESTRICT="test"

CDEPEND="
	dev-java/asm:4
	dev-java/gnu-regexp:1
	dev-java/java-getopt:1
	dev-java/ant-core:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	app-arch/unzip"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_TARGET="jar-nojarjar"
EANT_GENTOO_CLASSPATH="
	asm-4
	gnu-regexp-1
	java-getopt-1
	ant-core
"

ANT_TASKS="none"

PATCHES=(
	"${FILESDIR}/0.9-system-jars.patch"
	"${FILESDIR}/0.9-bootclasspath.patch"
)

JAVA_RM_FILES=(
	src/main/com/tonicsystems/jarjar/JarJarMojo.java
)

java_prepare() {
	java-pkg_clean
	epatch "${PATCHES[@]}"
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	java-pkg_register-ant-task
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/main/*
}
