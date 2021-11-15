# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A lightweight dependency injection framework for Java 5 and above"
HOMEPAGE="https://github.com/google/guice/"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="amd64 arm64 ppc64 x86"
RESTRICT="test"

CP_DEPEND="dev-java/aopalliance:1
	>=dev-java/asm-5:4
	>=dev-java/cglib-3.1:3
	dev-java/guava:20
	dev-java/javax-inject:0"

RDEPEND=">=virtual/jre-1.7
	${CP_DEPEND}"

DEPEND=">=virtual/jdk-1.7
	${CP_DEPEND}"

JAVA_PKG_BSFIX_ALL="no"
JAVA_PKG_BSFIX_NAME="build.xml common.xml"
JAVA_ANT_REWRITE_CLASSPATH="yes"

src_prepare() {
	default

	# Where could we get this FREAKIN jar?
	java-pkg_clean ! -name "bnd-*.jar"
}

src_compile() {
	EANT_BUILD_TARGET="compile manifest" java-pkg-2_src_compile
	jar cfm ${PN}.jar build/META-INF/MANIFEST.MF -C build/classes . || die
}

src_install() {
	java-pkg_dojar ${PN}.jar
	dodoc {CONTRIBUTING,README}.md
	use source && java-pkg_dosrc core/src/*
}
