# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

APP_PV="${PV//./-}"

DOTNET_PKG_COMPAT="10.0"
NUGETS="
benchmarkdotnet.annotations@0.15.6
benchmarkdotnet@0.15.6
commandlineparser@2.9.1
coverlet.collector@6.0.4
fsharp.core@10.0.100
fsharp.core@6.0.0
fsharp.core@6.0.6
fsharp.core@9.0.101
fsharp.systemcommandline@2.0.0
fsharpplus@1.8.0
gee.external.capstone@2.3.0
glob@1.1.9
iced@1.21.0
markdig@0.43.0
messagepack.annotations@2.5.192
messagepack@2.5.192
microsoft.bcl.asyncinterfaces@1.1.0
microsoft.codeanalysis.analyzers@3.11.0
microsoft.codeanalysis.common@4.14.0
microsoft.codeanalysis.csharp@4.14.0
microsoft.codecoverage@18.0.1
microsoft.csharp@4.0.1
microsoft.diagnostics.netcore.client@0.2.410101
microsoft.diagnostics.netcore.client@0.2.510501
microsoft.diagnostics.runtime@3.1.512801
microsoft.diagnostics.tracing.traceevent@3.1.21
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.dependencyinjection.abstractions@6.0.0
microsoft.extensions.dependencyinjection@6.0.0
microsoft.extensions.logging.abstractions@6.0.0
microsoft.extensions.logging@2.1.1
microsoft.extensions.logging@6.0.0
microsoft.extensions.options@6.0.0
microsoft.extensions.primitives@6.0.0
microsoft.net.stringtools@17.6.3
microsoft.net.test.sdk@18.0.1
microsoft.netcore.platforms@5.0.0
microsoft.testplatform.objectmodel@18.0.1
microsoft.testplatform.testhost@18.0.1
microsoft.visualstudio.threading.only@17.13.61
microsoft.visualstudio.validation@17.8.8
microsoft.win32.registry@5.0.0
nerdbank.streams@2.12.87
newtonsoft.json@13.0.3
newtonsoft.json@13.0.4
newtonsoft.json@9.0.1
perfolizer@0.6.0
pragmastat@3.1.33
serilog.sinks.console@4.1.0
serilog@2.10.0
serilog@2.12.0
snapper@2.4.1
streamjsonrpc@2.22.23
system.codedom@9.0.5
system.collections.immutable@8.0.0
system.collections.immutable@9.0.0
system.collections@4.0.11
system.commandline@2.0.0
system.diagnostics.debug@4.0.11
system.diagnostics.diagnosticsource@6.0.0
system.dynamic.runtime@4.0.11
system.globalization@4.0.11
system.io.pipelines@8.0.0
system.io@4.1.0
system.linq.expressions@4.1.0
system.linq@4.1.0
system.management@9.0.5
system.objectmodel@4.0.12
system.reflection.extensions@4.0.1
system.reflection.metadata@8.0.0
system.reflection.metadata@9.0.0
system.reflection.typeextensions@4.7.0
system.reflection@4.1.0
system.resources.resourcemanager@4.0.1
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.1.0
system.runtime.serialization.primitives@4.1.1
system.runtime@4.1.0
system.security.accesscontrol@5.0.0
system.security.principal.windows@5.0.0
system.text.encoding.extensions@4.0.11
system.text.encoding@4.0.11
system.text.json@8.0.5
system.text.regularexpressions@4.1.0
system.threading.tasks@4.0.11
system.threading@4.0.11
system.xml.readerwriter@4.0.11
system.xml.xdocument@4.0.11
tomlyn@0.19.0
xunit.abstractions@2.0.3
xunit.analyzers@1.18.0
xunit.assert@2.9.3
xunit.core@2.9.3
xunit.extensibility.core@2.9.3
xunit.extensibility.execution@2.9.3
xunit.runner.visualstudio@3.1.5
xunit@2.9.3
"

inherit check-reqs dotnet-pkg

DESCRIPTION="LSP language server for editing Markdown files"
HOMEPAGE="https://github.com/artempyanykh/marksman/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/artempyanykh/${PN}"
else
	SRC_URI="https://github.com/artempyanykh/${PN}/archive/refs/tags/${APP_PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${APP_PV}"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0 BSD-2 MIT"
SLOT="0"

PATCHES=( "${FILESDIR}/marksman-2025.11.25-net10.0.patch" )

CHECKREQS_DISK_BUILD="1400M"
DOTNET_PKG_PROJECTS=( Marksman/Marksman.fsproj )
DOTNET_PKG_BUILD_EXTRA_ARGS=( -p:VersionString="${APP_PV}" )
DOTNET_PKG_TEST_EXTRA_ARGS=( "${DOTNET_PKG_BUILD_EXTRA_ARGS[@]}" )

DOCS=( README.md docs )

pkg_setup() {
	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
}

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}
