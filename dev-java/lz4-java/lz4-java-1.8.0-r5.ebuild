# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.lz4:lz4-java:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple toolchain-funcs

DESCRIPTION="LZ4 compression for Java"
HOMEPAGE="https://github.com/lz4/lz4-java"
SRC_URI="https://github.com/lz4/lz4-java/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	app-arch/lz4:=
	dev-java/mvel:2.5
	dev-libs/xxhash:0
	>=virtual/jdk-1.8:*
	test? ( dev-java/randomized-runner:0 )"
RDEPEND="
	app-arch/lz4:=
	>=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}/${P}-fix-load.patch" )

DOCS=( CHANGES.md README.md )

JAVA_AUTOMATIC_MODULE_NAME="org.lz4.java"
JAVA_SRC_DIR=( src/java{,-unsafe} )
JAVA_TEST_GENTOO_CLASSPATH="junit-4 randomized-runner"
JAVA_TEST_RESOURCE_DIRS="src/test-resources"
JAVA_TEST_SRC_DIR="src/test"

src_prepare() {
	default
}

src_compile() {
	# remove precompiled native libraries
	rm -r src/resources || die

	# cannot include template 'decompressor.template': file not found.]
	cp src/build/source_templates/* . || die

	einfo "Code generation"
	"$(java-config -J)" \
		-Dout.dir="src/java" \
		-cp "$(java-pkg_getjars --build-only mvel-2.5)" \
		org.mvel2.sh.Main \
		src/build/gen_sources.mvel \
		|| die

	java-pkg-simple_src_compile

	einfo "Generate headers" # build.xml lines 194-204
	ejavac -h build/jni-headers -classpath "target/classes" \
		src/java/net/jpountz/xxhash/XXHashJNI.java \
		src/java/net/jpountz/lz4/LZ4JNI.java || die

	einfo "Generate native library"
	# https://devmanual.gentoo.org/ebuild-writing/functions/src_compile/no-build-system
	mkdir -p build/objects/src/jni
	mkdir -p build/jni/net/jpountz/util/linux/amd64
	"$(tc-getCC)" ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} \
		$(java-pkg_get-jni-cflags) \
		-Ibuild/jni-headers \
		-c -o build/objects/src/jni/net_jpountz_lz4_LZ4JNI.o \
		src/jni/net_jpountz_lz4_LZ4JNI.c
	"$(tc-getCC)" ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} \
		$(java-pkg_get-jni-cflags) \
		-Ibuild/jni-headers \
		-c -o build/objects/src/jni/net_jpountz_xxhash_XXHashJNI.o \
		src/jni/net_jpountz_xxhash_XXHashJNI.c

	"$(tc-getCC)" ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} \
		-shared \
		-Wl,-soname,liblz4-java.so \
		-o liblz4-java.so \
		build/objects/src/jni/net_jpountz_lz4_LZ4JNI.o \
		build/objects/src/jni/net_jpountz_xxhash_XXHashJNI.o -llz4 -lxxhash
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_doso liblz4-java.so
}
