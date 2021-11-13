# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_ANT_REWRITE_CLASSPATH=y
JAVA_PKG_IUSE="doc source examples"

EANT_DOC_TARGET="javadocs"
EANT_NEEDS_TOOLS="yes"

MAVEN_ID="javassist:javassist:3.18.2"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Javassist makes Java bytecode manipulation simple"
HOMEPAGE="http://www.csg.is.titech.ac.jp/~chiba/javassist/"
SRC_URI="https://github.com/jboss-javassist/javassist/archive/rel_${PV//./_}_ga_build.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-rel_${PV//./_}_ga_build"

LICENSE="MPL-1.1"
SLOT="3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"
BDEPEND="app-arch/unzip"

src_prepare() {
	default

	find -name "*.jar" -delete || die
}

src_install() {
	java-pkg_dojar ${PN}.jar

	use doc && java-pkg_dojavadoc html
	use source && java-pkg_dosrc src/main/javassist
	use examples && java-pkg_doexamples sample/*

	docinto html
	dodoc Readme.html
}
