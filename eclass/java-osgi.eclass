# Copyright 2007-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: java-osgi.eclass
# @MAINTAINER:
# java@gentoo.org
# @AUTHOR:
# Java maintainers <java@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7 8
# @PROVIDES: java-utils-2
# @BLURB: Java OSGi eclass
# @DESCRIPTION:
# This eclass provides functionality which is used by packages that need to be
# OSGi compliant. This means that the generated jars will have special headers
# in their manifests. Currently this is used only by Eclipse-3.3 - later we
# could extend this so that Gentoo Java system would be fully OSGi compliant.

case ${EAPI:-0} in
	[5678]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_JAVA_OSGI_ECLASS} ]] ; then
_JAVA_OSGI_ECLASS=1

inherit java-utils-2

# @ECLASS_VARIABLE: _OSGI_T
# @INTERNAL
# @DESCRIPTION:
# We define _OSGI_T so that it does not contain a slash at the end.
# According to Paludis guys, there is currently a proposal for EAPIs that
# would require all variables to end with a slash.
_OSGI_T="${T/%\//}"

# must get Diego to commit something like this to portability.eclass
_canonicalise() {
	if type -p realpath > /dev/null; then
		realpath "${@}"
	elif type -p readlink > /dev/null; then
		readlink -f "${@}"
	else
		# can't die, subshell
		eerror "No readlink nor realpath found, cannot canonicalise"
	fi
}

# @FUNCTION: _java-osgi_plugin
# @USAGE: <plugin name>
# @INTERNAL
# @DESCRIPTION:
# This is an internal function, not to be called directly.
#
# @CODE
#	_java-osgi_plugin "JSch"
# @CODE
#
# @param $1 - bundle name
_java-osgi_plugin() {
	# We hardcode Gentoo as the vendor name

	cat > "${_OSGI_T}/tmp_jar/plugin.properties" <<-EOF
	bundleName="${1}"
	vendorName="Gentoo"
	EOF
}

# @FUNCTION: _java-osgi_makejar
# @USAGE: <jar name> <symbolic name> <bundle name> <header name>
# @INTERNAL
# @DESCRIPTION:
# This is an internal function, not to be called directly.
#
# @CODE
#	_java-osgi_makejar "dist/${PN}.jar" "com.jcraft.jsch" "JSch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true"
# @CODE
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - bundle symbolic name
# @param $3 - bundle name
# @param $4 - export-package header
_java-osgi_makejar() {
	debug-print-function ${FUNCNAME} "$@"

	(( ${#} < 4 )) && die "Four arguments are needed for _java-osgi_makejar()"

	local absoluteJarPath="$(_canonicalise ${1})"
	local jarName="$(basename ${1})"

	mkdir "${_OSGI_T}/tmp_jar" || die "Unable to create directory ${_OSGI_T}/tmp_jar"
	[[ -d "${_OSGI_T}/osgi" ]] || mkdir "${_OSGI_T}/osgi" || die "Unable to create directory ${_OSGI_T}/osgi"

	cd "${_OSGI_T}/tmp_jar" && jar xf "${absoluteJarPath}" && cd - > /dev/null \
		 || die "Unable to uncompress correctly the original jar"

	cat > "${_OSGI_T}/tmp_jar/META-INF/MANIFEST.MF" <<-EOF
	Manifest-Version: 1.0
	Bundle-ManifestVersion: 2
	Bundle-Name: %bundleName
	Bundle-Vendor: %vendorName
	Bundle-Localization: plugin
	Bundle-SymbolicName: ${2}
	Bundle-Version: ${PV}
	Export-Package: ${4}
	EOF

	_java-osgi_plugin "${3}"

	jar cfm "${_OSGI_T}/osgi/${jarName}" "${_OSGI_T}/tmp_jar/META-INF/MANIFEST.MF" \
		-C "${_OSGI_T}/tmp_jar/" . > /dev/null || die "Unable to recreate the OSGi compliant jar"
	rm -rf "${_OSGI_T}/tmp_jar"
}

# @FUNCTION: @java-osgi_dojar
# @USAGE: <jar name> <symbolic name> <bundle name> <header name>
# @DESCRIPTION:
# Rewrites a jar, and produce an OSGi compliant jar from arguments given on the command line.
# The arguments given correspond to the minimal set of headers
# that must be present on a Manifest file of an OSGi package.
# If you need more headers, you should use the *-fromfile functions below,
# that create the Manifest from a file.
# It will call java-pkg_dojar at the end.
#
# @CODE
#	java-osgi_dojar "dist/${PN}.jar" "com.jcraft.jsch" "JSch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true"
# @CODE
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - bundle symbolic name
# @param $3 - bundle name
# @param $4 - export-package-header
java-osgi_dojar() {
	debug-print-function ${FUNCNAME} "$@"
	local jarName="$(basename ${1})"
	_java-osgi_makejar "$@"
	java-pkg_dojar "${_OSGI_T}/osgi/${jarName}"
}

# @FUNCTION: java-osgi_newjar
# @USAGE: <jar name> <symbolic name> <bundle name> <header name>
# @DESCRIPTION:
# Rewrites a jar, and produce an OSGi compliant jar.
# The arguments given correspond to the minimal set of headers
# that must be present on a Manifest file of an OSGi package.
# If you need more headers, you should use the *-fromfile functions below,
# that create the Manifest from a file.
# It will call java-pkg_newjar at the end.
#
# @CODE
#	java-osgi_newjar "dist/${PN}.jar" "com.jcraft.jsch" "JSch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true"
# @CODE
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 (optional) - name of the target jar. It will default to package name if not specified.
# @param $3 - bundle symbolic name
# @param $4 - bundle name
# @param $5 - export-package header
java-osgi_newjar() {
	debug-print-function ${FUNCNAME} "$@"
	local jarName="$(basename $1)"

	if (( ${#} > 4 )); then
		_java-osgi_makejar "${1}" "${3}" "${4}" "${5}"
		java-pkg_newjar "${_OSGI_T}/osgi/${jarName}" "${2}"
	else
		_java-osgi_makejar "$@"
		java-pkg_newjar "${_OSGI_T}/osgi/${jarName}"
	fi
}

# @FUNCTION:_java-osgi_makejar-fromfile
# @USAGE: <jar to repackage with OSGi> <Manifest file> <bundle name> <version rewriting>
# @INTERNAL
# @DESCRIPTION:
# This is an internal function, not to be called directly.
#
# @CODE
#	_java-osgi_makejar-fromfile "dist/${PN}.jar" "${FILESDIR}/MANIFEST.MF" "JSch" 1
# @CODE
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - path to the Manifest file
# @param $3 - bundle name
# @param $4 - automatic version rewriting (0 or 1)
_java-osgi_makejar-fromfile() {
	debug-print-function ${FUNCNAME} "$@"

	((${#} < 4)) && die "Four arguments are needed for _java-osgi_makejar-fromfile()"

	local absoluteJarPath="$(_canonicalise ${1})"
	local jarName="$(basename ${1})"

	mkdir "${_OSGI_T}/tmp_jar" || die "Unable to create directory ${_OSGI_T}/tmp_jar"
	[[ -d "${_OSGI_T}/osgi" ]] || mkdir "${_OSGI_T}/osgi" || die "Unable to create directory ${_OSGI_T}/osgi"

	cd "${_OSGI_T}/tmp_jar" && jar xf "${absoluteJarPath}" && cd - > /dev/null \
		|| die "Unable to uncompress correctly the original jar"

	[[ -e "${2}" ]] || die "Manifest file ${2} not found"

	# We automatically change the version if automatic version rewriting is on

	if (( ${4} )); then
		cat "${2}" | sed "s/Bundle-Version:.*/Bundle-Version: ${PV}/" > \
			"${_OSGI_T}/tmp_jar/META-INF/MANIFEST.MF"
	else
		cat "${2}" > "${_OSGI_T}/tmp_jar/META-INF/MANIFEST.MF"
	fi

	_java-osgi_plugin "${3}"

	jar cfm "${_OSGI_T}/osgi/${jarName}" "${_OSGI_T}/tmp_jar/META-INF/MANIFEST.MF" \
		-C "${_OSGI_T}/tmp_jar/" . > /dev/null || die "Unable to recreate the OSGi compliant jar"
	rm -rf "${_OSGI_T}/tmp_jar"
}

# @FUNCTION: java-osgi_newjar-fromfile
# @USAGE: <jar to repackage with OSGi> <Manifest file> <bundle name> <version rewriting>
# @DESCRIPTION:
# This function produces an OSGi compliant jar from a given manifest file.
# The Manifest Bundle-Version header will be replaced by the current version
# of the package, unless the --no-auto-version option is given.
# It will call java-pkg_newjar at the end.
#
# @CODE
#	java-osgi_newjar-fromfile "dist/${PN}.jar" "${FILESDIR}/MANIFEST.MF" "Standard Widget Toolkit for GTK 2.0"
# @CODE
#
# @param $opt
#	--no-auto-version - This option disables automatic rewriting of the
#		version in the Manifest file
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 (optional) - name of the target jar. It will default to package name if not specified.
# @param $3 - path to the Manifest file
# @param $4 - bundle name
java-osgi_newjar-fromfile() {
	debug-print-function ${FUNCNAME} "$@"
	local versionRewriting=1

	if [[ "${1}" == "--no-auto-version" ]]; then
		versionRewriting=0
		shift
	fi
	local jarName="$(basename ${1})"

	if (( ${#} > 3 )); then
		_java-osgi_makejar-fromfile "${1}" "${3}" "${4}" "${versionRewriting}"
		java-pkg_newjar "${_OSGI_T}/osgi/${jarName}" "${2}"
	else
		_java-osgi_makejar-fromfile "$@" "${versionRewriting}"
		java-pkg_newjar "${_OSGI_T}/osgi/${jarName}"
	fi
}

# @FUNCTION: java-osgi_dojar-fromfile
# @USAGE: <jar to repackage with OSGi> <Manifest file> <bundle name>
# @DESCRIPTION:
# This function produces an OSGi compliant jar from a given manifestfile.
# The Manifest Bundle-Version header will be replaced by the current version
# of the package, unless the --no-auto-version option is given.
# It will call java-pkg_dojar at the end.
#
# @CODE
#	java-osgi_dojar-fromfile "dist/${PN}.jar" "${FILESDIR}/MANIFEST.MF" "Standard Widget Toolkit for GTK 2.0"
# @CODE
#
# @param $opt
#	--no-auto-version - This option disables automatic rewriting of the
#		version in the Manifest file
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - path to the Manifest file
# @param $3 - bundle name
java-osgi_dojar-fromfile() {
	debug-print-function ${FUNCNAME} "$@"
	local versionRewriting=1

	if [[ "${1}" == "--no-auto-version" ]]; then
		versionRewriting=0
		shift
	fi
	local jarName="$(basename ${1})"

	_java-osgi_makejar-fromfile "$@" "${versionRewriting}"
	java-pkg_dojar "${_OSGI_T}/osgi/${jarName}"
}

fi
