# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.logging.log4j:log4j-api:${PV}"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="The Apache Log4j API"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.zip
	verify-sig? ( https://downloads.apache.org/logging/log4j/${PV}/apache-log4j-${PV}-src.zip.asc )"
S="${WORKDIR}/log4j-api"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/logging.apache.org.asc"
BDEPEND="
	app-arch/unzip
	app-arch/zip
	verify-sig? ( sec-keys/openpgp-keys-apache-logging )
"

DEPEND="
	dev-java/bnd-annotation:0
	dev-java/error-prone-annotations:0
	dev-java/findbugs-annotations:0
	dev-java/jspecify:0
	dev-java/osgi-annotation:0
	dev-java/osgi-core:0
	>=virtual/jdk-11:*
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="
	bnd-annotation
	error-prone-annotations
	findbugs-annotations
	jspecify
	osgi-annotation
	osgi-core
"

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p src/main/resources/META-INF/services || die "mkdir"
	echo "org.apache.logging.log4j.util.EnvironmentPropertySource" \
		> src/main/resources/META-INF/services/org.apache.logging.log4j.util.PropertySource \
		|| die "META-INF/services"
	echo "org.apache.logging.log4j.util.SystemPropertiesPropertySource" \
		>> src/main/resources/META-INF/services/org.apache.logging.log4j.util.PropertySource \
		|| die "META-INF/services"
}

src_compile() {
	local modulepath
	for dependency in ${JAVA_CLASSPATH_EXTRA[@]}; do
		modulepath="${modulepath}:$(java-pkg_getjars --build-only ${dependency})"
	done

	local JAVA_MODULE_NAME="org.apache.logging.log4j"
	JAVA_JAR_FILENAME="${JAVA_MODULE_NAME}.jar"
	java-pkg-simple_src_compile	# creates a legacy jar file without module-info

	# generate module-info.java
	local JAVA_MODULE_NAME="org.apache.logging.log4j"
	jdeps \
		--module-path "${modulepath}" \
		--add-modules=ALL-MODULE-PATH \
		--generate-module-info . \
		--multi-release 9 \
		"${JAVA_MODULE_NAME}.jar" || die "jdeps"

	# add module-info to java9 sources
	mv {org.apache.logging.log4j/versions/9/,../log4j-api-java9/src/main/java}/module-info.java \
		|| die "move module-info"

	# compile ../log4j-api-java9
	ejavac \
		-source 9 -target 9 \
		--module-path "${modulepath}" \
		--module-version ${PV} \
		--patch-module "${JAVA_MODULE_NAME}"="${JAVA_MODULE_NAME}.jar" \
		-d raw/versions/9 \
		-sourcepath ../log4j-api-java9/src/main/java \
		$(find ../log4j-api-java9/src/main/java -type f -name '*.java')

	# cherrypick versions/9 according to ../log4j-api-java9/src/assembly/java9.xml
	mkdir -p META-INF/versions/9/org/apache/logging/log4j/util/internal || die "mkdir"
	cp {raw,META-INF}/versions/9/org/apache/logging/log4j/util/Base64Util.class
	cp {raw,META-INF}/versions/9/org/apache/logging/log4j/util/ProcessIdUtil.class
	cp {raw,META-INF}/versions/9/org/apache/logging/log4j/util/StackLocator.class
	cp {raw,META-INF}/versions/9/org/apache/logging/log4j/util/internal/DefaultObjectInputFilter.class

	# upstream has module-info.class in root of jar file
	mv {raw/versions/9,target/classes}/module-info.class

	JAVA_JAR_FILENAME="${PN}.jar"
	jar cvf "${JAVA_JAR_FILENAME}" \
		-C target/classes . || die "jar cvf"

	# cannot use java packager since 2 classes would fail validation
	zip -mr ${JAVA_JAR_FILENAME} META-INF/versions/9 || die "update using zip"

	echo "Multi-Release: true" > MANIFEST.MF || die "MANIFEST.MF"
	jar ufmv ${JAVA_JAR_FILENAME} "MANIFEST.MF" || die "update MANIFEST.MF"
}
