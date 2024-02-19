# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=$(ver_cut 1-2)
NUGETS="
microsoft.aspnetcore.app.ref@${PV}
microsoft.aspnetcore.app.runtime.linux-arm@${PV}
microsoft.aspnetcore.app.runtime.linux-arm64@${PV}
microsoft.aspnetcore.app.runtime.linux-musl-arm@${PV}
microsoft.aspnetcore.app.runtime.linux-musl-arm64@${PV}
microsoft.aspnetcore.app.runtime.linux-musl-x64@${PV}
microsoft.aspnetcore.app.runtime.linux-x64@${PV}
microsoft.netcore.app.host.linux-arm@${PV}
microsoft.netcore.app.host.linux-arm64@${PV}
microsoft.netcore.app.host.linux-musl-arm@${PV}
microsoft.netcore.app.host.linux-musl-arm64@${PV}
microsoft.netcore.app.host.linux-musl-x64@${PV}
microsoft.netcore.app.host.linux-x64@${PV}
microsoft.netcore.app.ref@${PV}
microsoft.netcore.app.runtime.linux-arm@${PV}
microsoft.netcore.app.runtime.linux-arm64@${PV}
microsoft.netcore.app.runtime.linux-musl-arm@${PV}
microsoft.netcore.app.runtime.linux-musl-arm64@${PV}
microsoft.netcore.app.runtime.linux-musl-x64@${PV}
microsoft.netcore.app.runtime.linux-x64@${PV}
"

inherit dotnet-pkg-base

DESCRIPTION=".NET runtime nugets"
HOMEPAGE="https://dotnet.microsoft.com/"
SRC_URI="${NUGET_URIS}"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="${PV}/${PV}"
KEYWORDS="amd64 arm arm64"

src_unpack() {
	:
}

src_install() {
	nuget_donuget "${DISTDIR}/microsoft.aspnetcore.app.ref.${PV}.nupkg"
	nuget_donuget "${DISTDIR}/microsoft.netcore.app.ref.${PV}.nupkg"

	local runtime=$(dotnet-pkg-base_get-runtime)
	local -a nuget_namespaces=(
		microsoft.aspnetcore.app.runtime
		microsoft.netcore.app.host
		microsoft.netcore.app.runtime
	)
	local nuget_namespace
	for nuget_namespace in "${nuget_namespaces[@]}" ; do
		nuget_donuget "${DISTDIR}/${nuget_namespace}.${runtime}.${PV}.nupkg"
	done
}
