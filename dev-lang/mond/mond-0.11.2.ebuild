# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="9.0"
NUGETS="
fleck@1.2.0
microsoft.build.tasks.git@8.0.0
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.common@4.8.0
microsoft.codeanalysis.csharp@4.8.0
microsoft.codecoverage@17.8.0
microsoft.net.test.sdk@17.8.0
microsoft.netcore.platforms@1.1.0
microsoft.sourcelink.common@8.0.0
microsoft.sourcelink.github@8.0.0
microsoft.testplatform.objectmodel@17.8.0
microsoft.testplatform.testhost@17.8.0
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@13.0.1
nuget.frameworks@6.5.0
nunit3testadapter@4.5.0
nunit@3.14.0
system.buffers@4.5.1
system.collections.immutable@7.0.0
system.memory@4.5.5
system.numerics.vectors@4.4.0
system.reflection.metadata@1.6.0
system.reflection.metadata@7.0.0
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@6.0.0
system.text.encoding.codepages@7.0.0
system.threading.tasks.extensions@4.5.4
"

inherit dotnet-pkg

DESCRIPTION="Mond is a scripting language for .NET Core"
HOMEPAGE="https://mond.rohan.dev/
	https://github.com/Rohansi/Mond/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/Rohansi/${PN^}.git"
else
	SRC_URI="https://github.com/Rohansi/${PN^}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${P^}"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

DOTNET_PKG_BAD_PROJECTS=( TryMond/TryMond.csproj )
DOTNET_PKG_PROJECTS=( Mond.Repl/Mond.Repl.csproj )
PATCHES=( "${FILESDIR}/mond-0.11.2-net9.patch"  )

DOCS=( README.md Examples )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/Mond.Repl" "${PN}"

	docompress -x "/usr/share/doc/${PF}/Examples"
	einstalldocs
}
