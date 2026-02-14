# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAJOR="$(ver_cut 1)"

DOTNET_PKG_COMPAT="10.0"
NUGETS="
coverlet.collector@6.0.2
microsoft.codecoverage@17.12.0
microsoft.dotnet.platformabstractions@3.1.6
microsoft.net.test.sdk@17.12.0
microsoft.testplatform.objectmodel@17.12.0
microsoft.testplatform.testhost@17.12.0
newtonsoft.json@13.0.1
nunit.analyzers@4.4.0
nunit3testadapter@4.6.0
nunit@4.2.2
system.commandline@2.0.0-beta4.22272.1
system.reflection.metadata@1.6.0
"

inherit dotnet-pkg

DESCRIPTION=".NET information tool for Gentoo"
HOMEPAGE="https://gitlab.gentoo.org/dotnet/csharp-gentoodotnetinfo/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/dotnet/${PN}.git"
else
	SRC_URI="https://gitlab.gentoo.org/dotnet/${PN}/-/archive/${PV}/${P}.tar.bz2"

	KEYWORDS="amd64 arm arm64"
fi

SRC_URI+=" ${NUGET_URIS} "
S="${WORKDIR}/${P}/Source/v${MAJOR}"

LICENSE="GPL-2+"
SLOT="0/${MAJOR}"

DOTNET_PKG_PROJECTS=( gentoo-dotnet-info-app/src/main/csharp/GentooDotnetInfo )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_test() {
	dotnet-pkg_src_test

	# Test-run.
	edotnet exec "${DOTNET_PKG_OUTPUT}/GentooDotnetInfo.dll"
}

src_install() {
	local launcher_dll="/usr/share/${P}/GentooDotnetInfo.dll"

	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher_portable "${launcher_dll}" gentoo-dotnet-info

	cd ../.. || die  # Project root.
	einstalldocs
}
