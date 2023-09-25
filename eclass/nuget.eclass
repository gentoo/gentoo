# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nuget.eclass
# @MAINTAINER:
# Gentoo Dotnet project <dotnet@gentoo.org>
# @AUTHOR:
# Anna Figueiredo Gomes <navi@vlhl.dev>
# Maciej Barć <xgqt@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: common functions and variables for handling .NET NuGets
# @DESCRIPTION:
# This eclass is designed to provide support for .NET NuGet's ".nupkg" files.
# It is used to handle NuGets installation and usage.
# "dotnet-pkg" and "dotnet-pkg-utils" inherit this eclass.
#
# This eclass does not export any phase functions, for that see
# the "dotnet-pkg" eclass.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_NUGET_ECLASS} ]] ; then
_NUGET_ECLASS=1

# @ECLASS_VARIABLE: NUGET_SYSTEM_NUGETS
# @DESCRIPTION:
# Location of the system NuGet packages directory.
readonly NUGET_SYSTEM_NUGETS=/opt/dotnet-nugets

# @ECLASS_VARIABLE: NUGET_APIS
# @PRE_INHERIT
# @DESCRIPTION:
# NuGet API URLs to use for precompiled NuGet package ".nupkg" downloads.
# Set this variable pre-inherit.
#
# Defaults to an array of one item:
# "https://api.nuget.org/v3-flatcontainer"
#
# Example:
# @CODE
# NUGET_APIS+=( "https://api.nuget.org/v3-flatcontainer" )
# inherit nuget
# SRC_URI="https://example.com/example.tar.xz"
# SRC_URI+=" ${NUGET_URIS} "
# @CODE
if [[ -z "${NUGET_APIS}" ]] ; then
	NUGET_APIS=( "https://api.nuget.org/v3-flatcontainer" )
fi

# @ECLASS_VARIABLE: NUGET_PACKAGES
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Path from where NuGets will be restored from.
# This is a special variable that modifies the behavior of "dotnet".
#
# Defaults to ${T}/nugets for use with "NUGETS" but may be set to a custom
# location to, for example, restore NuGets extracted from a prepared archive.
# Do not set this variable in conjunction with non-empty "NUGETS".
if [[ -n "${NUGETS}" || -z "${NUGET_PACKAGES}" ]] ; then
	NUGET_PACKAGES="${T}"/nugets
fi
export NUGET_PACKAGES

# @ECLASS_VARIABLE: NUGETS
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# String containing all NuGet packages that need to be downloaded.
#
# Used by "_nuget_uris".
#
# Example:
# @CODE
# NUGETS="
#	ImGui.NET@1.87.2
#	Config.Net@4.19.0
# "
#
# inherit dotnet-pkg
#
# ...
#
# SRC_URI+=" ${NUGET_URIS} "
# @CODE

# @ECLASS_VARIABLE: NUGET_URIS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# List of URIs to put in SRC_URI created from NUGETS variable.

# @FUNCTION: _nuget_set_nuget_uris
# @USAGE: <nugets>
# @DESCRIPTION:
# Generates the URIs to put in SRC_URI to help fetch dependencies.
# Constructs a list of NuGets from its arguments.
# The value is set as "NUGET_URIS".
_nuget_set_nuget_uris() {
	local nugets="${1}"

	NUGET_URIS=""

	local nuget
	local name version
	local nuget_api url
	for nuget in ${nugets} ; do
		name="${nuget%@*}"
		version="${nuget##*@}"

		for nuget_api in "${NUGET_APIS[@]}" ; do
			case ${nuget_api%/} in
				*/v2 )
					url="${nuget_api}/package/${name}/${version}
							-> ${name}.${version}.nupkg"
					;;
				* )
					url="${nuget_api}/${name}/${version}/${name}.${version}.nupkg"
					;;
			esac

			NUGET_URIS+="${url} "
		done
	done
}

_nuget_set_nuget_uris "${NUGETS}"

# @FUNCTION: nuget_link
# @USAGE: <nuget-path>
# @DESCRIPTION:
# Link a specified NuGet package at "nuget-path" to the "NUGET_PACKAGES"
# directory.
#
# Example:
# @CODE
# nuget_link "${DISTDIR}"/pkg.0.nupkg
# @CODE
#
# This function is used inside "dotnet-pkg_src_unpack"
# from the "dotnet-pkg" eclass.
nuget_link() {
	[[ -z "${1}" ]] && die "${FUNCNAME[0]}: no nuget path given"

	mkdir -p "${NUGET_PACKAGES}" || die

	local nuget_name="${1##*/}"

	if [[ -f "${NUGET_PACKAGES}/${nuget_name}" ]] ; then
		eqawarn "QA Notice: \"${nuget_name}\" already exists, not linking it"
	else
		ln -s "${1}" "${NUGET_PACKAGES}/${nuget_name}" || die
	fi
}

# @FUNCTION: nuget_link-system-nugets
# @DESCRIPTION:
# Link all system NuGet packages to the "NUGET_PACKAGES" directory.
#
# Example:
# @CODE
# src_unpack() {
#     nuget_link-system-nugets
#     default
# }
# @CODE
#
# This function is used inside "dotnet-pkg_src_unpack"
# from the "dotnet-pkg" eclass.
nuget_link-system-nugets() {
	local runtime_nuget
	for runtime_nuget in "${EPREFIX}${NUGET_SYSTEM_NUGETS}"/*.nupkg ; do
		if [[ -f "${runtime_nuget}" ]] ; then
			nuget_link "${runtime_nuget}"
		fi
	done
}

# @FUNCTION: nuget_donuget
# @USAGE: <nuget-path> ...
# @DESCRIPTION:
# Install NuGet package(s) at "nuget-path" to the system nugets directory.
#
# Example:
# @CODE
# src_install() {
#     nuget_donuget my-pkg.nupkg
# }
# @CODE
nuget_donuget() {
	insinto "${NUGET_SYSTEM_NUGETS}"
	doins "${@}"
}

fi
