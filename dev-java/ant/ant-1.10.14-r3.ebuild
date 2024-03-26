# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_PROVIDES="
	org.apache.ant:ant:${PV}
	org.apache.ant:ant-launcher:${PV}
"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig prefix

DESCRIPTION="Java-based build tool similar to 'make' that uses XML configuration files"
HOMEPAGE="https://ant.apache.org/"
SRC_URI="mirror://apache/ant/source/apache-${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/ant/source/apache-${P}-src.tar.gz.asc )"
S="${WORKDIR}/apache-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="antlr bcel bsf commonslogging commonsnet imageio jai jakartamail javamail jdepend
	jmf jsch junit junit4 junitlauncher log4j oro regexp resolver swing testutil xalan xz"

# At least 10 test cases would fail without network
PROPERTIES="test_network"
RESTRICT="test"

REQUIRED_USE="
	junit4? ( junit )
	test? ( bsf )
	testutil? ( junit )
"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/ant.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-ant )"
# jdk-11:* because it needs java/util/spi/ToolProvider, available since Java 9.
DEPEND="
	>=virtual/jdk-11:*
	bcel? ( dev-java/bcel:0 )
	bsf? ( dev-java/bsf:2.3 )
	commonslogging? ( dev-java/commons-logging:0 )
	commonsnet? ( dev-java/commons-net:0 )
	jai? ( dev-java/sun-jai-bin:0 )
	jakartamail? ( dev-java/jakarta-mail:0 )
	javamail? (
		dev-java/jakarta-activation-api:1
		dev-java/javax-mail:0
	)
	jdepend? ( >=dev-java/jdepend-2.10-r1:0 )
	jsch? ( dev-java/jsch:0 )
	junit4? ( dev-java/junit:4 )
	junit? ( dev-java/junit:4 )
	junitlauncher? ( dev-java/junit:5[vintage] )
	log4j? ( dev-java/log4j-12-api:2 )
	oro? ( dev-java/jakarta-oro:2.0 )
	regexp? ( dev-java/jakarta-regexp:1.4 )
	resolver? ( dev-java/xml-commons-resolver:0 )
	test? (
		dev-java/antunit:0
		dev-java/bsf:2.3[javascript]
		dev-java/bsh:0
		dev-java/hamcrest-library:1.3
		dev-java/xerces:2
	)
	xalan? (
		dev-java/xalan:0
		dev-java/xalan-serializer:0
	)
	xz? ( dev-java/xz-java:0 )
"
RDEPEND="
	!dev-java/ant-apache-regexp
	!dev-java/ant-apache-log4j
	!dev-java/ant-apache-xalan2
	!dev-java/ant-commons-logging
	!<dev-java/ant-core-1.10.14
	!dev-java/ant-swing
	!dev-java/ant-junit4
	!dev-java/ant-testutil
	!dev-java/ant-junitlauncher
	!dev-java/ant-jai
	!dev-java/ant-commons-net
	!dev-java/ant-apache-bsf
	!dev-java/ant-jmf
	!dev-java/ant-apache-oro
	!dev-java/ant-javamail
	!dev-java/ant-junit
	!dev-java/ant-jdepend
	!dev-java/ant-antlr
	!dev-java/ant-apache-bcel
	!dev-java/ant-apache-resolver
	!dev-java/ant-jsch
	!dev-java/ant-xz
	>=virtual/jre-1.8:*
"

DOCS=( CONTRIBUTORS INSTALL NOTICE README WHATSNEW )
PATCHES=(
	"${FILESDIR}/1.10.9-launch.patch"	# reusing this patch since the script has not changed
	"${FILESDIR}/ant-1.10.14-AntlibTest.patch"	# skips  1 of  6 tests
	"${FILESDIR}/ant-1.10.14-AntTest.patch"		# skips  1 of 32 tests
	"${FILESDIR}/ant-1.10.14-JavaTest.patch"	# skips 12 of 38 tests
	"${FILESDIR}/ant-1.10.14-LinkTest.patch"	# skips  4 of 67 tests
	"${FILESDIR}/ant-1.10.14-PathTest.patch"	# skips  1 of 33 tests
)

JAVADOC_SRC_DIRS=(
	ant
	ant-launcher/src/main
)
JAVA_TEST_GENTOO_CLASSPATH="
	bsh
	hamcrest-library-1.3
	junit-4
	xerces-2
"
JAVA_TEST_RESOURCE_DIRS=(
	"src/etc/testcases"
	"src/main"
)
JAVA_TEST_SRC_DIR="src/tests/junit"

# $1 ant-apache-bsf (source directory)
# $2 bsf-2.3  (classpath of external dependency)
taskdeps() {
	if [[ ${task} == $1 ]]; then
		JAVA_CLASSPATH_EXTRA="${2}"
		JAVADOC_CLASSPATH+=" ${2}"
		JAVADOC_SRC_DIRS+=( "${task}/src/main" )
		JAVA_RESOURCE_DIRS="${3}"
	fi
}

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean ! -path "./src/etc/*" # keep test resources

	eprefixify "src/script/ant"

	ANT_TASKS=(
		$(use antlr && echo ant-antlr) # no dependencies
		$(use bcel && echo ant-apache-bcel)
		$(use bsf && echo ant-apache-bsf) # REQUIRED_USE for tests
		$(use log4j && echo ant-apache-log4j)
		$(use oro && echo ant-apache-oro)	# ORO is retired - replace with java.util.regex?
		$(use regexp && echo ant-apache-regexp)
		$(use resolver && echo ant-apache-resolver)
		$(use xalan && echo ant-apache-xalan2)
		$(use commonslogging && echo ant-commons-logging)
		$(use commonsnet && echo ant-commons-net)
		$(use imageio && echo ant-imageio)	# no dependencies
		$(use jai && echo ant-jai)
		$(use jakartamail && echo ant-jakartamail)
		$(use javamail && echo ant-javamail)
		$(use jdepend && echo ant-jdepend)
		$(use jmf && echo ant-jmf)	# no dependencies
		$(use jsch && echo ant-jsch)
		$(use junit && echo ant-junit)	# REQUIRED_USE for junit4 and for testutil
		$(use junit4 && echo ant-junit4)
		$(use junitlauncher && echo ant-junitlauncher)
		# depends on "com.ibm.netrexx:netrexx:2.0.5" which is
		# available on https://www.netrexx.org/downloads.nsp and states:
		# "IBM's last NetRexx release, suitable for JVM versions 1.5 and below [...]"
		# $(use netrexx && echo ant-netrexx) # src/etc/poms/ant-netrexx/pom.xml
		$(use swing && echo ant-swing) # no dependencies
		$(use testutil && echo ant-testutil)
		$(use xz && echo ant-xz)
	)

	# defaultManifest.mf
	sed -e "s:\${project.version}:${PV}:" \
		-i src/main/org/apache/tools/ant/defaultManifest.mf || die

	# version.txt
	local mydate="$(date '+%B %d %Y')"
	echo "VERSION=${PV}" > src/main/org/apache/tools/ant/version.txt || die
	echo "DATE=${mydate}" >> src/main/org/apache/tools/ant/version.txt || die

	# src directory for ant.jar
	mkdir ant || die "cannot create src directory for ant"
	cp -r {src/main/,ant}/org || die "cannot copy ant sources"

	# resources directory for ant.jar according to lines 317-325 src/etc/poms/ant/pom.xml
	local INCLUDES=( $(
		sed -n '/<resources>/,/<\/resources>/p' \
			src/etc/poms/ant/pom.xml \
		| grep org \
		| sed -e 's:.*<include>\(.*\)</include>:\1:' || die
	))
	cp -r {src/,ant}/resources || die "cannot copy ant resources"
	pushd src/main > /dev/null || die "pushd src/main"
		cp --parents -v "${INCLUDES[@]}" ../../ant/resources || die "CANNOT"
	popd > /dev/null || die "popd"

	# Remove sources according to lines 158-187 src/etc/poms/ant/pom.xml
	# We don't remove anything from src/main/org
	local EXCLUDES=$(
		sed -n '/<excludes>/,/<\/excludes/p' \
			src/etc/poms/ant/pom.xml \
		| grep org \
		| sed -e 's:<exclude>\(.*\)</exclude>:ant/\1:' || die
	)
	rm -r ${EXCLUDES} || die
	# Remove one more file directly, could not get it with sed.
	rm ant/org/apache/tools/ant/taskdefs/optional/ANTLR.java || die

	# Same handling for everything between <testExcludes> </testExcludes>
	# Removing non-existing files is not possible: We ignore them ( grep -v ).
	local TEST_EXCLUDES=$(
		sed -n '/<testExcludes>/,/<\/testExcludes/p' \
			src/etc/poms/ant/pom.xml \
		| grep org \
		| grep -v CommonsLoggingListener \
		| grep -v Log4jListener \
		| sed -e 's:<exclude>\(.*\)</exclude>:src/tests/junit/\1:' || die
	)
	rm -r ${TEST_EXCLUDES} || die

	# Prepare a separate JAVA_SRC_DIR directory for each jar file to be created.
	einfo "Copy source files of ant-tasks"
	local task
	for task in ant-launcher "${ANT_TASKS[@]}"; do
		# "${task}/src/main" will be JAVA_SRC_DIR
		mkdir -p "${task}/src/main" || die "mkdir ${task}"
		# Read from pom.xml the file names which can still contain wildcards
		local INCLUDES=( $(
			sed -n '/<includes>/,/<\/includes>/p' "src/etc/poms/${task}/pom.xml" \
			| grep org \
			| sed -e 's:.*<include>\(.*\)</include>:\1:' || die
		))
		local sourcefile
		# Resolve wildcards in file names using find and copy the files to the corresponding
		# "${task}"/src/main directory
	#	echo "${INCLUDES[@]}"
		for sourcefile in "${INCLUDES[@]}"; do
	#		einfo "${task}: ${sourcefile}"
			# Parameter substitution % to remove trailing slash from ${sourcefile}.
			# Applies to ant-jdepend and ant-junitlauncher where find would otherwise fail.
			find  \
				-path "./src/*/${sourcefile%/}" \
				-exec cp -r --parents "{}" \
				"${task}/src/main" \;
		done
	#	tree "${task}"
	done

	# JAVA_RESOURCE_DIRS for ant-junit
	mkdir -p ant-junit/src/resources/org/apache/tools/ant/taskdefs/optional/junit/xsl \
		|| die "junit resource dir"
	cp src/etc/{junit-frames,junit-noframes,junit-frames-saxon,junit-noframes-saxon}.xsl \
		ant-junit/src/resources/org/apache/tools/ant/taskdefs/optional/junit/xsl \
		|| die "junit resources"
}

src_compile() {
	einfo "Compiling ant-launcher.jar"
	JAVA_JAR_FILENAME="ant-launcher.jar"
	JAVA_MAIN_CLASS="org.apache.tools.ant.launch.Launcher"
	JAVA_SRC_DIR="ant-launcher/src/main"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":ant-launcher.jar"
	rm -r target || die

	einfo "Compiling ant.jar"
	JAVA_JAR_FILENAME="ant.jar"
	JAVA_LAUNCHER_FILENAME="ant"
	JAVA_MAIN_CLASS="org.apache.tools.ant.Main"
	JAVA_RESOURCE_DIRS="ant/resources"
	JAVA_SRC_DIR="ant"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":ant.jar"
	rm -r target || die

	local task
	for task in "${ANT_TASKS[@]}"; do
		einfo "Compiling ${task}"
		JAVA_JAR_FILENAME="${task}.jar"
		JAVA_MAIN_CLASS=""
		JAVA_RESOURCE_DIRS=""
		JAVA_SRC_DIR=""

		JAVA_SRC_DIR="${task}/src/main"
		taskdeps ant-apache-bcel bcel
		taskdeps ant-apache-bsf bsf-2.3
		taskdeps ant-apache-log4j log4j-12-api-2
		taskdeps ant-apache-oro jakarta-oro-2.0
		taskdeps ant-apache-regexp jakarta-regexp-1.4
		taskdeps ant-apache-resolver xml-commons-resolver
		taskdeps ant-apache-xalan2 xalan
		taskdeps ant-commons-logging commons-logging
		taskdeps ant-commons-net commons-net
		taskdeps ant-jai sun-jai-bin
		taskdeps ant-jakartamail jakarta-mail
		taskdeps ant-javamail 'javax-mail jakarta-activation-api-1'
		taskdeps ant-jdepend jdepend
		taskdeps ant-jsch jsch
		taskdeps ant-junit junit-4 ant-junit/src/resources
		taskdeps ant-junit4 junit-4
		taskdeps ant-junitlauncher junit-5
		# $(use netrexx && echo ant-netrexx)
		taskdeps ant-xz xz-java

		java-pkg-simple_src_compile
		JAVA_GENTOO_CLASSPATH_EXTRA+=":${task}.jar"
		rm -fr target || die
	done
	use doc && ejavadoc
}

src_test() {
	# Avoid "--with-dependencies" as used by JAVA_TEST_GENTOO_CLASSPATH.
	# dev-java/antunit has a circular dependency with dev-java/ant[test]
	JAVA_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjars --build-only antunit)"
	# according to line 115 src/etc/poms/ant/pom.xml
	jar -cvf src/etc/testcases/org/apache/tools/ant/taskdefs/test2-antlib.jar \
		-C src/etc/testcases taskdefs/test.antlib.xml || die "cannot test2-antlib.jar"

	JAVA_TEST_EXCLUDES=(
		# according to lines 1956-1964 build.xml (abstract classes, not testcases)
		org.apache.tools.ant.taskdefs.TaskdefsTest
		org.apache.tools.ant.BuildFileTest
		org.apache.tools.ant.util.regexp.RegexpMatcherTest
		org.apache.tools.ant.util.regexp.RegexpTest
		org.apache.tools.ant.types.selectors.BaseSelectorTest
		# according to line 1970 build.xml (helper classes, not testcases)
		org.apache.tools.ant.TestHelper
		# lines 2097-2102 build.xml (interactive tests)
		org.apache.tools.ant.taskdefs.TestProcess			# 1. No runnable methods
		# 1) testAll(org.apache.tools.ant.taskdefs.InitializeClassTest)
		# /var/tmp/portage/dev-java/ant-1.10.14/work/apache-ant-1.10.14/
		# src/etc/testcases/taskdefs/initializeclass.xml:24: Java returned: 1
		# 	<pathelement path="${build.tests.value}"/>
		# 	<pathelement location="${java.home}/lib/classes.zip"/>
		org.apache.tools.ant.taskdefs.InitializeClassTest	# Tests run: 1,  Failures: 1
	)

#	tests with patches to be revisited
#	JAVA_TEST_RUN_ONLY=(
#		org.apache.tools.ant.taskdefs.AntlibTest			# Tests run: 6,  Failures: 1 test2-antlib.jar?
#		org.apache.tools.ant.taskdefs.AntTest				# Tests run: 32,  Failures: 1
#		org.apache.tools.ant.taskdefs.JavaTest				# Tests run: 38,  Failures: 12
#		org.apache.tools.ant.taskdefs.modules.LinkTest		# Tests run: 67,  Failures: 4
#		org.apache.tools.ant.types.PathTest					# Tests run: 33,  Failures: 1
#	)

	# according to lines 276-297 src/etc/poms/ant/pom.xml
	JAVA_TEST_EXTRA_ARGS=(
		-Dant.home="${ANT_HOME}"
		-Dbuild.classes.value=../../../target/test-classes	# needed for org.apache.tools.ant.taskdefs.SignJarTest
		-Dbuild.tests.value=target/test-classes
		-Doffline=true
		-Dant.test.basedir.ignore=true
	)
	java-pkg-simple_src_test
}

src_install() {
	java-pkg_dojar ant.jar ant-launcher.jar

	# Compatibility symlink, should be removed after transition period.
	dosym -r /usr/share/ant{,-core}/lib/ant.jar

	for task in "${ANT_TASKS[@]}"; do
		java-pkg_dojar "${task}.jar"
		java-pkg_register-ant-task --version "${PV}" "${task}"
	done

	dobin src/script/ant

	dodir /usr/share/ant/bin
	for each in antRun antRun.pl runant.pl runant.py ; do
		dobin "${S}/src/script/${each}"
	done

	insinto /usr/share/ant/etc
	doins -r src/etc/*.xsl
	insinto /usr/share/ant/etc/checkstyle
	doins -r src/etc/checkstyle/*.xsl

	echo "ANT_HOME=\"${EPREFIX}/usr/share/ant\"" > "${T}/20ant"
	doenvd "${T}/20ant"

	einstalldocs
	if use doc; then
		java-pkg_dojavadoc target/api
		docinto html
		dodoc -r manual
	fi

	use source && java-pkg_dosrc src/main/*
}
