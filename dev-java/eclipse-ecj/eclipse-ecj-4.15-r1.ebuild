# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple prefix

DMF="R-${PV}-202003050155"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="https://www.eclipse.org/"
SRC_URI="https://archive.eclipse.org/eclipse/downloads/drops4/${DMF}/ecjsrc-${PV}.jar"
S="${WORKDIR}"

LICENSE="EPL-1.0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
SLOT="4.15"

BDEPEND="
	app-arch/unzip
	app-arch/zip
"
COMMON_DEP="app-eselect/eselect-java"
DEPEND="${COMMON_DEP}
	>=dev-java/ant-1.10.14:0
	>=virtual/jdk-11:*"
RDEPEND="${COMMON_DEP}
	!dev-java/ant-eclipse-ecj:4.15
	>=virtual/jre-1.8:*"

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
