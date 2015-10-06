# Copyright 2004-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: java-ant-2.eclass
# @MAINTAINER:
# java@gentoo.org
# @AUTHOR:
# kiorky (kiorky@cryptelium.net), Petteri Räty (betelgeuse@gentoo.org)
# @BLURB: eclass for ant based Java packages
# @DESCRIPTION:
# Eclass for Ant-based Java packages. Provides support for both automatic and
# manual manipulation of build.xml files. Should be inherited after java-pkg-2
# or java-pkg-opt-2 eclass.

inherit java-utils-2 multilib

# This eclass provides functionality for Java packages which use
# ant to build. In particular, it will attempt to fix build.xml files, so that
# they use the appropriate 'target' and 'source' attributes.

# @ECLASS-VARIABLE: WANT_ANT_TASKS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An $IFS separated list of ant tasks.
# Ebuild can specify this variable before inheriting java-ant-2 eclass to
# determine ANT_TASKS it needs. They will be automatically translated to
# DEPEND variable and ANT_TASKS variable. JAVA_PKG_FORCE_ANT_TASKS can override
# ANT_TASKS set by WANT_ANT_TASKS, but not the DEPEND due to caching.
# Ebuilds that need to depend conditionally on certain tasks and specify them
# differently for different eant calls can't use this simplified approach.
# You also cannot specify version or anything else than ant-*.
#
# @CODE
# WANT_ANT_TASKS="ant-junit ant-trax"
# @CODE

#The implementation of dependencies is handled by java-utils-2.eclass
#WANT_ANT_TASKS

# @ECLASS-VARIABLE: JAVA_ANT_DISABLE_ANT_CORE_DEP
# @DEFAULT_UNSET
# @DESCRIPTION:
# Setting this variable non-empty before inheriting java-ant-2 disables adding
# dev-java/ant-core into DEPEND.
if [[ -z "${JAVA_ANT_DISABLE_ANT_CORE_DEP}" ]]; then
	JAVA_ANT_E_DEPEND+=" >=dev-java/ant-core-1.8.2"
	[[ "${EAPI:-0}" != 0 ]] && JAVA_ANT_E_DEPEND+=":0"
fi

# add ant tasks specified in WANT_ANT_TASKS to DEPEND
local ANT_TASKS_DEPEND;
ANT_TASKS_DEPEND="$(java-pkg_ant-tasks-depend)"
# check that java-pkg_ant-tasks-depend didn't fail
if [[ $? != 0 ]]; then
	eerror "${ANT_TASKS_DEPEND}"
	die "java-pkg_ant-tasks-depend() failed"
fi

# We need some tools from javatoolkit. We also need portage 2.1 for phase hooks
# and ant dependencies constructed above. Python is there for
# java-ant_remove-taskdefs
JAVA_ANT_E_DEPEND="${JAVA_ANT_E_DEPEND}
	   ${ANT_TASKS_DEPEND}
	   ${JAVA_PKG_PORTAGE_DEP}
	   >=dev-java/javatoolkit-0.3.0-r2"

# this eclass must be inherited after java-pkg-2 or java-pkg-opt-2
# if it's java-pkg-opt-2, ant dependencies are pulled based on USE flag
if has java-pkg-opt-2 ${INHERITED}; then
	JAVA_ANT_E_DEPEND="${JAVA_PKG_OPT_USE}? ( ${JAVA_ANT_E_DEPEND} )"
elif ! has java-pkg-2 ${INHERITED}; then
	eerror "java-ant-2 eclass can only be inherited AFTER java-pkg-2 or java-pkg-opt-2"
fi

DEPEND="${JAVA_ANT_E_DEPEND}"

# @ECLASS-VARIABLE: JAVA_PKG_BSFIX
# @DESCRIPTION:
# Should we attempt to 'fix' ant build files to include the source/target
# attributes when calling javac?
JAVA_PKG_BSFIX=${JAVA_PKG_BSFIX:-"on"}

# @ECLASS-VARIABLE: JAVA_PKG_BSFIX_ALL
# @DESCRIPTION:
# If we're fixing build files, should we try to fix all the ones we can find?
JAVA_PKG_BSFIX_ALL=${JAVA_PKG_BSFIX_ALL:-"yes"}

# @ECLASS-VARIABLE: JAVA_PKG_BSFIX_NAME
# @DESCRIPTION:
# Filename of build files to fix/search for
JAVA_PKG_BSFIX_NAME=${JAVA_PKG_BSFIX_NAME:-"build.xml"}

# @ECLASS-VARIABLE: JAVA_PKG_BSFIX_TARGET_TAGS
# @DESCRIPTION:
# Targets to fix the 'source' attribute in
JAVA_PKG_BSFIX_TARGET_TAGS=${JAVA_PKG_BSFIX_TARGET_TAGS:-"javac xjavac javac.preset"}

# @ECLASS-VARIABLE: JAVA_PKG_BSFIX_SOURCE_TAGS
# @DESCRIPTION:
# Targets to fix the 'target' attribute in
JAVA_PKG_BSFIX_SOURCE_TAGS=${JAVA_PKG_BSFIX_SOURCE_TAGS:-"javadoc javac xjavac javac.preset"}

# @ECLASS-VARIABLE: JAVA_ANT_CLASSPATH_TAGS
# @DESCRIPTION:
# Targets to add the classpath attribute to
JAVA_ANT_CLASSPATH_TAGS="javac xjavac"

# @ECLASS-VARIABLE: JAVA_ANT_IGNORE_SYSTEM_CLASSES
# @DEFAULT_UNSET
# @DESCRIPTION:
# When set, <available> Ant tasks are rewritten to ignore Ant's runtime classpath.

case "${EAPI:-0}" in
	0|1) : ;;
	*) EXPORT_FUNCTIONS src_configure ;;
esac

# @FUNCTION: java-ant-2_src_configure
# @DESCRIPTION:
# src_configure rewrites the build.xml files automatically, unless EAPI is undefined, 0 or 1.
java-ant-2_src_configure() {
	# if java support is optional, don't perform this when the USE flag is off
	if has java-pkg-opt-2 ${INHERITED}; then
		use ${JAVA_PKG_OPT_USE} || return
	fi

	# eant will call us unless called by Portage
	[[ -e "${T}/java-ant-2_src_configure-run" ]] && return

	[[ "${JAVA_ANT_IGNORE_SYSTEM_CLASSES}" ]] \
		&& java-ant_ignore-system-classes "${S}/build.xml"

	java-ant_bsfix
	touch "${T}/java-ant-2_src_configure-run"
}

# @FUNCTION: java-ant_bsfix
# @INTERNAL
# @DESCRIPTION:
# Attempts to fix build files.
#
# @CODE
# Affected by variables:
# 	JAVA_PKG_BSFIX
#	JAVA_PKG_BSFIX_ALL
#	JAVA_PKG_BSFIX_NAME,
# @CODE
java-ant_bsfix() {
	debug-print-function ${FUNCNAME} $*

	[[ "${JAVA_PKG_BSFIX}" != "on" ]] && return
	if ! java-pkg_needs-vm; then
		echo "QA Notice: Package is using java-ant, but doesn't depend on a Java VM"
	fi

	pushd "${S}" >/dev/null

	local find_args=""
	[[ "${JAVA_PKG_BSFIX_ALL}" == "yes" ]] || find_args="-maxdepth 1"

	find_args="${find_args} -type f ( -name ${JAVA_PKG_BSFIX_NAME// / -o -name } )"

	# This voodoo is done for paths with spaces
	local bsfix_these
	while read line; do
		[[ -z ${line} ]] && continue
		bsfix_these="${bsfix_these} '${line}'"
	done <<-EOF
			$(find . ${find_args})
		EOF

	[[ "${bsfix_these// /}" ]] && eval java-ant_bsfix_files ${bsfix_these}

	popd > /dev/null
}

_bsfix_die() {
	if has_version dev-python/pyxml; then
		eerror "If the output above contains:"
		eerror "ImportError:"
		eerror "/usr/lib/python2.4/site-packages/_xmlplus/parsers/pyexpat.so:"
		eerror "undefined symbol: PyUnicodeUCS2_DecodeUTF8"
		eerror "Try re-emerging dev-python/pyxml"
		die ${1} " Look at the eerror message above"
	else
		die ${1}
	fi
}

# @FUNCTION: java-ant_bsfix_files
# @USAGE: <path/to/first/build.xml> [path/to/second.build.xml ...]
# @DESCRIPTION:
# Attempts to fix named build files.
#
# @CODE
# Affected by variables:
#	JAVA_PKG_BSFIX_SOURCE_TAGS
#	JAVA_PKG_BSFIX_TARGET_TAGS
#	JAVA_ANT_REWRITE_CLASSPATH
#	JAVA_ANT_JAVADOC_INPUT_DIRS: Where we can find java sources for javadoc
#                                input. Can be a space separated list of
#                                directories
#	JAVA_ANT_BSFIX_EXTRA_ARGS: You can use this to pass extra variables to the
#	                           rewriter if you know what you are doing.
# @CODE
#
# If JAVA_ANT_JAVADOC_INPUT_DIRS is set, we will turn on the adding of a basic
# javadoc target to the ant's build.xml with the javadoc xml-rewriter feature.
# Then we will set EANT DOC TARGET to the added javadoc target
# NOTE: the variable JAVA_ANT_JAVADOC_OUTPUT_DIR points where we will
#       generate the javadocs. This is a read-only variable, dont change it.

# When changing this function, make sure that it works with paths with spaces in
# them.
java-ant_bsfix_files() {
	debug-print-function ${FUNCNAME} $*

	[[ ${#} = 0 ]] && die "${FUNCNAME} called without arguments"

	local want_source="$(java-pkg_get-source)"
	local want_target="$(java-pkg_get-target)"

	debug-print "${FUNCNAME}: target: ${want_target} source: ${want_source}"

	if [ -z "${want_source}" -o -z "${want_target}" ]; then
		eerror "Could not find valid -source/-target values"
		eerror "Please file a bug about this on bugs.gentoo.org"
		die "Could not find valid -source/-target values"
	else
		local files

		for file in "${@}"; do
			debug-print "${FUNCNAME}: ${file}"

			if [[ -n "${JAVA_PKG_DEBUG}" ]]; then
				cp "${file}" "${file}.orig" || die "failed to copy ${file}"
			fi

			if [[ ! -w "${file}" ]]; then
				chmod u+w "${file}" || die "chmod u+w ${file} failed"
			fi

			files="${files} -f '${file}'"
		done

		# for javadoc target and all in one pass, we need the new rewriter.
		local rewriter3="/usr/share/javatoolkit/xml-rewrite-3.py"
		if [[ ! -f ${rewriter3} ]]; then
			rewriter3="/usr/$(get_libdir)/javatoolkit/bin/xml-rewrite-3.py"
		fi

		local rewriter4="/usr/$(get_libdir)/javatoolkit/bin/build-xml-rewrite"

		if [[ -x ${rewriter4} && ${JAVA_ANT_ENCODING} ]]; then
			[[ ${JAVA_ANT_REWRITE_CLASSPATH} ]] && local gcp="-g"
			[[ ${JAVA_ANT_ENCODING} ]] && local enc="-e ${JAVA_ANT_ENCODING}"
			eval echo "cElementTree rewriter"
			debug-print "${rewriter4} extra args: ${gcp} ${enc}"
			${rewriter4} ${gcp} ${enc} \
				-c "${JAVA_PKG_BSFIX_SOURCE_TAGS}" source ${want_source} \
				-c "${JAVA_PKG_BSFIX_TARGET_TAGS}" target ${want_target} \
				"${@}" || die "build-xml-rewrite failed"
		elif [[ ! -f ${rewriter3} ]]; then
			debug-print "Using second generation rewriter"
			eval echo "Rewriting source attributes"
			eval xml-rewrite-2.py ${files} \
				-c -e ${JAVA_PKG_BSFIX_SOURCE_TAGS// / -e } \
				-a source -v ${want_source} || _bsfix_die "xml-rewrite2 failed: ${file}"

			eval echo "Rewriting target attributes"
			eval xml-rewrite-2.py ${files} \
				-c -e ${JAVA_PKG_BSFIX_TARGET_TAGS// / -e } \
				-a target -v ${want_target} || _bsfix_die "xml-rewrite2 failed: ${file}"

			eval echo "Rewriting nowarn attributes"
			eval xml-rewrite-2.py ${files} \
				-c -e ${JAVA_PKG_BSFIX_TARGET_TAGS// / -e } \
				-a nowarn -v yes || _bsfix_die "xml-rewrite2 failed: ${file}"

			if [[ ${JAVA_ANT_REWRITE_CLASSPATH} ]]; then
				eval echo "Adding gentoo.classpath to javac tasks"
				eval xml-rewrite-2.py ${files} \
					 -c -e javac -e xjavac -a classpath -v \
					 '\${gentoo.classpath}' \
					 || _bsfix_die "xml-rewrite2 failed"
			fi
		else
			debug-print "Using third generation rewriter"
			eval echo "Rewriting attributes"
			local bsfix_extra_args=""
			# WARNING KEEP THE ORDER, ESPECIALLY FOR CHANGED ATTRIBUTES!
			if [[ -n ${JAVA_ANT_REWRITE_CLASSPATH} ]]; then
				local cp_tags="${JAVA_ANT_CLASSPATH_TAGS// / -e }"
				bsfix_extra_args="${bsfix_extra_args} -g -e ${cp_tags}"
				bsfix_extra_args="${bsfix_extra_args} -a classpath -v '\${gentoo.classpath}'"
			fi
			if [[ -n ${JAVA_ANT_JAVADOC_INPUT_DIRS} ]]; then
				if [[ -n ${JAVA_ANT_JAVADOC_OUTPUT_DIR} ]]; then
					die "Do not define JAVA_ANT_JAVADOC_OUTPUT_DIR!"
				fi
				# Where will our generated javadoc go.
				readonly JAVA_ANT_JAVADOC_OUTPUT_DIR="${WORKDIR}/gentoo_javadoc"
				mkdir -p "${JAVA_ANT_JAVADOC_OUTPUT_DIR}" || die

				if has doc ${IUSE}; then
					if use doc; then
						if [[ -z ${EANT_DOC_TARGET} ]]; then
							EANT_DOC_TARGET="gentoojavadoc"
						else
							die "You can't use javadoc adding and set EANT_DOC_TARGET too."
						fi

						for dir in ${JAVA_ANT_JAVADOC_INPUT_DIRS};do
							if [[ ! -d ${dir} ]]; then
								eerror "This dir: ${dir} doesnt' exists"
								die "You must specify directories for javadoc input/output dirs."
							fi
						done
						bsfix_extra_args="${bsfix_extra_args} --javadoc --source-directory "
						# filter third/double spaces
						JAVA_ANT_JAVADOC_INPUT_DIRS=${JAVA_ANT_JAVADOC_INPUT_DIRS//   /}
						JAVA_ANT_JAVADOC_INPUT_DIRS=${JAVA_ANT_JAVADOC_INPUT_DIRS//  /}
						bsfix_extra_args="${bsfix_extra_args} ${JAVA_ANT_JAVADOC_INPUT_DIRS// / --source-directory }"
						bsfix_extra_args="${bsfix_extra_args} --output-directory ${JAVA_ANT_JAVADOC_OUTPUT_DIR}"
					fi
				else
					die "You need to have doc in IUSE when using JAVA_ANT_JAVADOC_INPUT_DIRS"
				fi
			fi

			[[ -n ${JAVA_ANT_BSFIX_EXTRA_ARGS} ]] \
				&& bsfix_extra_args="${bsfix_extra_args} ${JAVA_ANT_BSFIX_EXTRA_ARGS}"

			debug-print "bsfix_extra_args: ${bsfix_extra_args}"

			eval ${rewriter3}  ${files} \
				-c --source-element ${JAVA_PKG_BSFIX_SOURCE_TAGS// / --source-element } \
				--source-attribute source --source-value ${want_source} \
				--target-element   ${JAVA_PKG_BSFIX_TARGET_TAGS// / --target-element }  \
				--target-attribute target --target-value ${want_target} \
				--target-attribute nowarn --target-value yes \
				${bsfix_extra_args} \
				|| _bsfix_die "xml-rewrite2 failed: ${file}"
		fi

		if [[ -n "${JAVA_PKG_DEBUG}" ]]; then
			for file in "${@}"; do
				diff -NurbB "${file}.orig" "${file}"
			done
		fi
	fi
	return 0 # so that the 1 for diff doesn't get reported
}


# @FUNCTION: java-ant_bsfix_one
# @USAGE: <path/to/build.xml>
# @DESCRIPTION:
# Attempts to fix named build file.
#
# @CODE
# Affected by variables:
#	JAVA_PKG_BSFIX_SOURCE_TAGS
#	JAVA_PKG_BSFIX_TARGET_TAGS
# @CODE
java-ant_bsfix_one() {
	debug-print-function ${FUNCNAME} $*

	if [ -z "${1}" ]; then
		eerror "${FUNCNAME} needs one argument"
		die "${FUNCNAME} needs one argument"
	fi

	java-ant_bsfix_files "${1}"
}

# @FUNCTION: java-ant_rewrite-classpath
# @USAGE: [path/to/build.xml]
# @DESCRIPTION:
# Adds 'classpath="${gentoo.classpath}"' to specified build file.
#
# Affected by:
#	JAVA_ANT_CLASSPATH_TAGS
#
# Parameter defaults to build.xml when not specified
java-ant_rewrite-classpath() {
	debug-print-function ${FUNCNAME} $*

	local file="${1}"
	[[ -z "${1}" ]] && file=build.xml
	[[ ${#} -gt 1 ]] && die "${FUNCNAME} currently can only rewrite one file."

	echo "Adding gentoo.classpath to ${file}"
	debug-print "java-ant_rewrite-classpath: ${file}"

	cp "${file}" "${file}.orig" || die "failed to copy ${file}"

	chmod u+w "${file}"

	java-ant_xml-rewrite -f "${file}" --change \
		-e ${JAVA_ANT_CLASSPATH_TAGS// / -e } -a classpath -v '${gentoo.classpath}'

	if [[ -n "${JAVA_PKG_DEBUG}" ]]; then
		diff -NurbB "${file}.orig" "${file}"
	fi
}

# @FUNCTION: java-ant_remove-taskdefs
# @USAGE: [--name NAME] [path/to/build.xml]
# @DESCRIPTION:
# Removes (named) taskdef elements from the build.xml file.
# When --name NAME is specified, only remove taskdef with name NAME. Otherwise,
# all taskdefs are removed.
# The file to rewrite defaults to build.xml when not specified.
java-ant_remove-taskdefs() {
	debug-print-function ${FUNCNAME} $*

	die "${FUNCNAME} has been banned, see bug #479838."

	local task_name
	if [[ "${1}" == --name ]]; then
		task_name="${2}"
		shift 2
	fi
	local file="${1:-build.xml}"
	echo "Removing taskdefs from ${file}"
	python <<EOF
import sys
from xml.dom.minidom import parse
dom = parse("${file}")
for elem in dom.getElementsByTagName('taskdef'):
	if (len("${task_name}") == 0 or elem.getAttribute("name") == "${task_name}"):
		elem.parentNode.removeChild(elem)
		elem.unlink()
f = open("${file}", "w")
dom.writexml(f)
f.close()
EOF
	[[ $? != 0 ]] && die "Removing taskdefs failed"
}

# @FUNCTION: java-ant_ignore-system-classes
# @USAGE: [path/to/build.xml]
# @DESCRIPTION:
# Makes the available task ignore classes in the system classpath
# Parameter defaults to build.xml when not specified
java-ant_ignore-system-classes() {
	debug-print-function ${FUNCNAME} $*
	local file=${1:-build.xml}
	echo "Changing ignoresystemclasses to true for available tasks in ${file}"
	java-ant_xml-rewrite -f "${file}" --change \
		-e available -a ignoresystemclasses -v "true"
}

# @FUNCTION: java-ant_xml-rewrite
# @USAGE: <xml rewriter arguments>
# @DESCRIPTION:
# Run the right xml-rewrite binary with the given arguments
java-ant_xml-rewrite() {
	local gen2="/usr/bin/xml-rewrite-2.py"
	local gen2_1="/usr/$(get_libdir)/javatoolkit/bin/xml-rewrite-2.py"
	# gen1 is deprecated
	if [[ -x "${gen2}" ]]; then
		${gen2} "${@}" || die "${gen2} failed"
	elif [[ -x "${gen2_1}" ]]; then
		${gen2_1} "${@}" || die "${gen2_1} failed"
	else
		eerror "No binary for rewriting found."
		eerror "Do you have dev-java/javatoolkit installed?"
		die "xml-rewrite not found"
	fi
}

# @FUNCTION: java-ant_rewrite-bootclasspath
# @USAGE: <version> [path/to/build.xml] [prepend] [append]
# @DESCRIPTION:
# Adds bootclasspath to javac-like tasks in build.xml filled with jars of a
# bootclasspath package of given version.
#
# @CODE
# Affected by:
#	JAVA_PKG_BSFIX_TARGET_TAGS - the tags of javac tasks
#
# Parameters:
# $1 - the version of bootclasspath (e.g. 1.5), 'auto' for bootclasspath
#      of the current JDK
# $2 - path to desired build.xml file, defaults to 'build.xml'
# $3 - (optional) what to prepend the bootclasspath with (to override)
# $4 - (optional) what to append to the bootclasspath
# @CODE
java-ant_rewrite-bootclasspath() {
	local version="${1}"
	local file="${2-build.xml}"
	local extra_before="${3}"
	local extra_after="${4}"

	local bcp="$(java-pkg_get-bootclasspath "${version}")"

	if [[ -n "${extra_before}" ]]; then
		bcp="${extra_before}:${bcp}"
	fi
	if [[ -n "${extra_after}" ]]; then
		bcp="${bcp}:${extra_after}"
	fi

	java-ant_xml-rewrite -f "${file}" -c -e ${JAVA_PKG_BSFIX_TARGET_TAGS// / -e } \
		-a bootclasspath -v "${bcp}"
}
