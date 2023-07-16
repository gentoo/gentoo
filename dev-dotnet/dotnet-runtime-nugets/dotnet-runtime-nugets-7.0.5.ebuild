# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_COMPAT=$(ver_cut 1-2)
NUGETS="
microsoft.aspnetcore.app.ref-${PV}
microsoft.aspnetcore.app.runtime.linux-arm-${PV}
microsoft.aspnetcore.app.runtime.linux-arm64-${PV}
microsoft.aspnetcore.app.runtime.linux-musl-arm-${PV}
microsoft.aspnetcore.app.runtime.linux-musl-arm64-${PV}
microsoft.aspnetcore.app.runtime.linux-musl-x64-${PV}
microsoft.aspnetcore.app.runtime.linux-x64-${PV}
microsoft.netcore.app.host.linux-arm-${PV}
microsoft.netcore.app.host.linux-arm64-${PV}
microsoft.netcore.app.host.linux-musl-arm-${PV}
microsoft.netcore.app.host.linux-musl-arm64-${PV}
microsoft.netcore.app.host.linux-musl-x64-${PV}
microsoft.netcore.app.host.linux-x64-${PV}
microsoft.netcore.app.ref-${PV}
microsoft.netcore.app.runtime.linux-arm-${PV}
microsoft.netcore.app.runtime.linux-arm64-${PV}
microsoft.netcore.app.runtime.linux-musl-arm-${PV}
microsoft.netcore.app.runtime.linux-musl-arm64-${PV}
microsoft.netcore.app.runtime.linux-musl-x64-${PV}
microsoft.netcore.app.runtime.linux-x64-${PV}
"

inherit dotnet-pkg-utils

DESCRIPTION=".NET runtime nugets"
HOMEPAGE="https://dotnet.microsoft.com/"
SRC_URI="$(nuget_uris)"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="${PV}/${PV}"
KEYWORDS="~amd64 ~arm ~arm64"

src_unpack() {
	:
}

src_install() {
	nuget_donuget "${DISTDIR}"/microsoft.*.ref.${PV}.nupkg
	nuget_donuget "${DISTDIR}"/*$(dotnet-pkg-utils_get-runtime)*.nupkg
}
