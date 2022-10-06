# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for .NET SDK"

LICENSE=""
SLOT="5.0"
KEYWORDS="~amd64 ~arm ~arm64"

BDEPEND=""
RDEPEND="|| (
	dev-dotnet/dotnet-sdk-bin:${SLOT}[dotnet-symlink(+)]
	dev-dotnet/dotnet-sdk:${SLOT}[dotnet-symlink(+)]
)"
