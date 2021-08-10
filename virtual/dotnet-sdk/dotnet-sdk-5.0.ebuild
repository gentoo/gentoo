# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for .NET SDK"

LICENSE=""
SLOT="5.0"
KEYWORDS="~amd64 ~arm ~arm64"

BDEPEND=""
RDEPEND="|| ( dev-dotnet/dotnet-sdk-bin:${SLOT} dev-dotnet/dotnet-sdk:${SLOT} )"
