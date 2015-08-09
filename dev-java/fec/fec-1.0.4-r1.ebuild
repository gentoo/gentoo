# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit flag-o-matic java-pkg-2 java-ant-2 toolchain-funcs

DESCRIPTION="Forword error correction libs"
HOMEPAGE="http://www.onionnetworks.com/developers/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND="dev-java/log4j
	dev-java/concurrent-util"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEPEND}"
EANT_BUILD_TARGET="jars"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	sed -i -e 's/build.compiler=jikes/#build.compiler=jikes/g' build.properties || die
	sed -i -e 's/test.lib/lib/g' build.properties || die
	epatch "${FILESDIR}"/${P}-{libfec8path,build,soname}.patch

	eant clean
	cd lib || die
	rm -v *.jar || die
	java-pkg_jar-from log4j
	java-pkg_jar-from concurrent-util concurrent.jar concurrent-jaxed.jar
	cd "${S}" || die
	unzip -q common-20020926.zip || die
	cd common-20020926 || die
	eant clean
	cp -r src/com ../src/ || die
}

src_compile() {
	java-pkg-2_src_compile
	cd "${S}"/src/csrc
	append-flags -fPIC
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS} $(java-pkg_get-jni-cflags)" || die
}

#there seem to be unit tests, but they are in such a state.

src_install() {
	java-pkg_newjar lib/onion-${PN}.jar ${PN}.jar
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/com
	dolib.so src/csrc/libfec{8,16}.so || die
}
