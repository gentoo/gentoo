# Copyright 2004-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: java-pkg-simple.eclass
# @MAINTAINER:
# java@gentoo.org
# @AUTHOR:
# Java maintainers <java@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for packaging Java software with ease.
# @DESCRIPTION:
# This class is intended to build pure Java packages from Java sources
# without the use of any build instructions shipped with the sources.
# There is no support for generating source files, or for controlling
# the META-INF of the resulting jar, although these issues may be
# addressed by an ebuild by putting corresponding files into the target
# directory before calling the src_compile function of this eclass.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_JAVA_PKG_SIMPLE_ECLASS} ]] ; then
_JAVA_PKG_SIMPLE_ECLASS=1

inherit java-utils-2

if ! has java-pkg-2 ${INHERITED}; then
	eerror "java-pkg-simple eclass can only be inherited AFTER java-pkg-2"
fi

# We are only interested in finding all java source files, wherever they may be.
S="${WORKDIR}"

# handle dependencies for testing frameworks
if has test ${JAVA_PKG_IUSE}; then
	test_deps=
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
				[[ ${PN} != testng ]] && \
					test_deps+=" dev-java/testng:0";;
		esac
	done
	[[ ${test_deps} ]] && DEPEND="test? ( ${test_deps} )"
	unset test_deps
fi

# @ECLASS_VARIABLE: JAVA_GENTOO_CLASSPATH
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

# @ECLASS_VARIABLE: JAVA_GENTOO_CLASSPATH_EXTRA
# @DEFAULT_UNSET
# @DESCRIPTION:
# Extra list of colon separated path elements to be put on the
# classpath when compiling sources.

# @ECLASS_VARIABLE: JAVA_CLASSPATH_EXTRA
# @DEFAULT_UNSET
# @DESCRIPTION:
# An extra comma or space separated list of java packages
# that are needed only during compiling sources.

# @ECLASS_VARIABLE: JAVA_NEEDS_TOOLS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Add tools.jar to the gentoo.classpath. Should only be used
# for build-time purposes, the dependency is not recorded to
# package.env.

# @ECLASS_VARIABLE: JAVA_SRC_DIR
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
# @ECLASS_VARIABLE: JAVA_RESOURCE_DIRS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of directories relative to ${S} which contain the
# resources of the application. If you do not set the variable,
# there will be no resources added to the compiled jar file.
#
# @CODE
#	JAVA_RESOURCE_DIRS=("src/java/resources/")
# @CODE

# @ECLASS_VARIABLE: JAVA_ENCODING
# @DESCRIPTION:
# The character encoding used in the source files.
: "${JAVA_ENCODING:=UTF-8}"

# @ECLASS_VARIABLE: JAVAC_ARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Additional arguments to be passed to javac.

# @ECLASS_VARIABLE: JAVA_MAIN_CLASS
# @DEFAULT_UNSET
# @DESCRIPTION:
# If the java has a main class, you are going to set the
# variable so that we can generate a proper MANIFEST.MF
# and create a launcher.
#
# @CODE
#	JAVA_MAIN_CLASS="org.gentoo.java.ebuilder.Main"
# @CODE

# @ECLASS_VARIABLE: JAVA_AUTOMATIC_MODULE_NAME
# @DEFAULT_UNSET
# @DESCRIPTION:
# The value of the Automatic-Module-Name entry, which is going to be added to
# MANIFEST.MF.

# @ECLASS_VARIABLE: JAVADOC_ARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Additional arguments to be passed to javadoc.

# @ECLASS_VARIABLE: JAVA_JAR_FILENAME
# @DESCRIPTION:
# The name of the jar file to create and install.
: "${JAVA_JAR_FILENAME:=${PN}.jar}"

# @ECLASS_VARIABLE: JAVA_BINJAR_FILENAME
# @DEFAULT_UNSET
# @DESCRIPTION:
# The name of the binary jar file to be installed if
# USE FLAG 'binary' is set.

# @ECLASS_VARIABLE: JAVA_LAUNCHER_FILENAME
# @DESCRIPTION:
# If ${JAVA_MAIN_CLASS} is set, we will create a launcher to
# execute the jar, and ${JAVA_LAUNCHER_FILENAME} will be the
# name of the script.
if [[ ${SLOT} = 0 ]]; then
	: "${JAVA_LAUNCHER_FILENAME:=${PN}}"
else
	: "${JAVA_LAUNCHER_FILENAME:=${PN}-${SLOT}}"
fi

# @ECLASS_VARIABLE: JAVA_TESTING_FRAMEWORKS
# @DEFAULT_UNSET
# @DESCRIPTION:
# A space separated list that defines which tests it should launch
# during src_test.
#
# @CODE
# JAVA_TESTING_FRAMEWORKS="junit pkgdiff"
# @CODE

# @ECLASS_VARIABLE: JAVA_TEST_RUN_ONLY
# @DEFAULT_UNSET
# @DESCRIPTION:
# A array of classes that should be executed during src_test(). This variable
# has precedence over JAVA_TEST_EXCLUDES, that is if this variable is set,
# the other variable is ignored.
#
# @CODE
# JAVA_TEST_RUN_ONLY=( "net.sf.cglib.AllTests" "net.sf.cglib.TestAll" )
# @CODE

# @ECLASS_VARIABLE: JAVA_TEST_EXCLUDES
# @DEFAULT_UNSET
# @DESCRIPTION:
# A array of classes that should not be executed during src_test().
#
# @CODE
# JAVA_TEST_EXCLUDES=( "net.sf.cglib.CodeGenTestCase" "net.sf.cglib.TestAll" )
# @CODE

# @ECLASS_VARIABLE: JAVA_TEST_GENTOO_CLASSPATH
# @DEFAULT_UNSET
# @DESCRIPTION:
# The extra classpath we need while compiling and running the
# source code for testing.

# @ECLASS_VARIABLE: JAVA_TEST_SRC_DIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of directories relative to ${S} which contain the
# sources for testing. It is almost equivalent to
# ${JAVA_SRC_DIR} in src_test.

# @ECLASS_VARIABLE: JAVA_TEST_RESOURCE_DIRS
# @DEFAULT_UNSET
# @DESCRIPTION:
# It is almost equivalent to ${JAVA_RESOURCE_DIRS} in src_test.

# @ECLASS_VARIABLE: JAVADOC_CLASSPATH
# @DEFAULT_UNSET
# @DESCRIPTION:
# Comma or space separated list of java packages that are needed for generating
# javadocs. Can be used to avoid overloading the compile classpath in multi-jar
# packages if there are jar files which have different dependencies.
#
# @CODE
# Example:
# 	JAVADOC_CLASSPATH="
# 		jna-4
# 		jsch
# 	"
# @CODE

# @ECLASS_VARIABLE: JAVADOC_SRC_DIRS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of directories relative to ${S} which contain the sources of
# the application. It needs to sit in global scope; if put in src_compile()
# it would not work.
# It is needed to decide whether to call java-pkg-simple_call_ejavadoc or not.
# If this variable is defined then java-pkg-simple_src_compile will not call
# java-pkg-simple_call_ejavadoc automatically. java-pkg-simple_call_ejavadoc
# has then to be called explicitly from the ebuild. It is meant for usage in
# multi-jar packages in order to avoid an extra compilation run only for
# producing the javadocs.
#
# @CODE
# Example:
#	JAVADOC_SRC_DIRS=(
#	    "${PN}-core"
#	    "${PN}-jsch"
#	    "${PN}-pageant"
#	    "${PN}-sshagent"
#	    "${PN}-usocket-jna"
#	    "${PN}-usocket-nc"
#	    "${PN}-connector-factory"
#	)
# @CODE

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

# @FUNCTION: java-pkg-simple_getmodules
# @USAGE: java-pkg-simple_getmodules
# @INTERNAL
# @DESCRIPTION:
# Get proper ${moduleinfo} and ${modulesourcepath} from provided pathes.
# We use it inside java-pkg-simple_src_compile, java-pkg-simple_do_ejavadoc and
# java-pkg-simple_src_test.
#
# Note that the variables "moduleinfo" and "modulesourcepath" need to be
# defined before calling this function.
java-pkg-simple_getmodules() {
	debug-print-function ${FUNCNAME} $*

	local moduleinfostring
	moduleinfostring="$(find "$@" -name module-info.java)" || die
	readarray -t moduleinfo <<<"${moduleinfostring}" || die
	if [[ ${#moduleinfo[@]} -gt 1 ]]; then
		local module modulename
		for module in "${moduleinfo[@]}"; do
			modulename="$(grep -Po '(?<=module ).*(?= {)' "${module}")" || die
			modulesourcepath+=( --module-source-path "${modulename}=${module%/module-info.java}" )
		done
	fi

	debug-print "MODULEINFO=${moduleinfo[*]}"
	debug-print "MODULESOURCEPATH=${modulesourcepath[*]}"
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

# @FUNCTION: java-pkg-simple_call_ejavadoc
# @USAGE: java-pkg-simple_call_ejavadoc
# @DESCRIPTION:
# Calls ejavadoc to generate documentation from source files found in
# JAVADOC_SRC_DIRS. If this variable is not set, take JAVA_SRC_DIR
# instead.
java-pkg-simple_call_ejavadoc() {
	local sources=docsources.lst apidoc=target/api
	local moduleinfo modulesourcepath

	if ! [[ ${JAVADOC_SRC_DIRS} ]]; then
		local JAVADOC_SRC_DIRS
		JAVADOC_SRC_DIRS=( "${JAVA_SRC_DIR[@]}" )
	fi

	local classpath=""
	java-pkg-simple_getclasspath
	local dependency
	for dependency in ${JAVADOC_CLASSPATH}; do
		classpath="${classpath}:$(java-pkg_getjars \
			--build-only \
			--with-dependencies \
			${dependency})"
	done

	# gather sources
	# if target < 9, we need to compile module-info.java separately
	# as this feature is not supported before Java 9
	local target="$(java-pkg_get-target)"
	if [[ ${target#1.} -lt 9 ]]; then
		find "${JAVADOC_SRC_DIRS[@]}" -name \*.java ! -name module-info.java > ${sources}
	else
		find "${JAVADOC_SRC_DIRS[@]}" -name \*.java > ${sources}
	fi
	java-pkg-simple_getmodules "${JAVADOC_SRC_DIRS[@]}"

	# create the target directory
	mkdir -p ${apidoc} || die

	if [[ -z ${moduleinfo} ]] || [[ ${target#1.} -lt 9 ]]; then
		ejavadoc -d ${apidoc} \
			-encoding ${JAVA_ENCODING} -docencoding UTF-8 -charset UTF-8 \
			${classpath:+-classpath ${classpath}} ${JAVADOC_ARGS:- -quiet} \
			@${sources} || die "javadoc failed"
	else
		ejavadoc -d ${apidoc} "${modulesourcepath[@]}" \
			-encoding ${JAVA_ENCODING} -docencoding UTF-8 -charset UTF-8 \
			${classpath:+--module-path ${classpath}} ${JAVADOC_ARGS:- -quiet} \
			@${sources} || die "javadoc failed"
	fi
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
	local sources=sources.lst classes=target/classes
	local moduleinfo modulesourcepath

	# do not compile if we decide to install binary jar
	if has binary ${JAVA_PKG_IUSE} && use binary; then
		# register the runtime dependencies
		for dependency in ${JAVA_GENTOO_CLASSPATH//,/ }; do
			java-pkg_record-jar_ ${dependency}
		done

		cp "${DISTDIR}"/${JAVA_BINJAR_FILENAME} ${JAVA_JAR_FILENAME}\
			|| die "Could not copy the binary jar file to ${S}"
		return 0
	else
		# auto generate classpath
		java-pkg_gen-cp JAVA_GENTOO_CLASSPATH
	fi

	# gather sources
	# if target < 9, we need to compile module-info.java separately
	# as this feature is not supported before Java 9
	local target="$(java-pkg_get-target)"
	if [[ ${target#1.} -lt 9 ]]; then
		find "${JAVA_SRC_DIR[@]}" -name \*.java ! -name module-info.java > ${sources}
	else
		find "${JAVA_SRC_DIR[@]}" -name \*.java > ${sources}
	fi
	java-pkg-simple_getmodules "${JAVA_SRC_DIR[@]}"

	# create the target directory
	mkdir -p ${classes} || die "Could not create target directory"

	# compile
	local classpath=""
	java-pkg-simple_getclasspath
	java-pkg-simple_prepend_resources ${classes} "${JAVA_RESOURCE_DIRS[@]}"

	if [[ -z ${moduleinfo} ]] || [[ ${target#1.} -lt 9 ]]; then
		ejavac -d ${classes} -encoding ${JAVA_ENCODING}\
			${classpath:+-classpath ${classpath}} ${JAVAC_ARGS} @${sources}
	else
		ejavac -d ${classes} "${modulesourcepath[@]}" -encoding ${JAVA_ENCODING}\
			${classpath:+--module-path ${classpath}} --module-version ${PV}\
			${JAVAC_ARGS} @${sources}
	fi

	# handle module-info.java separately as it needs at least JDK 9
	if [[ -n ${moduleinfo} ]] && [[ ${target#1.} -lt 9 ]]; then
		if java-pkg_is-vm-version-ge "9" ; then
			local tmp_source=${JAVA_PKG_WANT_SOURCE} tmp_target=${JAVA_PKG_WANT_TARGET}

			JAVA_PKG_WANT_SOURCE="9"
			JAVA_PKG_WANT_TARGET="9"
			ejavac -d ${classes} "${modulesourcepath[@]}" -encoding ${JAVA_ENCODING}\
				${classpath:+--module-path ${classpath}} --module-version ${PV}\
				${JAVAC_ARGS} "${moduleinfo[@]}"

			JAVA_PKG_WANT_SOURCE=${tmp_source}
			JAVA_PKG_WANT_TARGET=${tmp_target}
		else
			eqawarn "Need at least JDK 9 to compile module-info.java in src_compile."
			eqawarn "Please adjust DEPEND accordingly. See https://bugs.gentoo.org/796875#c3"
		fi
	fi

	# javadoc
	if has doc ${JAVA_PKG_IUSE} && use doc; then
		if [[ ${JAVADOC_SRC_DIRS} ]]; then
			einfo "JAVADOC_SRC_DIRS exists, you need to call java-pkg-simple_call_ejavadoc separately"
		else
			java-pkg-simple_call_ejavadoc
		fi
	fi

	# package
	local jar_args
	if [[ -e ${classes}/META-INF/MANIFEST.MF ]]; then
		sed '/Created-By: /Id' -i ${classes}/META-INF/MANIFEST.MF
		jar_args="cfm ${JAVA_JAR_FILENAME} ${classes}/META-INF/MANIFEST.MF"
	else
		jar_args="cf ${JAVA_JAR_FILENAME}"
	fi
	jar ${jar_args} -C ${classes} . || die "jar failed"
	if  [[ -n "${JAVA_AUTOMATIC_MODULE_NAME}" ]]; then
		echo "Automatic-Module-Name: ${JAVA_AUTOMATIC_MODULE_NAME}" \
			>> "${T}/add-to-MANIFEST.MF" || die "adding module name failed"
	fi
	if  [[ -n "${JAVA_MAIN_CLASS}" ]]; then
		echo "Main-Class: ${JAVA_MAIN_CLASS}" \
			>> "${T}/add-to-MANIFEST.MF" || die "adding main class failed"
	fi
	if [[ -f "${T}/add-to-MANIFEST.MF" ]]; then
		jar ufmv ${JAVA_JAR_FILENAME} "${T}/add-to-MANIFEST.MF" \
			|| die "updating MANIFEST.MF failed"
		rm -f "${T}/add-to-MANIFEST.MF" || die "cannot remove"
	fi
}

# @FUNCTION: java-pkg-simple_src_install
# @DESCRIPTION:
# src_install for simple single jar java packages. Simply installs
# ${JAVA_JAR_FILENAME}. It will also install a launcher if
# ${JAVA_MAIN_CLASS} is set. Also invokes einstalldocs.
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

	einstalldocs
}

# @FUNCTION: java-pkg-simple_src_test
# @DESCRIPTION:
# src_test for simple single java jar file.
# It will compile test classes from test sources using ejavac and perform tests
# with frameworks that are defined in ${JAVA_TESTING_FRAMEWORKS}.
# test-classes compiled with alternative compilers like groovyc need to be placed
# in the "generated-test" directory as content of this directory is preserved,
# whereas content of target/test-classes is removed.
java-pkg-simple_src_test() {
	local test_sources=test_sources.lst classes=target/test-classes
	local moduleinfo modulesourcepath
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

	# https://bugs.gentoo.org/906311
	# This will remove target/test-classes. Do not put any test-classes there manually.
	rm -rf ${classes} || die

	# create the target directory
	mkdir -p ${classes} || die "Could not create target directory for testing"

	# generated test classes should get compiled into "generated-test" directory
	if [[ -d generated-test ]]; then
		cp -r generated-test/* "${classes}" || die "cannot copy generated test classes"
	fi

	# get classpath
	classpath="${classes}:${JAVA_JAR_FILENAME}"
	java-pkg-simple_getclasspath
	java-pkg-simple_prepend_resources ${classes} "${JAVA_TEST_RESOURCE_DIRS[@]}"

	# gathering sources for testing
	# if target < 9, we need to compile module-info.java separately
	# as this feature is not supported before Java 9
	local target="$(java-pkg_get-target)"
	if [[ ${target#1.} -lt 9 ]]; then
		find "${JAVA_TEST_SRC_DIR[@]}" -name \*.java ! -name module-info.java > ${test_sources}
	else
		find "${JAVA_TEST_SRC_DIR[@]}" -name \*.java > ${test_sources}
	fi
	java-pkg-simple_getmodules "${JAVA_TEST_SRC_DIR[@]}"

	# compile
	if [[ -s ${test_sources} ]]; then
		if [[ -z ${moduleinfo} ]] || [[ ${target#1.} -lt 9 ]]; then
			ejavac -d ${classes} -encoding ${JAVA_ENCODING}\
				${classpath:+-classpath ${classpath}} ${JAVAC_ARGS} @${test_sources}
		else
			ejavac -d ${classes} "${modulesourcepath[@]}" -encoding ${JAVA_ENCODING}\
				${classpath:+--module-path ${classpath}} --module-version ${PV}\
				${JAVAC_ARGS} @${test_sources}
		fi
	fi

	# handle module-info.java separately as it needs at least JDK 9
	if [[ -n ${moduleinfo} ]] && [[ ${target#1.} -lt 9 ]]; then
		if java-pkg_is-vm-version-ge "9" ; then
			local tmp_source=${JAVA_PKG_WANT_SOURCE} tmp_target=${JAVA_PKG_WANT_TARGET}

			JAVA_PKG_WANT_SOURCE="9"
			JAVA_PKG_WANT_TARGET="9"
			ejavac -d ${classes} "${modulesourcepath[@]}" -encoding ${JAVA_ENCODING}\
				${classpath:+--module-path ${classpath}} --module-version ${PV}\
				${JAVAC_ARGS} "${moduleinfo[@]}"

			JAVA_PKG_WANT_SOURCE=${tmp_source}
			JAVA_PKG_WANT_TARGET=${tmp_target}
		else
			ewarn "Need at least JDK 9 to compile module-info.java in src_test,"
			ewarn "see https://bugs.gentoo.org/796875"
		fi
	fi

	# grab a set of tests that testing framework will run
	if [[ -n ${JAVA_TEST_RUN_ONLY} ]]; then
		tests_to_run="${JAVA_TEST_RUN_ONLY[@]}"
	else
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
	fi

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

fi

EXPORT_FUNCTIONS src_compile src_install src_test
