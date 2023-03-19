# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.yaml:snakeyaml:2.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="YAML 1.1 parser and emitter for Java"
HOMEPAGE="https://bitbucket.org/snakeyaml/snakeyaml"
SRC_URI="https://bitbucket.org/${PN}/${PN}/get/${P}.tar.gz"
S="${WORKDIR}/snakeyaml-snakeyaml-59ddbb3304bb"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# Compile dependencies
# POM: pom.xml
# test? joda-time:joda-time:2.11.2 -> >=dev-java/joda-time-2.11.2:0
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# test? org.apache.velocity:velocity-engine-core:2.3 -> >=dev-java/velocity-2.3:0
# test? org.projectlombok:lombok:1.18.24 -> !!!groupId-not-found!!!

DEPEND="
	>=virtual/jdk-11:*
	test? (
		dev-java/velocity:0
		dev-java/joda-time:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="joda-time,junit-4,velocity"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

# Workaround for https://bugs.gentoo.org/900433
# src/main/java9/org/yaml/snakeyaml/internal/Logger.java:16:
# error: duplicate class: org.yaml.snakeyaml.internal.Logger
src_prepare() {
	java-pkg-2_src_prepare
	mv src/main/java{9,}/module-info.java || die
}

src_test() {
	export EnvironmentKey1="EnvironmentValue1"
	export EnvironmentEmpty=""

	# Not packaged org.projectlombok:lombok - https://bugs.gentoo.org/868684
	rm src/test/java/org/yaml/snakeyaml/env/EnvLombokTest.java || die # Tests run: 1
	rm src/test/java/org/yaml/snakeyaml/issues/issue387/YamlExecuteProcessContextTest.java || die # Tests run: 1
	rm src/test/java/org/yaml/snakeyaml/env/ApplicationProperties.java || die # No tests # import lombok.

	# https://bugs.gentoo.org/871744
	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * -name "*Test.java" \
			! -name "StressTest.java" \
			! -name "ParallelTest.java" \
			! -name "AbstractTest.java" \
			! -name "PyImportTest.java" \
			! -name "Fuzzer50355Test.java" \
			! -name "ContextClassLoaderTest.java" \
			)
	popd

	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"

	java-pkg-simple_src_test
}
