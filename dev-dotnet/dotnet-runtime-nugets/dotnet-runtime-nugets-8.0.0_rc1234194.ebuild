# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Yes, this is very weird, because this is a "RC" version.
# See also the "dev-dotnet/dotnet-sdk-8.0.0_rc1234194" ebuild.

EAPI=8

DOTNET_PKG_COMPAT=$(ver_cut 1-2)
NUGETS="
microsoft.aspnetcore.app.runtime.linux-arm@8.0.0-rc.1.23421.29
microsoft.aspnetcore.app.runtime.linux-arm64@8.0.0-rc.1.23421.29
microsoft.aspnetcore.app.runtime.linux-musl-arm@8.0.0-rc.1.23421.29
microsoft.aspnetcore.app.runtime.linux-musl-arm64@8.0.0-rc.1.23421.29
microsoft.aspnetcore.app.runtime.linux-musl-x64@8.0.0-rc.1.23421.29
microsoft.aspnetcore.app.runtime.linux-x64@8.0.0-rc.1.23421.29
microsoft.netcore.app.host.linux-arm@8.0.0-rc.1.23419.4
microsoft.netcore.app.host.linux-arm64@8.0.0-rc.1.23419.4
microsoft.netcore.app.host.linux-musl-arm@8.0.0-rc.1.23419.4
microsoft.netcore.app.host.linux-musl-arm64@8.0.0-rc.1.23419.4
microsoft.netcore.app.host.linux-musl-x64@8.0.0-rc.1.23419.4
microsoft.netcore.app.host.linux-x64@8.0.0-rc.1.23419.4
microsoft.netcore.app.runtime.linux-arm@8.0.0-rc.1.23419.4
microsoft.netcore.app.runtime.linux-arm64@8.0.0-rc.1.23419.4
microsoft.netcore.app.runtime.linux-musl-arm@8.0.0-rc.1.23419.4
microsoft.netcore.app.runtime.linux-musl-arm64@8.0.0-rc.1.23419.4
microsoft.netcore.app.runtime.linux-musl-x64@8.0.0-rc.1.23419.4
microsoft.netcore.app.runtime.linux-x64@8.0.0-rc.1.23419.4
"

inherit dotnet-pkg-base

DESCRIPTION=".NET runtime nugets"
HOMEPAGE="https://dotnet.microsoft.com/"
SRC_URI="${NUGET_URIS}"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="${DOTNET_PKG_COMPAT}/${PV}"      # WARNING: Mixed NUGETS versions.
KEYWORDS="~amd64 ~arm ~arm64"

src_unpack() {
	:
}

src_install() {
	# WARNING: The "gentoo-dotnet-maintainer-tools" script did not find
	# any "app.ref" pkgs! Possibly a bug!
	# nuget_donuget "${DISTDIR}/microsoft.aspnetcore.app.ref.${PV}.nupkg"
	# nuget_donuget "${DISTDIR}/microsoft.netcore.app.ref.${PV}.nupkg"

	local runtime=$(dotnet-pkg-base_get-runtime)
	local -a nuget_namespaces=(
		microsoft.aspnetcore.app.runtime
		microsoft.netcore.app.host
		microsoft.netcore.app.runtime
	)
	local nuget_namespace
	local v19_nuget
	local v21_nuget
	for nuget_namespace in "${nuget_namespaces[@]}" ; do
		v19_nuget="${DISTDIR}/${nuget_namespace}.${runtime}.8.0.0-rc.1.23419.4.nupkg"
		v21_nuget="${DISTDIR}/${nuget_namespace}.${runtime}.8.0.0-rc.1.23421.29.nupkg"

		if [[ -f "${v19_nuget}" ]] ; then
			nuget_donuget "${v19_nuget}"
		elif [[ -f "${v21_nuget}" ]] ; then
			nuget_donuget "${v21_nuget}"
		else
			die "No compatible NuGet packages found for ${nuget_namespace}!"
		fi
	done
}
