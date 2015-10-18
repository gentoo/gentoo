# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit flag-o-matic toolchain-funcs java-pkg-2 java-ant-2

DESCRIPTION="Forward Error Correction library in Java"
HOMEPAGE="https://bitbucket.org/onionnetworks/"
SRC_URI="http://dev.gentoo.org/~monsieurp/packages/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/log4j:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

PATCHES=(
	"${FILESDIR}"/"${P}-libfec8path.patch"
	"${FILESDIR}"/"${P}-build.patch"
	"${FILESDIR}"/"${P}-soname.patch"
	"${FILESDIR}"/"${P}-remove-concurrent-util-imports.patch"
)

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="log4j"
EANT_BUILD_TARGET="jars"

# There seems to be unit tests, but they are in such a state.
RESTRICT="test"

java_prepare() {
	# In fact, we'll wipe tests altogether.
	rm -rf tests || die

	# Apply patches.
	epatch "${PATCHES[@]}"

	# Get rid of bundled jars.
	java-pkg_clean
}

src_compile() {
	java-pkg-2_src_compile
	einfo "Sucessfully compiled Java classes!"

	cd "${S}"/src/csrc || die
	append-flags -fPIC
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS} $(java-pkg_get-jni-cflags)" || die
	einfo "Sucessfully compiled C files!"
}

src_install() {
	java-pkg_newjar "lib/onion-${PN}.jar" "${PN}.jar"
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/com
	dolib.so src/csrc/libfec{8,16}.so || die
}
