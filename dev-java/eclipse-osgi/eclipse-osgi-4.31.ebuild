# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi System Bundle"
HOMEPAGE="https://projects.eclipse.org/projects/eclipse.equinox"
SRC_URI="https://github.com/eclipse-equinox/equinox/archive/R${PV//./_}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/equinox-R${PV//./_}/bundles/org.eclipse.osgi"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND=">=dev-java/osgi-annotation-8.1.0:0"

DEPEND="
	${CP_DEPEND}
	>=dev-java/osgi-annotation-8.1.0:0
	>=virtual/jdk-11:*
"
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_GENTOO_CLASSPATH_EXTRA=":j9stubs.jar"
JAVA_INTERMEDIATE_JAR_NAME="org.eclipse.osgi"
JAVA_MODULE_INFO_OUT="."
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR=( {container,felix,osgi,supplement}/src )

src_prepare() {
	java-pkg-2_src_prepare
	jar xf osgi/j9stubs.jar || die
	find com -type f -name '*.java' > j9stubs.lst || die
	java-pkg_clean

	mkdir res || die
	find \
		-type f \
		! -name '*.html' \
		! -name '*.java' \
		! -name 'bnd.bnd' \
		! -name 'build.properties' \
		! -name 'pom.xml' \
		! -name 'customBuildCallbacks.xml' \
		! -name 'forceQualifierUpdate.txt' \
		! -name '.classpath*' \
		! -name '.gitignore' \
		! -name '.project' \
		! -path '*/.settings/*' |
		xargs cp --parent -t res || die
	mv res/{container,supplement}/src/org/eclipse/osgi/internal/signedcontent || die
	mv res/{supplement/src/,}org || die
	rm -r res/{container,supplement} || die
}

src_compile() {
	# building j9stubs from source
	ejavac -d target/j9stubs @j9stubs.lst
	jar -cvf j9stubs.jar -C target/j9stubs . || die

	# building eclipse-osgi
	java-pkg-simple_src_compile

	# re-package for moving module-info to root of jar
	mv target/classes/{META-INF/versions/9/,}module-info.class || die
	rm -r target/classes/META-INF/versions eclipse-osgi.jar || die
	jar cf eclipse-osgi.jar -C target/classes . || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar j9stubs.jar
}
