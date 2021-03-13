# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-pkg-simple

MY_A="apache-${PN}-${PV}-src"
MY_P="${MY_A/-servlet-api/}"
DESCRIPTION="Tomcat's Servlet API 5.0/JSP API 3.0/EL API 4.0 implementation"
HOMEPAGE="https://tomcat.apache.org/"
SRC_URI="mirror://apache/tomcat/tomcat-10/v${PV}/src/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="5.0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8"

S="${WORKDIR}/${MY_P}/"

# we don't have the aQute.bnd.annotation.spi packaged
PATCHES=(
	"${FILESDIR}/${PN}-10.0.2-patch-out-aQute.bnd.annotation.spi.ServiceConsumer.patch"
)

JAVA_TEST_SRC_DIR="src/test"

SERVLET_API_JAR="servlet-api.jar"
SERVLET_API_SRC="src/main/servlet-api"
SERVLET_API_RESOURCES="src/resources/servlet-api"
EL_API_JAR="el-api.jar"
EL_API_SRC="src/main/el-api"
EL_API_RESOURCES="src/resources/el-api"
JSP_API_JAR="jsp-api.jar"
JSP_API_SRC="src/main/jsp-api"
JSP_API_RESOURCES="src/resources/jsp-api"

src_prepare() {
	default

	# The sources and also resources are mixed together so we first give it a structure to make it easier to compile and package
	mkdir -p ${SERVLET_API_SRC} ${SERVLET_API_RESOURCES} \
		${EL_API_SRC} ${EL_API_RESOURCES} \
		${JSP_API_SRC}/jakarta/servlet ${JSP_API_RESOURCES} \
		${JAVA_TEST_SRC_DIR} || die "Failed to create source directory"

	pushd java || die "Failed to cd to java dir"

	cp --parents -R jakarta/servlet "${S}/${SERVLET_API_SRC}/" || die "Failed to copy servlet-api sources"
	mv "${S}/${SERVLET_API_SRC}/jakarta/servlet/jsp" "${S}/${JSP_API_SRC}/jakarta/servlet" || die "Failed to copy jsp-api sources"
	cp --parents -R jakarta/el "${S}/${EL_API_SRC}/" || die "Failed to copy el-api sources"

	popd

	for file in $(find src -type f | grep -vE "\.java$"); do
		target_dir=$(dirname $file | sed "s%src/main/%src/resources/%g")
		mkdir -p ${target_dir} || die "Failed to create resource directory"
		mv $file ${target_dir} || die "Failed to move resource file"
	done

	mv test/jakarta ${JAVA_TEST_SRC_DIR} || die "Failed to copy test sources"

	java-pkg-2_src_prepare
}

src_compile() {
	JAVA_SRC_DIR="${SERVLET_API_SRC}"
	JAVA_RESOURCE_DIRS="${SERVLET_API_RESOURCES}"
	JAVA_JAR_FILENAME="${SERVLET_API_JAR}"
	java-pkg-simple_src_compile
	rm -fr target || die "Failed to remove compiled files"

	JAVA_SRC_DIR="${EL_API_SRC}"
	JAVA_RESOURCE_DIRS="${EL_API_RESOURCES}"
	JAVA_JAR_FILENAME="${EL_API_JAR}"
	java-pkg-simple_src_compile
	rm -fr target || die "Failed to remove compiled files"

	JAVA_SRC_DIR="${JSP_API_SRC}"
	JAVA_RESOURCE_DIRS="${JSP_API_RESOURCES}"
	JAVA_JAR_FILENAME="${JSP_API_JAR}"
	JAVA_GENTOO_CLASSPATH_EXTRA="servlet-api.jar:el-api.jar"
	java-pkg-simple_src_compile
}

src_install() {
	JAVA_SRC_DIR="${SERVLET_API_SRC}"
	JAVA_JAR_FILENAME="${SERVLET_API_JAR}"
	java-pkg-simple_src_install

	JAVA_SRC_DIR="${EL_API_SRC}"
	JAVA_JAR_FILENAME="${EL_API_JAR}"
	java-pkg-simple_src_install

	JAVA_SRC_DIR="${JSP_API_SRC}"
	JAVA_JAR_FILENAME="${JSP_API_JAR}"
	java-pkg-simple_src_install
}
