# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Declare the 'doc' USE flag in IUSE -- not JAVA_PKG_IUSE -- to
# prevent java-pkg-simple.eclass from handling Javadoc; instead,
# let this ebuild handle Javadoc generation and installation itself.
# This ebuild invokes java-pkg-simple.eclass's phase functions
# multiple times to build multiple modules, but the eclass always
# installs each module's Javadoc to the same directory, which would
# trigger an error when the second module's Javadoc is installed.
JAVA_PKG_IUSE="source"
IUSE="doc migration-support suite vintage"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Simple framework to write repeatable tests"
HOMEPAGE="https://junit.org/junit5/"
SRC_URI="https://github.com/junit-team/junit5/archive/r${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/junit5-r${PV}"

LICENSE="EPL-2.0"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/apiguardian-api:0
	dev-java/opentest4j:0
	dev-java/open-test-reporting-events:0
	dev-java/picocli:0
	dev-java/univocity-parsers:0
"

# java-utils-2.eclass does not support
# USE-conditional dependencies in CP_DEPEND
COND_DEPEND="
	migration-support? ( dev-java/junit:4 )
	vintage? ( dev-java/junit:4 )
"

# Limiting JDK version to >=11 for module-info.java in this package
# https://bugs.gentoo.org/796875#c3
DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}
	${COND_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
	${COND_DEPEND}
"

src_configure() {
	# Please make sure to declare a module's dependencies before the module itself.
	# Useful upstream documentation regarding modules and dependencies:
	# https://junit.org/junit5/docs/current/user-guide/index.html#dependency-metadata
	# https://junit.org/junit5/docs/current/user-guide/index.html#dependency-diagram
	JUNIT5_MODULES=(
		junit-platform-commons
		junit-platform-engine
		junit-platform-launcher
		junit-platform-reporting
		junit-platform-console # For launching tests from CLI;
		# an eclass would need it to support running tests using JUnit 5

		$(use suite && echo \
			junit-platform-suite-api \
			junit-platform-suite-commons \
			junit-platform-suite-engine \
		)

		junit-jupiter-api
		junit-jupiter-engine # For JUnit Jupiter tests -- the so-called
		# "JUnit 5 tests", which cannot run on earlier JUnit versions
		junit-jupiter-params # For parameterized tests; the junit-jupiter
		# aggregator module includes it, so building it unconditionally
		$(usev migration-support junit-jupiter-migrationsupport)

		$(usev vintage junit-vintage-engine)

		# Modules not included:
		# - junit-bom: Has no sources; solely for helping Maven and Gradle
		#   projects that use JUnit 5 manage dependencies easier
		# - junit-jupiter: Aggregator; does not have 'src/main/java'
		# - junit-platform-console-standalone: Has no sources; solely used
		#   by the upstream to build a fat JAR that bundles everything, so
		#   users can use just this single JAR to run JUnit 5
		# - junit-platform-jfr: For an experimental feature
		# - junit-platform-runner: Deprecated
		# - junit-platform-suite: Aggregator; does not have 'src/main/java'
		# - junit-platform-testkit: Requires >=dev-java/assertj-core-3.14.0
	)
	local cp_packages=()
	(use migration-support || use vintage) && cp_packages+=( junit-4 )
	local save_IFS="${IFS}"
	IFS=',' JAVA_GENTOO_CLASSPATH="${cp_packages[*]}"
	IFS="${save_IFS}"

	JUNIT5_VM_VERSION="$(java-config --get-env PROVIDES_VERSION)"
}

junit5_foreach_module() {
	local module
	for module in "${JUNIT5_MODULES[@]}"; do
		junit5_module_do "${module}" "${@}"
	done
}

junit5_module_do() {
	local module="${1}"
	# Invocation of the passed function will not be guarded by '|| die'.
	# Like the case for multibuild_foreach_variant(), it is recommended
	# that the passed function itself calls 'die'.
	local func=( "${@:2}" )

	einfo "Running '${func[@]}' for ${module} ..."
	pushd "${module}" > /dev/null || die "Failed to enter directory '${module}'"

	# Set up Java eclass variables that are
	# supposed to be set in the ebuild global scope

	local JAVA_JAR_FILENAME="${module}.jar"

	local JAVA_SRC_DIR=(
		src/main/java
		src/module
	)

	local JAVA_RESOURCE_DIRS=()
	local default_resource_dir="src/main/resources"
	[[ -d "${default_resource_dir}" ]] &&
		JAVA_RESOURCE_DIRS+=( "${default_resource_dir}" )

	if [[ "${module}" == junit-platform-console ]]; then
		local JAVA_MAIN_CLASS="org.junit.platform.console.ConsoleLauncher"
		local JAVA_LAUNCHER_FILENAME="${module}"
	fi

	# Invoke the passed function
	"${func[@]}"
	local ret="${?}"

	popd > /dev/null || die "Failed to leave directory '${module}'"
	return "${ret}"
}

junit5_gen_cp() {
	echo "$(java-pkg_getjars --build-only --with-dependencies \
		"${JAVA_GENTOO_CLASSPATH}"):${JAVA_GENTOO_CLASSPATH_EXTRA}"
}

junit5_module_compile() {
	if [[ "${module}" == junit-platform-console ]]; then
		# Unlike other modules that have a src/main/java9 directory, for this
		# module, the upstream puts the class files built from src/main/java9
		# in their JAR's top-level directory instead of META-INF/versions/9
		cp -rv src/main/java9/* src/main/java/ ||
			die "Failed to merge ${module}'s sources for Java 9+"
		# Remove for the [[ -d src/main/java9 ]] test
		# during versioned directory handling
		rm -rv src/main/java9 ||
			die "Failed to remove ${module}'s Java 9+ source directory"
	fi

	java-pkg-simple_src_compile
	local sources="sources.lst"
	local classes="target/classes"

	# Collect a list of all compiler input files for building Javadoc
	local source
	while read source; do
		echo "${module}/${source}" >> "${all_sources}"
	done < "${sources}" ||
		die "Failed to add ${module}'s sources to Javadoc input list"

	# Handle classes that will go into versioned directories.  This will be
	# no longer needed after https://bugs.gentoo.org/900433 is implemented.
	local vm_ver
	for vm_ver in 9 17; do
		local versioned_src="src/main/java${vm_ver}"
		if [[ -d "${versioned_src}" ]]; then
			if ver_test "${JUNIT5_VM_VERSION}" -ge "${vm_ver}"; then
				local versioned_classes="target/${vm_ver}/classes"
				mkdir -p "${versioned_classes}" ||
					die "Failed to create directory for ${module}'s Java ${vm_ver}+ classes"
				ejavac -d "${versioned_classes}" -encoding "${JAVA_ENCODING}" \
					-classpath "${classes}:$(junit5_gen_cp)" ${JAVAC_ARGS} \
					$(find "${versioned_src}" -type f -name '*.java')
				"$(java-config --jar)" -uvf "${JAVA_JAR_FILENAME}" \
					--release "${vm_ver}" -C "${versioned_classes}" . ||
					die "Failed to add ${module}'s Java ${vm_ver}+ classes to JAR"
			else
				# Modules that may hit this branch as of 5.9.2:
				# - junit-platform-console:
				#   src/main/java17/.../ConsoleUtils.java tries to use
				#   java.io.Console.charset() (available since Java 17) to get
				#   the default output charset.  It is fine to not use this
				#   file, even if the built artifacts will be used on JRE 17+,
				#   as src/main/java/.../ConsoleUtils.java still gets the
				#   default from java.nio.charset.Charset.defaultCharset().
				elog "JDK ${JUNIT5_VM_VERSION} used; skipping Java ${vm_ver}-dependent parts in ${module}"
			fi
		fi
	done

	# Add the current module's JAR to classpath
	# for the module's reverse dependencies in this package
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${S}/${module}/${JAVA_JAR_FILENAME}"
}

src_compile() {
	local all_sources="${S}/all-sources.lst"
	junit5_foreach_module junit5_module_compile

	if use doc; then
		einfo "Generating Javadoc for all modules ..."
		local apidoc="target/api"
		mkdir -p "${apidoc}" || die "Failed to create Javadoc directory"
		ejavadoc -d "${apidoc}" \
			-encoding "${JAVA_ENCODING}" -docencoding UTF-8 -charset UTF-8 \
			-classpath "$(junit5_gen_cp)" ${JAVADOC_ARGS:- -quiet} \
			-windowtitle "JUnit ${PV} API" \
			"@${all_sources}"
	fi
}

src_test() {
	# Running the JUnit 5 modules' tests (located in each module's
	# 'src/test/java') has a few obstacles:
	# - Some test sources use text blocks -- a feature introduced in Java 15.
	#   A JDK at a lower version, e.g. 11, cannot compile them.
	# - Some test classes depend on JUnit 5 modules that this ebuild does not
	#   include, like junit-platform-runner and junit-platform-testkit.
	#
	# Therefore, this ebuild uses a simpler approach to test the artifacts just
	# built: it uses the artifacts to run tests in examples under the
	# 'documentation/src' directory.  The test coverage will not be impressive,
	# but at least this approach verifies that the copy of JUnit 5 just built
	# is capable of running some simple tests launched from CLI.

	local JUNIT5_TEST_SRC_DIR="documentation/src/test/java"
	local JUNIT5_TEST_RESOURCE_DIR="documentation/src/test/resources"
	local JUNIT5_TEST_RM=(
		$(usev !migration-support example/IgnoredTestsDemo.java)
		$(use !suite && echo \
			example/DocumentationTestSuite.java \
			example/SuiteDemo.java \
		)
		$(usev !vintage example/JUnit4Tests.java)

		# Need excluded module junit-platform-runner
		example/JUnitPlatformClassDemo.java
		example/JUnitPlatformSuiteDemo.java

		# Need excluded module junit-platform-testkit
		example/testkit/

		# Not necessary for the tests; some files even require extra dependency
		org/junit/api/tools/

		# Needs dev-java/hamcrest; no need to pull in extra dependency
		# as the examples already provide ample tests to run
		example/HamcrestAssertionsDemo.java

		# Makes an HTTP request and expects a certain response
		example/session/HttpTests.java
	)

	pushd "${JUNIT5_TEST_SRC_DIR}" > /dev/null ||
		die "Failed to enter test source directory"
	rm -rv "${JUNIT5_TEST_RM[@]}" ||
		die "Failed to remove unneeded test sources"
	# Test sources expect the working directory to be 'documentation'
	sed -i -e "s|src/test/resources|${JUNIT5_TEST_RESOURCE_DIR}|g" \
		example/ParameterizedTestDemo.java ||
		die "Failed to update file paths in test sources"
	popd > /dev/null || die "Failed to leave test source directory"

	local test_dir="${T}/junit5_src_test"
	local example_classes="${test_dir}/classes"
	local test_classes="${test_dir}/test-classes"
	mkdir -p "${example_classes}" "${test_classes}" ||
		die "Failed to create test directories"

	local example_sources="${test_dir}/sources.lst"
	local test_sources="${test_dir}/test-sources.lst"
	find documentation/src/main/java -type f -name '*.java' > "${example_sources}" ||
		die "Failed to get a list of example sources"
	find documentation/src/test/java -type f -name '*.java' > "${test_sources}" ||
		die "Failed to get a list of test sources"

	ejavac -d "${example_classes}" -encoding "${JAVA_ENCODING}" \
		-classpath "$(junit5_gen_cp)" ${JAVAC_ARGS} \
		"@${example_sources}"

	local test_cp="${example_classes}:${JUNIT5_TEST_RESOURCE_DIR}:$(junit5_gen_cp)"
	ejavac -d "${test_classes}" -encoding "${JAVA_ENCODING}" \
		-classpath "${test_cp}" ${JAVAC_ARGS} \
		"@${test_sources}"

	set -- "$(java-config --java)" -classpath "${test_classes}:${test_cp}" \
		org.junit.platform.console.ConsoleLauncher \
		--disable-ansi-colors --fail-if-no-tests --scan-classpath \
		--include-classname='^(Test.*|.+[.$]Test.*|.*Tests?|.*Demo)$' \
		--exclude-tag="exclude"
	echo "${@}" >&2
	"${@}"
	local status="${?}"
	[[ "${status}" -eq 2 ]] && die "JUnit did not discover any tests"
	[[ "${status}" -eq 0 ]] || die "ConsoleLauncher failed"
}

junit5_module_install() {
	# It is OK to let java-pkg-simple_src_install call einstalldocs for
	# each module as long as each documentation file being installed
	# has a unique filename among _all_ modules; otherwise, some files
	# would overwrite other ones.
	if [[ -f README.md ]]; then
		mv -v README.md "README-${module}.md" ||
			die "Failed to rename ${module}'s README.md"
	fi
	java-pkg-simple_src_install
}

src_install() {
	junit5_foreach_module junit5_module_install
	einstalldocs # For project-global documentation

	if use doc; then
		einfo "Installing Javadoc for all modules ..."
		local apidoc="target/api"
		java-pkg_dojavadoc "${apidoc}"
	fi
}
