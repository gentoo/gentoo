# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
# 3.36.0 according to
# https://github.com/eclipse-jdt/eclipse.jdt.core/blob/R4_30/org.eclipse.jdt.core.compiler.batch/pom.xml#L20
MAVEN_ID="org.eclipse.jdt:org.eclipse.jdt.core.compiler.batch:3.36.0"

inherit java-pkg-2 java-pkg-simple prefix

DMF="R-${PV/_rc/RC}-202312010110"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="https://www.eclipse.org/"
SRC_URI="https://download.eclipse.org/eclipse/downloads/drops4/${DMF}/ecjsrc-${PV/_rc/RC}.jar"
S="${WORKDIR}"

LICENSE="EPL-1.0"
KEYWORDS="~amd64 ~arm64"
SLOT="4.30"

BDEPEND="
	app-arch/unzip
	app-arch/zip
"
COMMON_DEP="app-eselect/eselect-java"
# ElementsImpl9.java:206: error:
# method does not override or implement a method from a supertype
DEPEND="${COMMON_DEP}
	>=dev-java/ant-1.10.14:0
	>=virtual/jdk-21:*"
# Parser.java:1095: error:
# pattern matching in instanceof is not supported in -source 11
RDEPEND="${COMMON_DEP}
	>=virtual/jre-17:*"

DOCS=( org/eclipse/jdt/core/README.md )

JAVA_AUTOMATIC_MODULE_NAME="org.eclipse.jdt.core.compiler.batch"
JAVA_CLASSPATH_EXTRA="ant"
JAVA_JAR_FILENAME="ecj.jar"
JAVA_LAUNCHER_FILENAME="ecj-${SLOT}"
JAVA_MAIN_CLASS="org.eclipse.jdt.internal.compiler.batch.Main"
JAVA_RESOURCE_DIRS="res"

src_prepare() {
	java-pkg-2_src_prepare

	mkdir "${JAVA_RESOURCE_DIRS}" || die
	find -type f \
		! -name '*.java' \
		| xargs cp --parent -t "${JAVA_RESOURCE_DIRS}" || die
}

src_compile() {
	java-pkg-simple_src_compile
	# Error: A JNI error has occurred, please check your installation and try again
	# Exception in thread "main" java.lang.SecurityException: Invalid signature file digest for Manifest main attributes
	zip -d ecj.jar "META-INF/ECLIPSE_.RSA" || die "Failed to remove ECLIPSE_.RSA"
	zip -d ecj.jar "META-INF/ECLIPSE_.SF" || die "Failed to remove ECLIPSE_.SF"
}

src_install() {
	java-pkg-simple_src_install
	insinto /usr/share/java-config-2/compiler
	doins "${FILESDIR}/ecj-${SLOT}"
	eprefixify "${ED}"/usr/share/java-config-2/compiler/ecj-${SLOT}
}

pkg_postinst() {
	einfo "To select between slots of ECJ..."
	einfo " # eselect ecj"

	eselect ecj update ecj-${SLOT}
}

pkg_postrm() {
	eselect ecj update
}
