# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="commons-logging:commons-logging:1.2"

inherit java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="An ultra-thin bridge between different Java logging libraries"
HOMEPAGE="https://commons.apache.org/logging/"
SRC_URI="mirror://apache/commons/logging/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="avalon-framework avalon-logkit log4j servletapi test"
REQUIRED_USE="doc? ( avalon-framework avalon-logkit log4j servletapi )"
RESTRICT="!test? ( test ) !servletapi? ( test )"

CDEPEND="
	avalon-logkit? ( dev-java/avalon-logkit:2.0 )
	avalon-framework? ( dev-java/avalon-framework:4.2 )
	log4j? (
		dev-java/log4j-12-api:2
		dev-java/log4j-api:2
		dev-java/log4j-core:2
	)
	servletapi? ( dev-java/tomcat-servlet-api:4.0 )"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8:*
	test? ( dev-java/ant-junit:0 )"

S="${WORKDIR}/${P}-src"

EANT_BUILD_TARGET="compile"
JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_IGNORE_SYSTEM_CLASSES="yes"

DOCS=( RELEASE-NOTES.txt PROPOSAL.html )

src_prepare() {
	default

	eapply "${FILESDIR}/${P}-gentoo.patch"
	# patch to make the build.xml respect no servletapi
	eapply "${FILESDIR}/${P}-servletapi.patch"

	# bug #208098
	echo "jdk.1.4.present=true" > build.properties || die

	if use avalon-framework; then
		echo "avalon-framework.jar=$(java-pkg_getjars avalon-framework-4.2)" >> build.properties || die
	fi
	if use avalon-logkit; then
		echo "logkit.jar=$(java-pkg_getjars avalon-logkit-2.0)" >> build.properties || die
	fi
	if use log4j; then
		# log4j12.jar can only contain path to one single file because
		# build.xml decides whether the Log4JLogger should be built with
		# <available file="${log4j12.jar}" property="log4j12.present"/>,
		# and a value that contains multiple file paths will cause the
		# test to return a negative result.  However, classes from multiple
		# Log4j 2 JARs are needed to compile the sources.  So, we combine
		# them into a single JAR on the go.
		# https://bugs.gentoo.org/834036
		mkdir -p "${T}/log4j-2" ||
			die "Failed to create temporary directory for Log4j 2 classes"
		pushd "${T}/log4j-2" > /dev/null ||
			die "Failed to enter temporary directory for Log4j 2 classes"

		local jar="$(java-config -j)"
		local dep
		for dep in log4j-{12-api,api,core}; do
			# Assuming SLOT="2" for Log4j 2 dependencies
			"${jar}" -xf "$(java-pkg_getjar "${dep}-2" "${dep}.jar")" ||
				die "Failed to extract files from ${dep}-2 installed on system"
		done
		"${jar}" -cf log4j-2.jar . || die "Failed to create JAR for Log4j"

		popd > /dev/null ||
			die "Failed to leave temporary directory for Log4j 2 classes"

		echo "log4j12.jar=${T}/log4j-2/log4j-2.jar" >> build.properties || die
	fi

	if use servletapi; then
		echo "servletapi.jar=$(java-pkg_getjar tomcat-servlet-api-4.0 servlet-api.jar)" >> build.properties || die
	fi
}

src_install() {
	local pkg=org.apache.commons.logging
	java-osgi_newjar "target/${P}.jar" "${pkg}" "Apache Commons Logging" "${pkg};version=\"${PV}\", ${pkg}.impl;version=\"${PV}\""
	java-pkg_newjar target/${PN}-api-${PV}.jar ${PN}-api.jar
	java-pkg_newjar target/${PN}-adapters-${PV}.jar ${PN}-adapters.jar

	einstalldocs
	use doc && java-pkg_dojavadoc target/docs/
	use source && java-pkg_dosrc src/main/java/org
}

src_test() {
	# Do not run Log4j tests because these tests use an Appender to verify
	# logging correctness.  The log4j-12-api bridge no longer supports using an
	# Appender for verifications since the methods for adding an Appender in
	# the bridge "are largely no-ops".  This means an Appender's state would
	# never be changed by log4j-12-api after new messages are logged.  The test
	# cases, however, expect changes to the Appender's state in such an event,
	# so they would fail with log4j-12-api.
	# https://logging.apache.org/log4j/log4j-2.8/log4j-1.2-api/index.html
	sed -i -e "/^log4j12\.jar=/d" build.properties ||
		die "Failed to skip Log4j tests by modifying build.properties"
	java-pkg-2_src_test
}
