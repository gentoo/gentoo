# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom runtime/impl/pom.xml --download-uri https://github.com/eclipse-ee4j/jaxb-ri/archive/4.0.0-RI.tar.gz --slot 4 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jaxb-runtime-4.0.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.glassfish.jaxb:jaxb-runtime:4.0.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JAXB (JSR 222) Reference Implementation"
HOMEPAGE="https://eclipse-ee4j.github.io/jaxb-ri/"
SRC_URI="https://github.com/eclipse-ee4j/jaxb-ri/archive/${PV}-RI.tar.gz -> jaxb-ri-${PV}.tar.gz"

LICENSE="EPL-1.0"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	>=dev-java/fastinfoset-2.1.0-r1:0
	dev-java/jaxb-api:4
	>=dev-java/jaxb-stax-ex-2.1.0-r1:0
	dev-java/istack-commons-runtime:0
	>=virtual/jdk-11:*
"

# reason: '<>' with anonymous inner classes is not supported in -source 8
#   (use -source 9 or higher to enable '<>' with anonymous inner classes)
RDEPEND=">=virtual/jre-11:*"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/jaxb-ri-${PV}-RI/jaxb-ri"

JAVA_CLASSPATH_EXTRA="fastinfoset,jaxb-stax-ex"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"

src_compile() {
	einfo "Compiling txw-runtime"
	JAVA_SRC_DIR="txw/runtime/src/main/java"
	JAVA_JAR_FILENAME="txw-runtime.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":txw-runtime.jar"
	rm -r target || die

	einfo "Compiling core"
	JAVA_SRC_DIR="core/src/main/java"
	JAVA_RESOURCE_DIRS="core/src/main/resources"
	JAVA_JAR_FILENAME="core.jar"
	JAVA_CLASSPATH_EXTRA+=" istack-commons-runtime,jaxb-api-4"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":core.jar"
	rm -r target || die

	einfo "Compiling runtime"
	JAVA_SRC_DIR="runtime/impl/src/main/java"
	JAVA_RESOURCE_DIRS="runtime/impl/src/main/resources"
	JAVA_JAR_FILENAME="runtime.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":runtime.jar"
	rm -r target || die

	if use doc; then
		einfo "Compiling javadocs"
		rm {core,runtime/impl}/src/main/java/module-info.java || die
		JAVA_SRC_DIR=(
			"txw/runtime/src/main/java"
			"core/src/main/java"
			"runtime/impl/src/main/java"
		)
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_test() {
	einfo "Testing core"
	JAVA_TEST_SRC_DIR="core/src/test/java"
	JAVA_TEST_RESOURCE_DIRS="core/src/test/resources"
	java-pkg-simple_src_test

	einfo "Testing runtime"
	JAVA_TEST_SRC_DIR="runtime/impl/src/test/java"
	JAVA_TEST_RESOURCE_DIRS=()
	java-pkg-simple_src_test
}

src_install() {
	einstalldocs

	java-pkg_dojar "txw-runtime.jar"
	java-pkg_dojar "core.jar"
	java-pkg_dojar "runtime.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "txw/runtime/src/main/java/*"
		java-pkg_dosrc "core/src/main/java/*"
		java-pkg_dosrc "runtime/impl/src/main/java/*"
	fi
}
