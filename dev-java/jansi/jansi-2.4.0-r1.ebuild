# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/fusesource/jansi/archive/refs/tags/jansi-2.4.0.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jansi-2.4.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.fusesource.jansi:jansi:2.4.0"

inherit java-pkg-2 java-pkg-simple toolchain-funcs

DESCRIPTION="Jansi is a java library for generating and interpreting ANSI escape sequences."
HOMEPAGE="http://fusesource.github.io/jansi"
SRC_URI="https://github.com/fusesource/${PN}/archive/refs/tags/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Compile dependencies
# POM: pom.xml
# test? info.picocli:picocli-codegen:4.5.2 -> !!!artifactId-not-found!!!
# test? org.junit.jupiter:junit-jupiter:5.7.0 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter-params:5.7.0 -> !!!groupId-not-found!!!

DEPEND=">=virtual/jdk-1.8:*"

# junit-jupiter is not available in ::gentoo
#	test? (
#		!!!artifactId-not-found!!!
#		!!!groupId-not-found!!!
#	)
#"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {changelog,readme}.md license.txt )

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_MAIN_CLASS="org.fusesource.jansi.AnsiMain"

# junit-jupiter is not available in ::gentoo
#JAVA_TEST_GENTOO_CLASSPATH="!!!artifactId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!"
#JAVA_TEST_SRC_DIR="src/test/java"
#JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default
	# Remove this directory containing libjansi.so, libjansi.jnilib and jansi.dll
	rm -r "${JAVA_RESOURCE_DIRS}/org/fusesource/jansi/internal/native" || die
}

src_compile() {
	java-pkg-simple_src_compile

	# build native library.
	local args=(
		CCFLAGS="${CFLAGS} ${CXXFLAGS} -Os -fPIC -fvisibility=hidden"
		LINKFLAGS="-shared ${LDFLAGS}"
		CC="$(tc-getCC)"
		STRIP="$(tc-getSTRIP)"
		LIBNAME="libjansi-$(ver_cut 1-2).so"
	)
	emake "${args[@]}" native
}

src_install() {
	# default # https://bugs.gentoo.org/789582
	# default fails with
	# make: *** No rule to make target 'install'.  Stop.
	java-pkg_doso target/native--/libjansi-$(ver_cut 1-2).so
	java-pkg-simple_src_install
}
