# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# Documentation generation is broken.
JAVA_PKG_IUSE="source" # doc

inherit java-pkg-2 java-ant-2 unpacker

DESCRIPTION="Java Solution for Real-Time and Embedded Systems"
SRC_URI="https://dev.gentoo.org/~tomwij/files/dist/${P}.tar.xz
	https://dev.gentoo.org/~tomwij/files/dist/${P}-build.xml.tar.xz"
HOMEPAGE="http://javolution.org"

LICENSE="BSD"
SLOT="6"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/osgi-core-api:0
	dev-java/osgi-compendium:0"

DEPEND=">=virtual/jdk-1.5
	${CDEPEND}
	app-arch/unzip"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

EANT_BUILD_TARGET="package"
JAVA_PKG_BSFIX_NAME="build.xml maven-build.xml"
JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="osgi-core-api,osgi-compendium"

src_unpack() {
	unpacker ${P}.tar.xz
	cd "${S}" || die
	unpacker ${P}-build.xml.tar.xz
}

java_prepare() {
	# Remove bundled libraries.
	find . -name '*.jar' -print -delete || die
	find . -name '*.class' -print -delete || die

	epatch "${FILESDIR}"/${P}-javadoc-fix.patch
}

src_install() {
	java-pkg_newjar core-java/target/${PN}-core-java-${PV}.jar

	dohtml index.html

	# Documentation generation is broken.
	#use doc && java-pkg_dojavadoc core-java/target/site/apidocs
	use source && java-pkg_dosrc core-java/src/main/java/${PN}
}
