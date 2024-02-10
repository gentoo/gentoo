# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGETS="
fleck@1.2.0
microsoft.build.tasks.git@1.1.1
microsoft.codecoverage@17.0.0
microsoft.csharp@4.0.1
microsoft.net.test.sdk@17.0.0
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.targets@1.0.1
microsoft.sourcelink.common@1.1.1
microsoft.sourcelink.github@1.1.1
microsoft.testplatform.objectmodel@17.0.0
microsoft.testplatform.testhost@17.0.0
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@9.0.1
nuget.frameworks@5.0.0
nunit@3.13.2
nunit3testadapter@4.2.0
runtime.any.system.collections@4.0.11
runtime.any.system.diagnostics.tools@4.0.1
runtime.any.system.globalization@4.0.11
runtime.any.system.io@4.1.0
runtime.any.system.reflection.extensions@4.0.1
runtime.any.system.reflection.primitives@4.0.1
runtime.any.system.reflection@4.1.0
runtime.any.system.resources.resourcemanager@4.0.1
runtime.any.system.runtime.handles@4.0.1
runtime.any.system.runtime.interopservices@4.1.0
runtime.any.system.runtime@4.1.0
runtime.any.system.text.encoding.extensions@4.0.11
runtime.any.system.text.encoding@4.0.11
runtime.any.system.threading.tasks@4.0.11
runtime.native.system.security.cryptography@4.0.0
runtime.native.system@4.0.0
runtime.unix.system.diagnostics.debug@4.0.11
runtime.unix.system.io.filesystem@4.0.1
runtime.unix.system.private.uri@4.0.1
runtime.unix.system.runtime.extensions@4.1.0
system.collections@4.0.11
system.diagnostics.debug@4.0.11
system.diagnostics.tools@4.0.1
system.dynamic.runtime@4.0.11
system.globalization@4.0.11
system.io.filesystem.primitives@4.0.1
system.io.filesystem@4.0.1
system.io@4.1.0
system.linq.expressions@4.1.0
system.linq@4.1.0
system.objectmodel@4.0.12
system.private.uri@4.0.1
system.reflection.emit.ilgeneration@4.0.1
system.reflection.emit.lightweight@4.0.1
system.reflection.emit@4.0.1
system.reflection.extensions@4.0.1
system.reflection.metadata@1.6.0
system.reflection.primitives@4.0.1
system.reflection.typeextensions@4.1.0
system.reflection@4.1.0
system.resources.resourcemanager@4.0.1
system.runtime.extensions@4.1.0
system.runtime.handles@4.0.1
system.runtime.interopservices@4.1.0
system.runtime.serialization.primitives@4.1.1
system.runtime@4.1.0
system.text.encoding.extensions@4.0.11
system.text.encoding@4.0.11
system.text.regularexpressions@4.1.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks@4.0.11
system.threading@4.0.11
system.xml.readerwriter@4.0.11
system.xml.xdocument@4.0.11
"

inherit dotnet-pkg

DESCRIPTION="Mond is a scripting language for .NET Core"
HOMEPAGE="https://rohbot.net/mond/
	https://github.com/Rohansi/Mond/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/Rohansi/${PN^}.git"
else
	SRC_URI="https://github.com/Rohansi/${PN^}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${P^}"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

DOTNET_PKG_PROJECTS=( Mond.Repl/Mond.Repl.csproj )
DOTNET_PKG_RESTORE_EXTRA_ARGS=(
	-p:RollForward=Major
	-p:TargetFramework="net${DOTNET_PKG_COMPAT}"
	-p:TargetFrameworks="net${DOTNET_PKG_COMPAT}"
)
DOTNET_PKG_BUILD_EXTRA_ARGS=( "${DOTNET_PKG_RESTORE_EXTRA_ARGS[@]}" )
DOTNET_PKG_TEST_EXTRA_ARGS=( "${DOTNET_PKG_RESTORE_EXTRA_ARGS[@]}" )

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

	einstalldocs
}
