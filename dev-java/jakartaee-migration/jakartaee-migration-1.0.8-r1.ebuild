# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.tomcat:jakartaee-migration:1.0.8"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Tomcat tool for migration from Java EE 8 to Jakarta EE 9"
HOMEPAGE="https://tomcat.apache.org"
SRC_URI="mirror://apache/tomcat/${PN}/v${PV}/source/${P}-src.tar.gz -> ${P}-sources.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

CP_DEPEND="
	>=dev-java/ant-1.10.14-r1:0
	dev-java/bcel:0
	>=dev-java/commons-compress-1.26.0:0
	dev-java/commons-io:1
"

# we need jdk-11 just for some tests as those need stuff from newer jdk,
# otherwise the package as of version 1.0.7 compiles fine with jdk 1.8
# with tests disabled
# see bug https://bugs.gentoo.org/910499

DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_MAIN_CLASS="org.apache.tomcat.jakartaee.MigrationCLI"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_EXCLUDES=(
	"org.apache.tomcat.jakartaee.TesterConstants"
)
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	sed -i "s/\${project.version}/${PV}/g" src/main/resources/info.properties
}

src_test() {
	# we need to create jar files for the tests the same way as it's done using pom.xml
	local implementation_version=$(grep Implementation-Version pom.xml | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")
	mkdir -p generated-test/META-INF || die
	pushd generated-test || die
	echo "Implementation-Version: ${implementation_version}" > META-INF/MANIFEST.MF
	ejavac -d . -encoding ${JAVA_ENCODING} $(find "${S}/${JAVA_TEST_SRC_DIR}" -name CommonGatewayInterface.java) || die
	jar cfm cgi-api.jar META-INF/MANIFEST.MF $(find -name CommonGatewayInterface.class) || die
	ejavac -d . -encoding ${JAVA_ENCODING} $(find "${S}/${JAVA_TEST_SRC_DIR}" -name HelloCGI.java) || die
	jar cfm hellocgi.jar META-INF/MANIFEST.MF $(find -name HelloCGI.class) || die
	for enc in rsa dsa ec; do
		cp hellocgi.jar hellocgi-signed-${enc}.jar || die
		jarsigner -keystore "${S}/src/test/resources/keystore.p12" -storepass apache hellocgi-signed-${enc}.jar ${enc} || die
	done
	popd

	java-pkg-simple_src_test
}
