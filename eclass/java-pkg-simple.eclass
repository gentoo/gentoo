# Copyright 2004-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: java-pkg-simple.eclass
# @MAINTAINER:
# java@gentoo.org
# @AUTHOR:
# Java maintainers <java@gentoo.org>
# @BLURB: Eclass for packaging Java software with ease.
# @DESCRIPTION:
# This class is intended to build pure Java packages from Java sources
# without the use of any build instructions shipped with the sources.
# There is no support for generating source files, or for controlling
# the META-INF of the resulting jar, although these issues may be
# addressed by an ebuild by putting corresponding files into the target
# directory before calling the src_compile function of this eclass.

inherit java-utils-2

if ! has java-pkg-2 ${INHERITED}; then
	eerror "java-pkg-simple eclass can only be inherited AFTER java-pkg-2"
fi

EXPORT_FUNCTIONS src_compile src_install src_test

# We are only interested in finding all java source files, wherever they may be.
S="${WORKDIR}"

# handle dependencies for testing frameworks
if has test ${JAVA_PKG_IUSE}; then
	local test_deps
	for framework in ${JAVA_TESTING_FRAMEWORKS}; do
		case ${framework} in
			junit)
				test_deps+=" dev-java/junit:0";;
			junit-4)
				test_deps+=" dev-java/junit:4";;
			pkgdiff)
				test_deps+=" amd64? ( dev-util/pkgdiff
					dev-util/japi-compliance-checker )";;
			testng)
				test_deps+=" dev-java/testng:0";;
		esac
	done
	[[ ${test_deps} ]] && DEPEND="test? ( ${test_deps} )"
fi

# @ECLASS-VARIABLE: JAVA_GENTOO_CLASSPATH
# @DEFAULT_UNSET
# @DESCRIPTION:
# Comma or space separated list of java packages to include in the
# class path. The packages will also be registered as runtime
# dependencies of this new package. Dependencies will be calculated
# transitively. See "java-config -l" for appropriate package names.
#
# @CODE
#	JAVA_GENTOO_CLASSPATH="foo,bar-2"
# @CODE

# @ECLASS-VARIABLE: JAVA_GENTOO_CLASSPATH_EXTRA
# @DEFAULT_UNSET
# @DESCRIPTION:
# Extra list of colon separated path elements to be put on the
# classpath when compiling sources.

# @ECLASS-VARIABLE: JAVA_CLASSPATH_EXTRA
# @DEFAULT_UNSET
# @DESCRIPTION:
# An extra comma or space separated list of java packages
# that are needed only during compiling sources.

# @ECLASS-VARIABLE: JAVA_NEEDS_TOOLS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Add tools.jar to the gentoo.classpath. Should only be used
# for build-time purposes, the dependency is not recorded to
# package.env.

# @ECLASS-VARIABLE: JAVA_SRC_DIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of directories relative to ${S} which contain the sources
# of the application. If you set ${JAVA_SRC_DIR} to a string it works
# as well. The default value "" means it will get all source files
# inside ${S}.
# For the generated source package (if source is listed in
# ${JAVA_PKG_IUSE}), it is important that these directories are
# actually the roots of the corresponding source trees.
#
# @CODE
#	JAVA_SRC_DIR=( "impl/src/main/java/"
#		"arquillian/weld-ee-container/src/main/java/"
#	)
# @CODE

# @DESCRIPTION:
# @ECLASS-VARIABLE: JAVA_RESOURCE_DIRS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of directories relative to ${S} which contain the
# resources of the application. If you do not set the variable,
# there will be no resources added to the compiled jar file.
#
# @CODE
#	JAVA_RESOURCE_DIRS=("src/java/resources/")
# @CODE

# @ECLASS-VARIABLE: JAVA_ENCODING
# @DESCRIPTION:
# The character encoding used in the source files.
: ${JAVA_ENCODING:=UTF-8}

# @ECLASS-VARIABLE: JAVAC_ARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Additional arguments to be passed to javac.

# @ECLASS-VARIABLE: JAVA_MAIN_CLASS
# @DEFAULT_UNSET
# @DESCRIPTION:
# If the java has a main class, you are going to set the
# variable so that we can generate a proper MANIFEST.MF
# and create a launcher.
#
# @CODE
#	JAVA_MAIN_CLASS="org.gentoo.java.ebuilder.Main"
# @CODE

# @ECLASS-VARIABLE: JAVADOC_ARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Additional arguments to be passed to javadoc.

# @ECLASS-VARIABLE: JAVA_JAR_FILENAME
# @DESCRIPTION:
# The name of the jar file to create and install.
: ${JAVA_JAR_FILENAME:=${PN}.jar}

# @ECLASS-VARIABLE: JAVA_BINJAR_FILENAME
# @DEFAULT_UNSET
# @DESCRIPTION:
# The name of the binary jar file to be installed if
# USE FLAG 'binary' is set.

# @ECLASS-VARIABLE: JAVA_LAUNCHER_FILENAME
# @DESCRIPTION:
# If ${JAVA_MAIN_CLASS} is set, we will create a launcher to
# execute the jar, and ${JAVA_LAUNCHER_FILENAME} will be the
# name of the script.
: ${JAVA_LAUNCHER_FILENAME:=${PN}-${SLOT}}

# @ECLASS-VARIABLE: JAVA_TESTING_FRAMEWORKS
# @DEFAULT_UNSET
# @DESCRIPTION:
# A space separated list that defines which tests it should launch
# during src_test.
#
# @CODE
# JAVA_TESTING_FRAMEWORKS="junit pkgdiff"
# @CODE

# @ECLASS-VARIABLE: JAVA_TEST_EXCLUDES
# @DEFAULT_UNSET
# @DESCRIPTION:
# A array of classes that should not be executed during src_test().
#
# @CODE
# JAVA_TEST_EXCLUDES=( "net.sf.cglib.CodeGenTestCase" "net.sf.cglib.TestAll" )
# @CODE

# @ECLASS-VARIABLE: JAVA_TEST_GENTOO_CLASSPATH
# @DEFAULT_UNSET
# @DESCRIPTION:
# The extra classpath we need while compiling and running the
# source code for testing.

# @ECLASS-VARIABLE: JAVA_TEST_SRC_DIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of directories relative to ${S} which contain the
# sources for testing. It is almost equivalent to
# ${JAVA_SRC_DIR} in src_test.

# @ECLASS-VARIABLE: JAVA_TEST_RESOURCE_DIRS
# @DEFAULT_UNSET
# @DESCRIPTION:
# It is almost equivalent to ${JAVA_RESOURCE_DIRS} in src_test.

# @FUNCTION: java-pkg-simple_getclasspath
# @USAGE: java-pkg-simple_getclasspath
# @INTERNAL
# @DESCRIPTION:
# Get proper ${classpath} from ${JAVA_GENTOO_CLASSPATH_EXTRA},
# ${JAVA_NEEDS_TOOLS}, ${JAVA_CLASSPATH_EXTRA} and
# ${JAVA_GENTOO_CLASSPATH}. We use it inside
# java-pkg-simple_src_compile and java-pkg-simple_src_test.
#
# Note that the variable "classpath" needs to be defined before
# calling this function.
java-pkg-simple_getclasspath() {
	debug-print-function ${FUNCNAME} $*

	local dependency
	local deep_jars="--with-dependencies"
	local buildonly_jars="--build-only"

	# the extra classes that are not installed by portage
	classpath+=":${JAVA_GENTOO_CLASSPATH_EXTRA}"

	# whether we need tools.jar
	[[ ${JAVA_NEEDS_TOOLS} ]] && classpath+=":$(java-config --tools)"

	# the extra classes that are installed by portage
	for dependency in ${JAVA_CLASSPATH_EXTRA}; do
		classpath="${classpath}:$(java-pkg_getjars ${buildonly_jars}\
			${deep_jars} ${dependency})"
	done

	# add test dependencies if USE FLAG 'test' is set
	if has test ${JAVA_PKG_IUSE} && use test; then
		for dependency in ${JAVA_TEST_GENTOO_CLASSPATH}; do
			classpath="${classpath}:$(java-pkg_getjars ${buildonly_jars}\
				${deep_jars} ${dependency})"
		done
	fi

	# add the RUNTIME dependencies
	for dependency in ${JAVA_GENTOO_CLASSPATH}; do
		classpath="${classpath}:$(java-pkg_getjars ${deep_jars} ${dependency})"
	done

	# purify classpath
	while [[ $classpath = *::* ]]; do classpath="${classpath//::/:}"; done
	classpath=${classpath%:}
	classpath=${classpath#:}

	debug-print "CLASSPATH=${classpath}"
}

# @FUNCTION: java-pkg-simple_test_with_pkgdiff_
# @INTERNAL
# @DESCRIPTION:
# use japi-compliance-checker the ensure the compabitily of \*.class files,
# Besides, use pkgdiff to ensure the compatibility of resources.
java-pkg-simple_test_with_pkgdiff_() {
	debug-print-function ${FUNCNAME} $*

	if [[ ! ${ARCH} == "amd64" ]]; then
		elog "For architectures other than amd64, "\
			"the pkgdiff test is currently unavailable "\
			"because 'dev-util/japi-compliance-checker "\
			"and 'dev-util/pkgdiff' do not support those architectures."
		return
	fi

	local report1=${PN}-japi-compliance-checker.html
	local report2=${PN}-pkgdiff.html

	# pkgdiff test
	if [[ -f "${DISTDIR}/${JAVA_BINJAR_FILENAME}" ]]; then
		# pkgdiff cannot deal with symlinks, so this is a workaround
		cp "${DISTDIR}/${JAVA_BINJAR_FILENAME}" ./ \
			|| die "Cannot copy binjar file to ${S}."

		# japi-compliance-checker
		japi-compliance-checker ${JAVA_BINJAR_FILENAME} ${JAVA_JAR_FILENAME}\
			--lib=${PN} -v1 ${PV}-bin -v2 ${PV} -report-path ${report1}\
			--binary\
			|| die "japi-compliance-checker returns $?,"\
				"check the report in ${S}/${report1}"

		# ignore META-INF since it does not matter
		# ignore classes because japi-compilance checker will take care of it
		pkgdiff ${JAVA_BINJAR_FILENAME} ${JAVA_JAR_FILENAME}\
			-vnum1 ${PV}-bin -vnum2 ${PV}\
			-skip-pattern "META-INF|.class$"\
			-name ${PN} -report-path ${report2}\
			|| die "pkgdiff returns $?, check the report in ${S}/${report2}"
	fi
}

# @FUNCTION: java-pkg-simple_prepend_resources
# @USAGE: java-pkg-simple_prepend-resources <${classes}> <"${RESOURCE_DIRS[@]}">
# @INTERNAL
# @DESCRIPTION:
# Copy things under "${JAVA_RESOURCE_DIRS[@]}" or "${JAVA_TEST_RESOURCE_DIRS[@]}"
# to ${classes}, so that `jar` will package resources together with classes.
#
# Note that you need to define a "classes" variable before calling
# this function.
java-pkg-simple_prepend_resources() {
	debug-print-function ${FUNCNAME} $*

	local destination="${1}"
	shift 1

	# return if there is no resource dirs defined
	[[ "$@" ]] || return
	local resources=("${@}")

	# add resources directory to classpath
	for resource in "${resources[@]}"; do
		cp -rT "${resource:-.}" "${destination}"\
			|| die "Could not copy resources from ${resource:-.} to ${destination}"
	done
}

# @FUNCTION: java-pkg-simple_src_compile
# @DESCRIPTION:
# src_compile for simple bare source java packages. Finds all *.java
# sources in ${JAVA_SRC_DIR}, compiles them with the classpath
# calculated from ${JAVA_GENTOO_CLASSPATH}, and packages the resulting
# classes to a single ${JAVA_JAR_FILENAME}. If the file
# target/META-INF/MANIFEST.MF exists, it is used as the manifest of the
# created jar.
#
# If USE FLAG 'binary' exists and is set, it will just copy
# ${JAVA_BINJAR_FILENAME} to ${S} and skip the rest of src_compile.
java-pkg-simple_src_compile() {
	local sources=sources.lst classes=target/classes apidoc=target/api

	# auto generate classpath
	java-pkg_gen-cp JAVA_GENTOO_CLASSPATH

	# do not compile if we decide to install binary jar
	if has binary ${JAVA_PKG_IUSE} && use binary; then
		# register the runtime dependencies
		for dependency in ${JAVA_GENTOO_CLASSPATH//,/ }; do
			java-pkg_record-jar_ ${dependency}
		done

		cp "${DISTDIR}"/${JAVA_BINJAR_FILENAME} ${JAVA_JAR_FILENAME}\
			|| die "Could not copy the binary jar file to ${S}"
		return 0
	fi

	# gather sources
	find "${JAVA_SRC_DIR[@]}" -name \*.java > ${sources}

	# create the target directory
	mkdir -p ${classes} || die "Could not create target directory"

	# compile
	local classpath=""
	java-pkg-simple_getclasspath
	java-pkg-simple_prepend_resources ${classes} "${JAVA_RESOURCE_DIRS[@]}"

	ejavac -d ${classes} -encoding ${JAVA_ENCODING}\
		${classpath:+-classpath ${classpath}} ${JAVAC_ARGS}\
		@${sources}

	# javadoc
	if has doc ${JAVA_PKG_IUSE} && use doc; then
		mkdir -p ${apidoc}
		ejavadoc -d ${apidoc} \
			-encoding ${JAVA_ENCODING} -docencoding UTF-8 -charset UTF-8 \
			${classpath:+-classpath ${classpath}} ${JAVADOC_ARGS:- -quiet} \
			@${sources} || die "javadoc failed"
	fi

	# package
	local jar_args
	if [[ -e ${classes}/META-INF/MANIFEST.MF ]]; then
		jar_args="cfm ${JAVA_JAR_FILENAME} ${classes}/META-INF/MANIFEST.MF"
	elif [[ ${JAVA_MAIN_CLASS} ]]; then
		jar_args="cfe ${JAVA_JAR_FILENAME} ${JAVA_MAIN_CLASS}"
	else
		jar_args="cf ${JAVA_JAR_FILENAME}"
	fi
	jar ${jar_args} -C ${classes} . || die "jar failed"
}

# @FUNCTION: java-pkg-simple_src_install
# @DESCRIPTION:
# src_install for simple single jar java packages. Simply installs
# ${JAVA_JAR_FILENAME}. It will also install a launcher if
# ${JAVA_MAIN_CLASS} is set.
java-pkg-simple_src_install() {
	local sources=sources.lst classes=target/classes apidoc=target/api

	# install the jar file that we need
	java-pkg_dojar ${JAVA_JAR_FILENAME}

	# install a wrapper if ${JAVA_MAIN_CLASS} is defined
	if [[ ${JAVA_MAIN_CLASS} ]]; then
		java-pkg_dolauncher "${JAVA_LAUNCHER_FILENAME}" --main ${JAVA_MAIN_CLASS}
	fi

	# javadoc
	if has doc ${JAVA_PKG_IUSE} && use doc; then
		java-pkg_dojavadoc ${apidoc}
	fi

	# dosrc
	if has source ${JAVA_PKG_IUSE} && use source; then
		local srcdirs=""
		if [[ "${JAVA_SRC_DIR[@]}" ]]; then
			local parent child
			for parent in "${JAVA_SRC_DIR[@]}"; do
				srcdirs="${srcdirs} ${parent}"
			done
		else
			# take all directories actually containing any sources
			srcdirs="$(cut -d/ -f1 ${sources} | sort -u)"
		fi
		java-pkg_dosrc ${srcdirs}
	fi
}

# @FUNCTION: java-pkg-simple_src_test
# @DESCRIPTION:
# src_test for simple single java jar file.
# It will perform test with frameworks that are defined in
# ${JAVA_TESTING_FRAMEWORKS}.
java-pkg-simple_src_test() {
	local test_sources=test_sources.lst classes=target/test-classes
	local tests_to_run classpath

	# do not continue if the USE FLAG 'test' is explicitly unset
	# or no ${JAVA_TESTING_FRAMEWORKS} is specified
	if ! has test ${JAVA_PKG_IUSE}; then
		return
	elif ! use test; then
		return
	elif [[ ! "${JAVA_TESTING_FRAMEWORKS}" ]]; then
		return
	fi

	# create the target directory
	mkdir -p ${classes} || die "Could not create target directory for testing"

	# get classpath
	classpath="${classes}:${JAVA_JAR_FILENAME}"
	java-pkg-simple_getclasspath
	java-pkg-simple_prepend_resources ${classes} "${JAVA_TEST_RESOURCE_DIRS[@]}"

	# gathering sources for testing
	find "${JAVA_TEST_SRC_DIR[@]}" -name \*.java > ${test_sources}

	# compile
	[[ -s ${test_sources} ]] && ejavac -d ${classes} ${JAVAC_ARGS} \
		-encoding ${JAVA_ENCODING} ${classpath:+-classpath ${classpath}} \
		@${test_sources}

	# grab a set of tests that testing framework will run
	tests_to_run=$(find "${classes}" -type f\
		\( -name "*Test.class"\
		-o -name "Test*.class"\
		-o -name "*Tests.class"\
		-o -name "*TestCase.class" \)\
		! -name "*Abstract*"\
		! -name "*BaseTest*"\
		! -name "*TestTypes*"\
		! -name "*TestUtils*"\
		! -name "*\$*")
	tests_to_run=${tests_to_run//"${classes}"\/}
	tests_to_run=${tests_to_run//.class}
	tests_to_run=${tests_to_run//\//.}

	# exclude extra test classes, usually corner cases
	# that the code above cannot handle
	for class in "${JAVA_TEST_EXCLUDES[@]}"; do
		tests_to_run=${tests_to_run//${class}}
	done

	# launch test
	for framework in ${JAVA_TESTING_FRAMEWORKS}; do
		case ${framework} in
			junit)
				ejunit -classpath "${classpath}" ${tests_to_run};;
			junit-4)
				ejunit4 -classpath "${classpath}" ${tests_to_run};;
			pkgdiff)
				java-pkg-simple_test_with_pkgdiff_;;
			testng)
				etestng -classpath "${classpath}" ${tests_to_run};;
			*)
				elog "No suitable function found for framework ${framework}"
		esac
	done
}
