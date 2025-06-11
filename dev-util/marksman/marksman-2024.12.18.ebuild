# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

APP_PV="${PV//./-}"

DOTNET_PKG_COMPAT="9.0"
NUGETS="
benchmarkdotnet.annotations@0.14.0
benchmarkdotnet@0.14.0
commandlineparser@2.9.1
coverlet.collector@6.0.2
fsharp.core@6.0.0
fsharp.core@6.0.6
fsharp.core@9.0.100
fsharp.systemcommandline@0.13.0-beta4
fsharpplus@1.6.1
gee.external.capstone@2.3.0
glob@1.1.9
iced@1.17.0
markdig@0.38.0
messagepack.annotations@2.5.108
messagepack@2.5.108
microsoft.bcl.asyncinterfaces@1.1.0
microsoft.bcl.asyncinterfaces@7.0.0
microsoft.codeanalysis.analyzers@3.3.3
microsoft.codeanalysis.common@4.1.0
microsoft.codeanalysis.csharp@4.1.0
microsoft.codecoverage@17.11.1
microsoft.csharp@4.0.1
microsoft.diagnostics.netcore.client@0.2.251802
microsoft.diagnostics.runtime@2.2.332302
microsoft.diagnostics.tracing.traceevent@3.1.8
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.configuration.abstractions@2.1.1
microsoft.extensions.configuration.binder@2.1.1
microsoft.extensions.configuration@2.1.1
microsoft.extensions.dependencyinjection.abstractions@2.1.1
microsoft.extensions.logging.abstractions@2.1.1
microsoft.extensions.logging@2.1.1
microsoft.extensions.options@2.1.1
microsoft.extensions.primitives@2.1.1
microsoft.net.stringtools@17.4.0
microsoft.net.test.sdk@17.11.1
microsoft.netcore.platforms@2.0.0
microsoft.netcore.platforms@2.1.2
microsoft.netcore.platforms@5.0.0
microsoft.testplatform.objectmodel@17.11.1
microsoft.testplatform.testhost@17.11.1
microsoft.visualstudio.threading.analyzers@17.6.40
microsoft.visualstudio.threading@17.6.40
microsoft.visualstudio.validation@17.0.71
microsoft.visualstudio.validation@17.6.11
microsoft.win32.registry@4.4.0
microsoft.win32.registry@5.0.0
nerdbank.streams@2.10.66
newtonsoft.json@13.0.1
newtonsoft.json@13.0.3
newtonsoft.json@9.0.1
perfolizer@0.3.17
serilog.sinks.console@4.0.1
serilog@2.10.0
serilog@2.11.0
snapper@2.4.1
streamjsonrpc@2.16.36
system.codedom@5.0.0
system.collections.immutable@5.0.0
system.collections.immutable@7.0.0
system.collections@4.0.11
system.commandline@2.0.0-beta4.22272.1
system.diagnostics.debug@4.0.11
system.diagnostics.diagnosticsource@7.0.2
system.dynamic.runtime@4.0.11
system.globalization@4.0.11
system.io.pipelines@7.0.0
system.io@4.1.0
system.linq.expressions@4.1.0
system.linq@4.1.0
system.management@5.0.0
system.memory@4.5.1
system.memory@4.5.4
system.memory@4.5.5
system.objectmodel@4.0.12
system.reflection.extensions@4.0.1
system.reflection.metadata@1.6.0
system.reflection.metadata@5.0.0
system.reflection@4.1.0
system.resources.resourcemanager@4.0.1
system.runtime.compilerservices.unsafe@4.5.1
system.runtime.compilerservices.unsafe@4.5.2
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.1.0
system.runtime.serialization.primitives@4.1.1
system.runtime@4.1.0
system.security.accesscontrol@4.4.0
system.security.accesscontrol@5.0.0
system.security.principal.windows@4.4.0
system.security.principal.windows@5.0.0
system.text.encoding.codepages@4.5.1
system.text.encoding.extensions@4.0.11
system.text.encoding@4.0.11
system.text.encodings.web@7.0.0
system.text.json@7.0.3
system.text.regularexpressions@4.1.0
system.threading.tasks.dataflow@7.0.0
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.0.11
system.threading@4.0.11
system.xml.readerwriter@4.0.11
system.xml.xdocument@4.0.11
tomlyn@0.17.0
xunit.abstractions@2.0.3
xunit.analyzers@1.16.0
xunit.assert@2.9.2
xunit.core@2.9.2
xunit.extensibility.core@2.9.2
xunit.extensibility.execution@2.9.2
xunit.runner.visualstudio@2.8.2
xunit@2.9.2
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

LICENSE="MIT"
SLOT="0"

PATCHES=( "${FILESDIR}/marksman-2024.12.18-net9.0.patch"  )

CHECKREQS_DISK_BUILD="1400M"
DOTNET_PKG_PROJECTS=( Marksman/Marksman.fsproj )
DOTNET_PKG_BUILD_EXTRA_ARGS=( -p:VersionString="${APP_PV}" )
DOTNET_PKG_TEST_EXTRA_ARGS=( "${DOTNET_PKG_BUILD_EXTRA_ARGS[@]}" )

DOCS=( README.md docs )

dotnet-pkg_force-compat

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
