# Eclass for simple bare-source Java packages
#
# Copyright (c) 2004-2015, Gentoo Foundation
#
# Licensed under the GNU General Public License, v2
#
# $Id$

inherit java-utils-2

if ! has java-pkg-2 ${INHERITED}; then
	eerror "java-pkg-simple eclass can only be inherited AFTER java-pkg-2"
fi

# -----------------------------------------------------------------------------
# @eclass-begin
# @eclass-summary Eclass for Java sources without build instructions
#
# This class is intended to build pure Java packages from Java sources
# without the use of any build instructions shipped with the sources.
# There is no support for resources besides the generated class files,
# or for generating source files, or for controlling the META-INF of
# the resulting jar, although these issues may be addressed by an
# ebuild by putting corresponding files into the target directory
# before calling the src_compile function of this eclass.
# -----------------------------------------------------------------------------

EXPORT_FUNCTIONS src_compile src_install

# We are only interested in finding all java source files, wherever they may be.
S="${WORKDIR}"

# -----------------------------------------------------------------------------
# @variable-external JAVA_GENTOO_CLASSPATH
# @variable-default ""
#
# Comma or space separated list of java packages to include in the
# class path. The packages will also be registered as runtime
# dependencies of this new package. Dependencies will be calculated
# transitively. See "java-config -l" for appropriate package names.
# -----------------------------------------------------------------------------
# JAVA_GENTOO_CLASSPATH

# -----------------------------------------------------------------------------
# @variable-external JAVA_CLASSPATH_EXTRA
# @variable-default ""
#
# Extra list of colon separated path elements to be put on the
# classpath when compiling sources.
# -----------------------------------------------------------------------------
# JAVA_CLASSPATH_EXTRA

# -----------------------------------------------------------------------------
# @variable-external JAVA_SRC_DIR
# @variable-default ""
#
# Directories relative to ${S} which contain the sources of the
# application. The default of "" will be treated mostly as ${S}
# itself. For the generated source package (if source is listed in
# ${JAVA_PKG_IUSE}), it is important that these directories are
# actually the roots of the corresponding source trees.
# -----------------------------------------------------------------------------
# JAVA_SRC_DIR

# -----------------------------------------------------------------------------
# @variable-external JAVA_ENCODING
# @variable-default UTF-8
#
# The character encoding used in the source files
# -----------------------------------------------------------------------------
: ${JAVA_ENCODING:=UTF-8}

# -----------------------------------------------------------------------------
# @variable-external JAVAC_ARGS
# @variable-default ""
#
# Additional arguments to be passed to javac
# -----------------------------------------------------------------------------
# JAVAC_ARGS

# -----------------------------------------------------------------------------
# @variable-external JAVADOC_ARGS
# @variable-default ""
#
# Additional arguments to be passed to javadoc
# -----------------------------------------------------------------------------
# JAVADOC_ARGS

# -----------------------------------------------------------------------------
# @variable-external JAVA_JAR_FILENAME
# @variable-default ${PN}.jar
#
# The name of the jar file to create and install
# -----------------------------------------------------------------------------
: ${JAVA_JAR_FILENAME:=${PN}.jar}

# ------------------------------------------------------------------------------
# @eclass-src_compile
#
# src_compile for simple bare source java packages. Finds all *.java
# sources in ${JAVA_SRC_DIR}, compiles them with the classpath
# calculated from ${JAVA_GENTOO_CLASSPATH}, and packages the resulting
# classes to ${JAVA_JAR_FILENAME}.
#
# variables:
# JAVA_GENTOO_CLASSPATH - list java packages to put on the classpath.
# JAVA_ENCODING - encoding of source files, used by javac and javadoc
# JAVA_SRC_DIR - directories containing source files, relative to ${S}
# JAVAC_ARGS - additional arguments to be passed to javac
# JAVADOC_ARGS - additional arguments to be passed to javadoc
# ------------------------------------------------------------------------------
java-pkg-simple_src_compile() {
	local sources=sources.lst classes=target/classes apidoc=target/api

	# gather sources
	find ${JAVA_SRC_DIR:-*} -name \*.java > ${sources}
	mkdir -p ${classes} || die "Could not create target directory"

	# compile
	local classpath="${JAVA_CLASSPATH_EXTRA}" dependency
	for dependency in ${JAVA_GENTOO_CLASSPATH}; do
		classpath="${classpath}:$(java-pkg_getjars ${dependency})" \
			|| die "getjars failed for ${dependency}"
	done
	while [[ $classpath = *::* ]]; do classpath="${classpath//::/:}"; done
	classpath=${classpath%:}
	classpath=${classpath#:}
	debug-print "CLASSPATH=${classpath}"
	java-pkg-simple_verbose-cmd \
		ejavac -d ${classes} -encoding ${JAVA_ENCODING} \
		${classpath:+-classpath ${classpath}} ${JAVAC_ARGS} \
		@${sources}

	# javadoc
	if has doc ${JAVA_PKG_IUSE} && use doc; then
		mkdir -p ${apidoc}
		java-pkg-simple_verbose-cmd \
			ejavadoc -d ${apidoc} \
			-encoding ${JAVA_ENCODING} -docencoding UTF-8 -charset UTF-8 \
			${classpath:+-classpath ${classpath}} ${JAVADOC_ARGS:- -quiet} \
			@${sources} || die "javadoc failed"
	fi

	# package
	local jar_args="cf ${JAVA_JAR_FILENAME}"
	if [[ -e ${classes}/META-INF/MANIFEST.MF ]]; then
		jar_args="cfm ${JAVA_JAR_FILENAME} ${classes}/META-INF/MANIFEST.MF"
	fi
	java-pkg-simple_verbose-cmd \
		jar ${jar_args} -C ${classes} . || die "jar failed"
}

# ------------------------------------------------------------------------------
# @eclass-src_install
#
# src_install for simple single jar java packages. Simply packages the
# contents from the target directory and installs it as
# ${JAVA_JAR_FILENAME}. If the file target/META-INF/MANIFEST.MF exists,
# it is used as the manifest of the created jar.
# ------------------------------------------------------------------------------
java-pkg-simple_src_install() {
	local sources=sources.lst classes=target/classes apidoc=target/api

	# main jar
	java-pkg-simple_verbose-cmd \
		java-pkg_dojar ${JAVA_JAR_FILENAME}

	# javadoc
	if has doc ${JAVA_PKG_IUSE} && use doc; then
		java-pkg-simple_verbose-cmd \
			java-pkg_dojavadoc ${apidoc}
	fi

	# dosrc
	if has source ${JAVA_PKG_IUSE} && use source; then
		local srcdirs=""
		if [[ ${JAVA_SRC_DIR} ]]; then
			local parent child
			for parent in ${JAVA_SRC_DIR}; do
				for child in ${parent}/*; do
					srcdirs="${srcdirs} ${child}"
				done
			done
		else
			# take all directories actually containing any sources
			srcdirs="$(cut -d/ -f1 ${sources} | sort -u)"
		fi
		java-pkg-simple_verbose-cmd \
			java-pkg_dosrc ${srcdirs}
	fi
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg-simple_verbose-cmd
#
# Print a command before executing it. To give user some feedback
# about what is going on, where the time is being spent, and also to
# help debugging ebuilds.
#
# @param $@ - command to be called and its arguments
# ------------------------------------------------------------------------------
java-pkg-simple_verbose-cmd() {
	echo "$*"
	"$@"
}

# ------------------------------------------------------------------------------
# @eclass-end
# ------------------------------------------------------------------------------
