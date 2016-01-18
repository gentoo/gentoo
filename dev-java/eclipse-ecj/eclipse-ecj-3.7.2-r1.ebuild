# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit java-pkg-2

MY_PN="ecj"
DMF="R-${PV}-201202080800"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops/${DMF}/${MY_PN}src-${PV}.jar"

LICENSE="EPL-1.0"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
SLOT="3.7"
IUSE="+ant userland_GNU"

COMMON_DEP="
	app-eselect/eselect-java"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.4"
DEPEND="${COMMON_DEP}
	|| ( virtual/jdk:1.7 virtual/jdk:1.6 )
	app-arch/unzip
	userland_GNU? ( sys-apps/findutils )"
PDEPEND="
	ant? ( ~dev-java/ant-eclipse-ecj-${PV} )"

S="${WORKDIR}"

JAVA_PKG_WANT_SOURCE=1.4
JAVA_PKG_WANT_TARGET=1.4

java_prepare() {
	# These have their own package.
	rm -f org/eclipse/jdt/core/JDTCompilerAdapter.java || die
	rm -fr org/eclipse/jdt/internal/antadapter || die

	# upstream build.xml excludes this
	rm META-INF/eclipse.inf
}

src_compile() {
	local javac_opts javac java jar

	javac_opts="$(java-pkg_javac-args) -encoding ISO-8859-1"
	javac="$(java-config -c)"
	java="$(java-config -J)"
	jar="$(java-config -j)"

	find org/ -path org/eclipse/jdt/internal/compiler/apt -prune -o \
		-path org/eclipse/jdt/internal/compiler/tool -prune -o -name '*.java' \
		-print > sources-1.4
	find org/eclipse/jdt/internal/compiler/{apt,tool} -name '*.java' > sources-1.6

	mkdir -p bootstrap || die
	cp -pPR org bootstrap || die
	cd "${S}/bootstrap" || die

	einfo "bootstrapping ${MY_PN} with ${javac} ..."
	${javac} ${javac_opts} @../sources-1.4 || die
	${javac} -encoding ISO-8859-1 -source 1.6 -target 1.6 @../sources-1.6 || die

	find org/ \( -name '*.class' -o -name '*.properties' -o -name '*.rsc' \) \
		-exec ${jar} cf ${MY_PN}.jar {} + || die

	cd "${S}" || die
	einfo "building ${MY_PN} with bootstrapped ${MY_PN} ..."
	${java} -classpath bootstrap/${MY_PN}.jar \
		org.eclipse.jdt.internal.compiler.batch.Main \
		${javac_opts} -nowarn @sources-1.4 || die
	${java} -classpath bootstrap/${MY_PN}.jar \
		org.eclipse.jdt.internal.compiler.batch.Main \
		-encoding ISO-8859-1 -source 1.6 -target 1.6 -nowarn @sources-1.6 || die

	find org/ \( -name '*.class' -o -name '*.properties' -o -name '*.rsc' \) \
		-exec ${jar} cf ${MY_PN}.jar {} + || die
}

src_install() {
	java-pkg_dolauncher ${MY_PN}-${SLOT} --main \
		org.eclipse.jdt.internal.compiler.batch.Main

	# disable the class version verify, this has intentionally
	# some classes with 1.6, but most is 1.4
	JAVA_PKG_STRICT="" java-pkg_dojar ${MY_PN}.jar
}

pkg_postinst() {
	einfo "To select between slots of ECJ..."
	einfo " # eselect ecj"

	eselect ecj update ecj-${SLOT}
}

pkg_postrm() {
	eselect ecj update
}
