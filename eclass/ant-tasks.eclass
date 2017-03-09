# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later

# @ECLASS: ant-tasks.eclass
# @MAINTAINER:
# java@gentoo.org
# @AUTHOR:
# Vlastimil Babka <caster@gentoo.org>
# @BLURB: Eclass for building dev-java/ant-* packages
# @DESCRIPTION:
# This eclass provides functionality and default ebuild variables for building
# dev-java/ant-* packages easily.


# we set ant-core dep ourselves, restricted
JAVA_ANT_DISABLE_ANT_CORE_DEP=true
# rewriting build.xml for are the testcases has no reason atm
JAVA_PKG_BSFIX_ALL=no
inherit versionator java-pkg-2 java-ant-2

EXPORT_FUNCTIONS src_unpack src_compile src_install

# @ECLASS-VARIABLE: ANT_TASK_JDKVER
# @DESCRIPTION:
# Affects the >=virtual/jdk version set in DEPEND string. Defaults to 1.5, can
# be overriden from ebuild BEFORE inheriting this eclass.
ANT_TASK_JDKVER=${ANT_TASK_JDKVER-1.5}

# @ECLASS-VARIABLE: ANT_TASK_JREVER
# @DESCRIPTION:
# Affects the >=virtual/jre version set in DEPEND string. Defaults to 1.5, can
# be overriden from ebuild BEFORE inheriting this eclass.
ANT_TASK_JREVER=${ANT_TASK_JREVER-1.5}

# @ECLASS-VARIABLE: ANT_TASK_NAME
# @DESCRIPTION:
# The name of this ant task as recognized by ant's build.xml, derived from $PN
# by removing the ant- prefix. Read-only.
ANT_TASK_NAME="${PN#ant-}"

# @ECLASS-VARIABLE: ANT_TASK_DEPNAME
# @DESCRIPTION:
# Specifies JAVA_PKG_NAME (PN{-SLOT} used with java-pkg_jar-from) of the package
# that this one depends on. Defaults to the name of ant task, ebuild can
# override it before inheriting this eclass.
ANT_TASK_DEPNAME=${ANT_TASK_DEPNAME-${ANT_TASK_NAME}}

# @ECLASS-VARIABLE: ANT_TASK_DISABLE_VM_DEPS
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set, no JDK/JRE deps are added.

# @VARIABLE: ANT_TASK_PV
# @INTERNAL
# Version of ant-core this task is intended to register and thus load with.
ANT_TASK_PV="${PV}"

# special care for beta/RC releases
if [[ ${PV} == *beta2* ]]; then
	MY_PV=${PV/_beta2/beta}
	UPSTREAM_PREFIX="http://people.apache.org/dist/ant/v1.7.1beta2/src"
	GENTOO_PREFIX="https://dev.gentoo.org/~caster/distfiles"
	ANT_TASK_PV=$(get_version_component_range 1-3)
elif [[ ${PV} == *_rc* ]]; then
	MY_PV=${PV/_rc/RC}
	UPSTREAM_PREFIX="https://dev.gentoo.org/~caster/distfiles"
	GENTOO_PREFIX="https://dev.gentoo.org/~caster/distfiles"
	ANT_TASK_PV=$(get_version_component_range 1-3)
else
	# default for final releases
	MY_PV=${PV}
	UPSTREAM_PREFIX="mirror://apache/ant/source"
	case ${PV} in
	1.9.*)
		GENTOO_PREFIX="https://dev.gentoo.org/~tomwij/files/dist"
		;;
	1.8.4)
		GENTOO_PREFIX="https://dev.gentoo.org/~sera/distfiles"
		;;
	*)
		GENTOO_PREFIX="https://dev.gentoo.org/~caster/distfiles"
		;;
	esac
fi

# source/workdir name
MY_P="apache-ant-${MY_PV}"

# Default values for standard ebuild variables, can be overriden from ebuild.
DESCRIPTION="Apache Ant's optional tasks depending on ${ANT_TASK_DEPNAME}"
HOMEPAGE="http://ant.apache.org/"
SRC_URI="${UPSTREAM_PREFIX}/${MY_P}-src.tar.bz2
	${GENTOO_PREFIX}/ant-${PV}-gentoo.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="~dev-java/ant-core-${PV}:0"
DEPEND="${RDEPEND}"

if [[ -z "${ANT_TASK_DISABLE_VM_DEPS}" ]]; then
	RDEPEND+=" >=virtual/jre-${ANT_TASK_JREVER}"
	DEPEND+=" >=virtual/jdk-${ANT_TASK_JDKVER}"
fi

# we need direct blockers with old ant-tasks for file collisions - bug #252324
if version_is_at_least 1.7.1 ; then
	DEPEND+=" !dev-java/ant-tasks"
fi

# Would run the full ant test suite for every ant task
RESTRICT="test"

S="${WORKDIR}/${MY_P}"

# @FUNCTION: ant-tasks_src_unpack
# @USAGE: [ base ] [ jar-dep ] [ all ]
# @DESCRIPTION:
# The function Is split into two parts, defaults to both of them ('all').
#
# base: performs the unpack, build.xml replacement and symlinks ant.jar from
#	ant-core
#
# jar-dep: symlinks the jar file(s) from dependency package
ant-tasks_src_unpack() {
	[[ -z "${1}" ]] && ant-tasks_src_unpack all

	while [[ -n "${1}" ]]; do
		case ${1} in
			base)
				unpack ${A}
				cd "${S}"

				# replace build.xml with our modified for split building
				mv -f "${WORKDIR}"/build.xml .

				cd lib
				# remove bundled xerces
				rm -f *.jar

				# ant.jar to build against
				java-pkg_jar-from --build-only ant-core ant.jar;;
			jar-dep)
				# get jar from the dependency package
				if [[ -n "${ANT_TASK_DEPNAME}" ]]; then
					java-pkg_jar-from ${ANT_TASK_DEPNAME}
				fi;;
			all)
				ant-tasks_src_unpack base jar-dep;;
		esac
		shift
	done

}

# @FUNCTION: ant-tasks_src_compile
# @DESCRIPTION:
# Compiles the jar with installed ant-core.
ant-tasks_src_compile() {
	ANT_TASKS="none" eant -Dbuild.dep=${ANT_TASK_NAME} jar-dep
}

# @FUNCTION: ant-tasks_src_install
# @DESCRIPTION:
# Installs the jar and registers its presence for the ant launcher script.
# Version param ensures it won't get loaded (thus break) when ant-core is
# updated to newer version.
ant-tasks_src_install() {
	java-pkg_dojar build/lib/${PN}.jar
	java-pkg_register-ant-task --version "${ANT_TASK_PV}"

	# create the compatibility symlink
	if version_is_at_least 1.7.1_beta2; then
		dodir /usr/share/ant/lib
		dosym /usr/share/${PN}/lib/${PN}.jar /usr/share/ant/lib/${PN}.jar
	fi
}
