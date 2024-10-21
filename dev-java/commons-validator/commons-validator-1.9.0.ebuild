# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-validator:commons-validator:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Commons component to validate user input, or data input"
HOMEPAGE="https://commons.apache.org/proper/commons-validator/"
SRC_URI="mirror://apache/commons/validator/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/validator/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
RESTRICT="test" #839681

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"

CP_DEPEND="
	dev-java/commons-beanutils:1.7
	dev-java/commons-digester:2.1
	dev-java/commons-logging:0
	dev-java/jakarta-servlet-api:4
	dev-java/slf4j-api:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

src_compile() {
	# getting dependencies into the modulepath
	DEPENDENCIES=(
		commons-beanutils-1.7
		commons-digester-2.1
		commons-logging
		jakarta-servlet-api-4
		slf4j-api
	)
	local modulepath
	for dependency in ${DEPENDENCIES[@]}; do
		modulepath="${modulepath}:$(java-pkg_getjars --build-only ${dependency})"
	done

	local JAVA_MODULE_NAME="org.apache.${PN/-/.}"
	JAVA_JAR_FILENAME="${JAVA_MODULE_NAME}.jar"
	java-pkg-simple_src_compile	# creates a legacy jar file without module-info

	# generate module-info.java
	jdeps \
		--module-path "${modulepath}" \
		--add-modules=ALL-MODULE-PATH \
		--ignore-missing-deps \
		--generate-module-info src/main \
		--multi-release 9 \
		"${JAVA_MODULE_NAME}.jar" || die

	# compile module-info.java
	ejavac \
		-source 9 -target 9 \
		--module-path "${modulepath}" \
		--patch-module "${JAVA_MODULE_NAME}"="${JAVA_MODULE_NAME}.jar" \
		-d target/versions/9 \
		src/main/"${JAVA_MODULE_NAME}"/versions/9/module-info.java

	# package
	JAVA_JAR_FILENAME="${PN}.jar"
	jar cvf "${JAVA_JAR_FILENAME}" \
		-C target/classes . \
		--release 9 -C target/versions/9 . || die
}
