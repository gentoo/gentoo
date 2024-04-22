# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple prefix

DMF="R-${PV}-202211231800"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="https://projects.eclipse.org/projects/eclipse.jdt"
SRC_URI="https://archive.eclipse.org/eclipse/downloads/drops4/${DMF}/ecjsrc-${PV}.jar"
S="${WORKDIR}"

LICENSE="EPL-1.0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
SLOT="4.26"

BDEPEND="
	app-arch/unzip
	app-arch/zip
"
COMMON_DEP="app-eselect/eselect-java"
DEPEND="${COMMON_DEP}
	>=dev-java/ant-1.10.14:0
	>=virtual/jdk-17:*"
RDEPEND="${COMMON_DEP}
	!dev-java/ant-eclipse-ecj:4.26
	>=virtual/jre-11:*"

JAVA_AUTOMATIC_MODULE_NAME="org.eclipse.jdt.core.compiler.batch"
JAVA_CLASSPATH_EXTRA="ant"
JAVA_JAR_FILENAME="ecj.jar"
JAVA_LAUNCHER_FILENAME="ecj-${SLOT}"
JAVA_MAIN_CLASS="org.eclipse.jdt.internal.compiler.batch.Main"
JAVA_RESOURCE_DIRS="res"

src_prepare() {
	java-pkg-2_src_prepare

	mkdir "${JAVA_RESOURCE_DIRS}" || die
	find org META-INF -type f \
		! -name '*.java' \
		| xargs cp --parent -t "${JAVA_RESOURCE_DIRS}" || die
}

src_compile() {
	java-pkg-simple_src_compile
	#925083
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
