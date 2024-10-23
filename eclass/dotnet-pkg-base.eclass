# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dotnet-pkg-base.eclass
# @MAINTAINER:
# Gentoo Dotnet project <dotnet@gentoo.org>
# @AUTHOR:
# Anna Figueiredo Gomes <navi@vlhl.dev>
# Maciej Barć <xgqt@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: nuget
# @BLURB: common functions and variables for builds using .NET SDK
# @DESCRIPTION:
# This eclass is designed to provide required ebuild definitions for .NET
# packages. Beware that in addition to Gentoo-specific concepts also terms that
# should be known to people familiar with the .NET ecosystem are used through
# this one and similar eclasses.
#
# In ebuilds for software that only utilizes the .NET SDK, without special
# cases, the "dotnet-pkg.eclass" is probably better suited.
#
# This eclass does not export any phase functions, for that see
# the "dotnet-pkg" eclass.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_DOTNET_PKG_BASE_ECLASS} ]] ; then
_DOTNET_PKG_BASE_ECLASS=1

inherit edo multiprocessing nuget

# @ECLASS_VARIABLE: DOTNET_PKG_COMPAT
# @REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# Allows to choose a slot for dotnet.
#
# Most .NET packages will lock onto one supported .NET major version.
# DOTNET_PKG_COMPAT should specify which version was chosen by package upstream.
# In case multiple .NET versions are specified in the project, then the highest
# should be picked by the maintainer.

# @ECLASS_VARIABLE: DOTNET_PKG_RDEPS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Populated with important dependencies on .NET ecosystem packages for running
# .NET packages.
#
# "DOTNET_PKG_RDEPS" should appear (or conditionally appear) in "RDEPEND".
DOTNET_PKG_RDEPS=""

# @ECLASS_VARIABLE: DOTNET_PKG_BDEPS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Populated with important dependencies on .NET ecosystem packages for building
# .NET packages.
#
# "DOTNET_PKG_BDEPS" should appear (or conditionally appear) in "BDEPEND".
DOTNET_PKG_BDEPS=""

# Have this guard to be sure that *DEPS are not added to
# the "dev-dotnet/dotnet-runtime-nugets" package dependencies.
if [[ ${CATEGORY}/${PN} != dev-dotnet/dotnet-runtime-nugets ]] ; then
	if [[ -z ${DOTNET_PKG_COMPAT} ]] ; then
		die "${ECLASS}: DOTNET_PKG_COMPAT not set"
	fi

	DOTNET_PKG_RDEPS+="
		virtual/dotnet-sdk:${DOTNET_PKG_COMPAT}
	"
	DOTNET_PKG_BDEPS+="
		${DOTNET_PKG_RDEPS}
	"

	# Special package "dev-dotnet/csharp-gentoodotnetinfo" used for information
	# gathering, example for usage see the "dotnet-pkg-base_info" function.
	if [[ ${CATEGORY}/${PN} != dev-dotnet/csharp-gentoodotnetinfo ]] ; then
		DOTNET_PKG_BDEPS+="
			dev-dotnet/csharp-gentoodotnetinfo
		"
	fi

	IUSE+=" debug "
fi

# Needed otherwise the binaries may break.
RESTRICT+=" strip "

# Everything is built by "dotnet".
QA_PREBUILT=".*"

# Special .NET SDK environment variables.
# Setting them either prevents annoying information from being generated
# or stops services that may interfere with a clean package build.
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
export MSBUILDDISABLENODEREUSE=1
export POWERSHELL_TELEMETRY_OPTOUT=1
export POWERSHELL_UPDATECHECK=0
# Speeds up restore. Having this turned on is redundant with Portage manifests.
# See also: https://github.com/NuGet/Home/issues/13062
export DOTNET_NUGET_SIGNATURE_VERIFICATION=false
# Overwrite selected MSBuild properties ("-p:XYZ").
export UseSharedCompilation=false

# @ECLASS_VARIABLE: DOTNET_PKG_RUNTIME
# @DEFAULT_UNSET
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Sets the runtime used to build a package.
#
# This variable is set automatically by the "dotnet-pkg-base_setup" function.

# @ECLASS_VARIABLE: DOTNET_PKG_EXECUTABLE
# @DEFAULT_UNSET
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Sets path of a "dotnet" executable.
#
# This variable is set automatically by the "dotnet-pkg-base_setup" function.

# @ECLASS_VARIABLE: DOTNET_PKG_CONFIGURATION
# @DEFAULT_UNSET
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Configuration value passed to "dotnet" in the compile phase.
# Is either Debug or Release, depending on the "debug" USE flag.
#
# This variable is set automatically by the "dotnet-pkg-base_setup" function.

# @ECLASS_VARIABLE: DOTNET_PKG_OUTPUT
# @DEFAULT_UNSET
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Path of the output directory, where the package artifacts are placed during
# the building of packages with "dotnet-pkg-base_build" function.
#
# This variable is set automatically by the "dotnet-pkg-base_setup" function.

# @VARIABLE: _DOTNET_PKG_LAUNCHERDEST
# @INTERNAL
# @DESCRIPTION:
# Sets the path that .NET launchers are installed into by
# the "dotnet-pkg-base_dolauncher" function.
#
# The function "dotnet-pkg-base_launcherinto" is able to manipulate this
# variable.
#
# Defaults to "/usr/bin".
_DOTNET_PKG_LAUNCHERDEST=/usr/bin

# @VARIABLE: _DOTNET_PKG_LAUNCHERVARS
# @INTERNAL
# @DESCRIPTION:
# Sets additional variables for .NET launchers created by
# the "dotnet-pkg-base_dolauncher" function.
#
# The function "dotnet-pkg-base_append_launchervar" is able to manipulate this
# variable.
#
# Defaults to a empty array.
_DOTNET_PKG_LAUNCHERVARS=()

# @FUNCTION: dotnet-pkg-base_get-configuration
# @DESCRIPTION:
# Return .NET configuration type of the current package.
#
# It is advised to refer to the "DOTNET_PKG_CONFIGURATION" variable instead of
# calling this function if necessary.
#
# Used by "dotnet-pkg-base_setup".
dotnet-pkg-base_get-configuration() {
	if in_iuse debug && use debug ; then
		echo Debug
	else
		echo Release
	fi
}

# @FUNCTION: dotnet-pkg-base_get-output
# @USAGE: <name>
# @DESCRIPTION:
# Return a specially constructed name of a directory for output of
# "dotnet build" artifacts ("--output" flag, see "dotnet-pkg-base_build").
#
# It is very rare that a maintainer would use this function in an ebuild.
#
# This function is used inside "dotnet-pkg-base_setup".
dotnet-pkg-base_get-output() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${DOTNET_PKG_CONFIGURATION} ]] &&
		die "${FUNCNAME[0]}: DOTNET_PKG_CONFIGURATION is not set."

	echo "${WORKDIR}/${1}_net${DOTNET_PKG_COMPAT}_${DOTNET_PKG_CONFIGURATION}"
}

# @FUNCTION: dotnet-pkg-base_get-runtime
# @DESCRIPTION:
# Return the .NET runtime used for the current package.
#
# Used by "dotnet-pkg-base_setup".
dotnet-pkg-base_get-runtime() {
	local libc
	libc="$(usex elibc_musl "-musl" "")"

	if use amd64 ; then
		echo "linux${libc}-x64"
	elif use x86 ; then
		echo "linux${libc}-x86"
	elif use arm ; then
		echo "linux${libc}-arm"
	elif use arm64 ; then
		echo "linux${libc}-arm64"
	else
		die "${FUNCNAME[0]}: Unsupported architecture: ${ARCH}"
	fi
}

# @FUNCTION: dotnet-pkg-base_setup
# @DESCRIPTION:
# Sets up "DOTNET_PKG_EXECUTABLE" variable for later use in "edotnet".
# Also sets up "DOTNET_PKG_CONFIGURATION" and "DOTNET_PKG_OUTPUT"
# for "dotnet-pkg_src_configure" and "dotnet-pkg_src_compile".
#
# This functions should be called by "pkg_setup".
#
# Used by "dotnet-pkg_pkg_setup" from the "dotnet-pkg" eclass.
dotnet-pkg-base_setup() {
	local -a impl_dirs=(
		"${EPREFIX}/usr/$(get_libdir)/dotnet-sdk-${DOTNET_PKG_COMPAT}"
		"${EPREFIX}/opt/dotnet-sdk-bin-${DOTNET_PKG_COMPAT}"
	)
	local impl_exe

	local impl_dir
	for impl_dir in "${impl_dirs[@]}" ; do
		impl_exe="${impl_dir}/dotnet"

		if [[ -d "${impl_dir}" ]] && [[ -x "${impl_exe}" ]] ; then
			DOTNET_PKG_EXECUTABLE="${impl_exe}"
			DOTNET_ROOT="${impl_dir}"

			break
		fi
	done

	einfo "Setting .NET SDK \"DOTNET_ROOT\" to \"${DOTNET_ROOT}\""
	export DOTNET_ROOT
	export PATH="${DOTNET_ROOT}:${PATH}"

	DOTNET_PKG_RUNTIME="$(dotnet-pkg-base_get-runtime)"
	DOTNET_PKG_CONFIGURATION="$(dotnet-pkg-base_get-configuration)"
	DOTNET_PKG_OUTPUT="$(dotnet-pkg-base_get-output "${P}")"
}

# @FUNCTION: dotnet-pkg-base_remove-global-json
# @USAGE: [directory]
# @DESCRIPTION:
# Remove the "global.json" if it exists.
# The file in question might lock target package to a specified .NET
# version, which might be unnecessary (as it is in most cases).
#
# Optional "directory" argument defaults to the current directory path.
#
# Used by "dotnet-pkg_src_prepare" from the "dotnet-pkg" eclass.
dotnet-pkg-base_remove-global-json() {
	debug-print-function ${FUNCNAME} "$@"

	local file="${1:-.}"/global.json

	if [[ -f "${file}" ]] ; then
		ebegin "Removing the global.json file"
		rm "${file}"
		eend ${?} || die "${FUNCNAME[0]}: failed to remove ${file}"
	fi
}

# @FUNCTION: edotnet
# @USAGE: <command> [args...]
# @DESCRIPTION:
# Call dotnet, passing the supplied arguments.
edotnet() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -z ${DOTNET_PKG_EXECUTABLE} ]] ; then
	   die "${FUNCNAME[0]}: DOTNET_PKG_EXECUTABLE not set. Was dotnet-pkg-base_setup called?"
	fi

	edo "${DOTNET_PKG_EXECUTABLE}" "${@}"
}

# @FUNCTION: efsi
# @USAGE: <command> [args...]
# @DESCRIPTION:
# Call dotnet fsi, passing the supplied arguments.
# FSI is the F# interpreter shipped with .NET SDK, it is useful for running F#
# maintenance scripts.
efsi() {
	debug-print-function ${FUNCNAME} "$@"

	edotnet fsi --nologo "${@}"
}

# @FUNCTION: dotnet-pkg-base_info
# @DESCRIPTION:
# Show information about current .NET SDK that is being used.
#
# Depends upon the "gentoo-dotnet-info" program installed by
# the "dev-dotnet/csharp-gentoodotnetinfo" package.
#
# Used by "dotnet-pkg_src_configure" from the "dotnet-pkg" eclass.
dotnet-pkg-base_info() {
	if [[ ${CATEGORY}/${PN} == dev-dotnet/csharp-gentoodotnetinfo ]] ; then
		debug-print-function ${FUNCNAME} "${P} is a special package, skipping dotnet-pkg-base_info"
	elif command -v gentoo-dotnet-info >/dev/null ; then
		gentoo-dotnet-info || die "${FUNCNAME[0]}: failed to execute gentoo-dotnet-info"
	else
		ewarn "${FUNCNAME[0]}: gentoo-dotnet-info not available"
	fi
}

# @FUNCTION: dotnet-pkg-base_sln-remove
# @USAGE: <solution> <project>
# @DESCRIPTION:
# Remove a project from a given solution file.
#
# Used by "dotnet-pkg_remove-bad" from the "dotnet-pkg" eclass.
dotnet-pkg-base_sln-remove() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${1} ]] && die "${FUNCNAME[0]}: no solution file specified"
	[[ -z ${2} ]] && die "${FUNCNAME[0]}: no project file specified"

	edotnet sln "${1}" remove "${2}"
}

# @FUNCTION: dotnet-pkg-base_foreach-solution
# @USAGE: <directory> <args> ...
# @DESCRIPTION:
# Execute a function for each solution file (.sln) in a specified directory.
# This function may yield no real results because solutions are discovered
# automatically.
#
# Used by "dotnet-pkg_src_configure" and "dotnet-pkg_src_test" from
# the "dotnet-pkg" eclass.
dotnet-pkg-base_foreach-solution() {
	debug-print-function ${FUNCNAME} "$@"

	local directory="${1}"
	shift

	local dotnet_solution
	local dotnet_solution_name
	while read -r dotnet_solution ; do
		dotnet_solution_name="$(basename "${dotnet_solution}")"

		ebegin "Running \"${@}\" for solution: \"${dotnet_solution_name}\""
		"${@}" "${dotnet_solution}"
		eend $? "${FUNCNAME[0]}: failed for solution: \"${dotnet_solution}\"" || die
	done < <(find "${directory}" -maxdepth 1 -type f -name "*.sln")
}

# @FUNCTION: dotnet-pkg-base_restore
# @USAGE: [args] ...
# @DESCRIPTION:
# Restore the package using "dotnet restore".
# Restore is performed in current directory unless a different directory is
# passed via "args".
#
# Additionally any number of "args" maybe be given, they are appended to
# the "dotnet" command invocation.
#
# Used by "dotnet-pkg_src_configure" from the "dotnet-pkg" eclass.
dotnet-pkg-base_restore() {
	debug-print-function ${FUNCNAME} "$@"

	local -a restore_args=(
		--runtime "${DOTNET_PKG_RUNTIME}"
		--source "${NUGET_PACKAGES}"
		-maxCpuCount:$(makeopts_jobs)
		"${@}"
	)

	edotnet restore "${restore_args[@]}"
}

# @FUNCTION: dotnet-pkg-base_restore-tools
# @USAGE: [config-file] [args] ...
# @DESCRIPTION:
# Restore dotnet tools for a project in the current directory.
#
# Optional "config-file" argument is used to specify a file for the
# "--configfile" option which records what tools should be restored.
#
# Additionally any number of "args" maybe be given, they are appended to
# the "dotnet" command invocation.
dotnet-pkg-base_restore-tools() {
	debug-print-function ${FUNCNAME} "$@"

	local -a tool_restore_args=(
		--add-source "${NUGET_PACKAGES}"
	)

	if [[ -n "${1}" ]] ; then
		tool_restore_args+=( --configfile "${1}" )
		shift
	fi

	tool_restore_args+=( "${@}" )

	edotnet tool restore "${tool_restore_args[@]}"
}

# @FUNCTION: dotnet-pkg-base_restore_tools
# @USAGE: [config-file] [args] ...
# @DESCRIPTION:
# DEPRECATED, use "dotnet-pkg-base_restore-tools" instead.
dotnet-pkg-base_restore_tools() {
	dotnet-pkg-base_restore-tools "${@}"
}

# @FUNCTION: dotnet-pkg-base_build
# @USAGE: [args] ...
# @DESCRIPTION:
# Build the package using "dotnet build" in a specified directory.
# Build is performed in current directory unless a different directory is
# passed via "args".
#
# Any number of "args" maybe be given, they are appended to the "dotnet"
# command invocation.
#
# Used by "dotnet-pkg_src_compile" from the "dotnet-pkg" eclass.
dotnet-pkg-base_build() {
	debug-print-function ${FUNCNAME} "$@"

	local -a build_args=(
		--configuration "${DOTNET_PKG_CONFIGURATION}"
		--no-restore
		--no-self-contained
		--output "${DOTNET_PKG_OUTPUT}"
		--runtime "${DOTNET_PKG_RUNTIME}"
		-maxCpuCount:$(makeopts_jobs)
	)

	if ! use debug ; then
		build_args+=(
			-p:StripSymbols=true
			-p:NativeDebugSymbols=false
		)
	fi

	# And append "args" at the end.
	build_args+=(
		"${@}"
	)

	edotnet build "${build_args[@]}"
}

# @FUNCTION: dotnet-pkg-base_test
# @USAGE: [args] ...
# @DESCRIPTION:
# Test the package using "dotnet test" in a specified directory.
# Test is performed in current directory unless a different directory is
# passed via "args".
#
# Any number of "args" maybe be given, they are appended to the "dotnet"
# command invocation.
#
# Used by "dotnet-pkg_src_test" from the "dotnet-pkg" eclass.
dotnet-pkg-base_test() {
	debug-print-function ${FUNCNAME} "$@"

	local -a test_args=(
		--configuration "${DOTNET_PKG_CONFIGURATION}"
		--no-restore
		-maxCpuCount:$(makeopts_jobs)
		"${@}"
	)

	edotnet test "${test_args[@]}"
}

# @FUNCTION: dotnet-pkg-base_install
# @USAGE: [directory]
# @DESCRIPTION:
# Install the contents of "DOTNET_PKG_OUTPUT" into a directory, defaults to
# "/usr/share/${P}".
#
# Installation directory is relative to "ED".
dotnet-pkg-base_install() {
	debug-print-function ${FUNCNAME} "$@"

	local installation_directory="${1:-/usr/share/${P}}"

	dodir "${installation_directory}"
	cp -r "${DOTNET_PKG_OUTPUT}"/* "${ED}/${installation_directory}/" || die
}

# @FUNCTION: dotnet-pkg-base_launcherinto
# @USAGE: <directory>
# @DESCRIPTION:
# Changes the path .NET launchers are installed into via subsequent
# "dotnet-pkg-base_dolauncher" calls.
#
# For more info see the "_DOTNET_PKG_LAUNCHERDEST" variable.
dotnet-pkg-base_launcherinto() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${1} ]] && die "${FUNCNAME[0]}: no directory specified"

	_DOTNET_PKG_LAUNCHERDEST="${1}"
}

# @FUNCTION: dotnet-pkg-base_append-launchervar
# @USAGE: <variable-setting>
# @DESCRIPTION:
# Appends a given variable setting to the "_DOTNET_PKG_LAUNCHERVARS".
#
# WARNING: This functions modifies a global variable permanently!
# This means that all launchers created in subsequent
# "dotnet-pkg-base_dolauncher" calls of a given package will have
# the given variable set.
#
# Example:
# @CODE
# dotnet-pkg-base_append_launchervar "DOTNET_EnableAlternateStackCheck=1"
# @CODE
#
# For more info see the "_DOTNET_PKG_LAUNCHERVARS" variable.
dotnet-pkg-base_append-launchervar() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${1} ]] && die "${FUNCNAME[0]}: no variable setting specified"

	_DOTNET_PKG_LAUNCHERVARS+=( "${1}" )
}

# @FUNCTION: dotnet-pkg-base_append_launchervar
# @USAGE: <variable-setting>
# @DESCRIPTION:
# DEPRECATED, use "dotnet-pkg-base_append-launchervar" instead.
dotnet-pkg-base_append_launchervar() {
	dotnet-pkg-base_append-launchervar "${@}"
}

# @FUNCTION: dotnet-pkg-base_dolauncher
# @USAGE: <executable-path> [filename]
# @DESCRIPTION:
# Make a wrapper script to launch an executable built from a .NET package.
#
# If no file name is given, the `basename` of the executable is used.
#
# Parameters:
# ${1} - path of the executable to launch,
# ${2} - filename of launcher to create (optional).
#
# Example:
# @CODE
# dotnet-pkg-base_install
# dotnet-pkg-base_dolauncher /usr/share/${P}/${PN^}
# @CODE
#
# The path is prepended by "EPREFIX".
dotnet-pkg-base_dolauncher() {
	debug-print-function ${FUNCNAME} "$@"

	local executable_path executable_name

	if [[ -n "${1}" ]] ; then
		local executable_path="${1}"
		shift
	else
		die "${FUNCNAME[0]}: No executable path given."
	fi

	if [[ ${#} -eq 0 ]] ; then
		executable_name="$(basename "${executable_path}")"
	else
		executable_name="${1}"
		shift
	fi

	local executable_target="${T}/${executable_name}"

	cat <<-EOF > "${executable_target}" || die
	#!/bin/sh

	# Launcher script for ${executable_path} (${executable_name}),
	# created from package "${CATEGORY}/${P}",
	# compatible with dotnet version ${DOTNET_PKG_COMPAT}.

	for __dotnet_root in \\
		"${EPREFIX}/usr/$(get_libdir)/dotnet-sdk-${DOTNET_PKG_COMPAT}" \\
		"${EPREFIX}/opt/dotnet-sdk-bin-${DOTNET_PKG_COMPAT}" ; do
		[ -d "\${__dotnet_root}" ] && break
	done

	DOTNET_ROOT="\${__dotnet_root}"
	export DOTNET_ROOT

	$(for var in "${_DOTNET_PKG_LAUNCHERVARS[@]}" ; do
		echo "${var}"
		echo "export ${var%%=*}"
	done)

	exec "${EPREFIX}${executable_path}" "\${@}"
	EOF

	exeinto "${_DOTNET_PKG_LAUNCHERDEST}"
	doexe "${executable_target}"
}

# @FUNCTION: dotnet-pkg-base_dolauncher-portable
# @USAGE: <dll-path> <filename>
# @DESCRIPTION:
# Make a wrapper script to launch a .NET DLL file built from a .NET package.
#
# Parameters:
# ${1} - path of the DLL to launch,
# ${2} - filename of launcher to create.
#
# Example:
# @CODE
# dotnet-pkg-base_dolauncher-portable \
#     /usr/share/${P}/GentooDotnetInfo.dll gentoo-dotnet-info
# @CODE
#
# The path is prepended by "EPREFIX".
dotnet-pkg-base_dolauncher-portable() {
	debug-print-function ${FUNCNAME} "$@"

	local dll_path="${1}"
	local executable_name="${2}"
	local executable_target="${T}/${executable_name}"

	cat <<-EOF > "${executable_target}" || die
	#!/bin/sh

	# Launcher script for ${dll_path} (${executable_name}),
	# created from package "${CATEGORY}/${P}",
	# compatible with any dotnet version, built on ${DOTNET_PKG_COMPAT}.

	$(for var in "${_DOTNET_PKG_LAUNCHERVARS[@]}" ; do
		echo "${var}"
		echo "export ${var%%=*}"
	done)

	exec dotnet exec "${EPREFIX}${dll_path}" "\${@}"
	EOF

	exeinto "${_DOTNET_PKG_LAUNCHERDEST}"
	doexe "${executable_target}"
}

# @FUNCTION: dotnet-pkg-base_dolauncher_portable
# @USAGE: <dll-path> <filename>
# @DESCRIPTION:
# DEPRECATED, use "dotnet-pkg-base_dolauncher-portable" instead.
dotnet-pkg-base_dolauncher_portable() {
	dotnet-pkg-base_dolauncher-portable "${@}"
}

fi
