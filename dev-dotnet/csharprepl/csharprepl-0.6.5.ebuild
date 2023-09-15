# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=CSharpRepl
MY_P="${MY_PN}-${PV}"

DOTNET_PKG_COMPAT=7.0
NUGETS="
ben.demystifier@0.4.1
castle.core@5.0.0
coverlet.collector@6.0.0
coverlet.msbuild@6.0.0
humanizer.core@2.14.1
icsharpcode.decompiler@8.0.0.7345
microsoft.bcl.asyncinterfaces@7.0.0
microsoft.build.framework@16.10.0
microsoft.build.locator@1.5.5
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.analyzerutilities@3.3.0
microsoft.codeanalysis.common@4.6.0
microsoft.codeanalysis.csharp.features@4.6.0
microsoft.codeanalysis.csharp.scripting@4.6.0
microsoft.codeanalysis.csharp.workspaces@4.6.0
microsoft.codeanalysis.csharp@4.6.0
microsoft.codeanalysis.elfie@1.0.0
microsoft.codeanalysis.features@4.6.0
microsoft.codeanalysis.scripting.common@4.6.0
microsoft.codeanalysis.workspaces.common@4.6.0
microsoft.codeanalysis.workspaces.msbuild@4.6.0
microsoft.codecoverage@17.6.3
microsoft.csharp@4.3.0
microsoft.csharp@4.7.0
microsoft.diasymreader@1.4.0
microsoft.extensions.caching.abstractions@7.0.0
microsoft.extensions.caching.memory@7.0.0
microsoft.extensions.dependencyinjection.abstractions@7.0.0
microsoft.extensions.dependencymodel@7.0.0
microsoft.extensions.fileproviders.abstractions@6.0.0
microsoft.extensions.filesystemglobbing@6.0.0
microsoft.extensions.logging.abstractions@7.0.0
microsoft.extensions.options@7.0.0
microsoft.extensions.primitives@6.0.0
microsoft.extensions.primitives@7.0.0
microsoft.fileformats@1.0.431901
microsoft.net.test.sdk@17.6.3
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@2.0.0
microsoft.netcore.platforms@3.1.0
microsoft.netcore.targets@1.1.0
microsoft.symbolstore@1.0.431901
microsoft.testplatform.objectmodel@17.6.3
microsoft.testplatform.testhost@17.6.3
microsoft.web.xdt@3.0.0
microsoft.win32.primitives@4.3.0
microsoft.win32.systemevents@4.7.0
microsoft.win32.systemevents@7.0.0
netstandard.library@1.6.1
newtonsoft.json@13.0.1
nsubstitute@5.0.0
nuget.commands@6.6.1
nuget.common@6.6.1
nuget.configuration@6.6.1
nuget.credentials@6.6.1
nuget.dependencyresolver.core@6.6.1
nuget.frameworks@6.5.0
nuget.frameworks@6.6.1
nuget.librarymodel@6.6.1
nuget.packagemanagement@6.6.1
nuget.packaging@6.6.1
nuget.projectmodel@6.6.1
nuget.protocol@6.6.1
nuget.resolver@6.6.1
nuget.versioning@6.6.1
prettyprompt@4.1.0
runtime.any.system.collections@4.3.0
runtime.any.system.diagnostics.tools@4.3.0
runtime.any.system.diagnostics.tracing@4.3.0
runtime.any.system.globalization.calendars@4.3.0
runtime.any.system.globalization@4.3.0
runtime.any.system.io@4.3.0
runtime.any.system.reflection.extensions@4.3.0
runtime.any.system.reflection.primitives@4.3.0
runtime.any.system.reflection@4.3.0
runtime.any.system.resources.resourcemanager@4.3.0
runtime.any.system.runtime.handles@4.3.0
runtime.any.system.runtime.interopservices@4.3.0
runtime.any.system.runtime@4.3.0
runtime.any.system.text.encoding.extensions@4.3.0
runtime.any.system.text.encoding@4.3.0
runtime.any.system.threading.tasks@4.3.0
runtime.any.system.threading.timer@4.3.0
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system.io.compression@4.3.0
runtime.native.system.net.http@4.3.0
runtime.native.system.security.cryptography.apple@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.unix.microsoft.win32.primitives@4.3.0
runtime.unix.system.console@4.3.0
runtime.unix.system.diagnostics.debug@4.3.0
runtime.unix.system.io.filesystem@4.3.0
runtime.unix.system.net.primitives@4.3.0
runtime.unix.system.net.sockets@4.3.0
runtime.unix.system.private.uri@4.3.0
runtime.unix.system.runtime.extensions@4.3.0
spectre.console.cli@0.47.0
spectre.console.testing@0.47.0
spectre.console@0.47.0
system.appcontext@4.3.0
system.buffers@4.3.0
system.collections.concurrent@4.3.0
system.collections.immutable@6.0.0
system.collections.immutable@7.0.0
system.collections@4.3.0
system.commandline@2.0.0-beta4.22272.1
system.componentmodel.composition@4.5.0
system.composition.attributedmodel@7.0.0
system.composition.convention@7.0.0
system.composition.hosting@7.0.0
system.composition.runtime@7.0.0
system.composition.typedparts@7.0.0
system.composition@7.0.0
system.configuration.configurationmanager@7.0.0
system.console@4.3.0
system.data.datasetextensions@4.5.0
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.eventlog@6.0.0
system.diagnostics.eventlog@7.0.0
system.diagnostics.tools@4.3.0
system.diagnostics.tracing@4.3.0
system.drawing.common@4.7.0
system.drawing.common@7.0.0
system.dynamic.runtime@4.3.0
system.formats.asn1@5.0.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.abstractions.testinghelpers@19.2.29
system.io.abstractions@19.2.29
system.io.compression.zipfile@4.3.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io.pipelines@7.0.0
system.io@4.3.0
system.linq.expressions@4.3.0
system.linq@4.3.0
system.memory@4.5.5
system.net.http@4.3.0
system.net.nameresolution@4.3.0
system.net.primitives@4.3.0
system.net.sockets@4.3.0
system.objectmodel@4.3.0
system.private.uri@4.3.0
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.3.0
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.metadata@1.8.1
system.reflection.metadata@5.0.0
system.reflection.metadata@6.0.0
system.reflection.metadata@7.0.0
system.reflection.metadataloadcontext@7.0.0
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.3.0
system.reflection@4.3.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.3.0
system.security.accesscontrol@4.5.0
system.security.accesscontrol@4.7.0
system.security.claims@4.3.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.cng@5.0.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.pkcs@5.0.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.protecteddata@7.0.0
system.security.cryptography.x509certificates@4.3.0
system.security.permissions@4.5.0
system.security.permissions@4.7.0
system.security.permissions@7.0.0
system.security.principal.windows@4.3.0
system.security.principal.windows@4.5.0
system.security.principal.windows@4.7.0
system.security.principal@4.3.0
system.text.encoding.codepages@7.0.0
system.text.encoding.extensions@4.3.0
system.text.encoding@4.3.0
system.text.encodings.web@7.0.0
system.text.json@7.0.0
system.text.regularexpressions@4.3.0
system.threading.channels@7.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks@4.3.0
system.threading.threadpool@4.3.0
system.threading.timer@4.3.0
system.threading@4.3.0
system.windows.extensions@4.7.0
system.windows.extensions@7.0.0
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.3.0
testableio.system.io.abstractions.testinghelpers@19.2.29
testableio.system.io.abstractions.wrappers@19.2.29
testableio.system.io.abstractions@19.2.29
textcopy@6.2.1
xunit.abstractions@2.0.3
xunit.analyzers@1.2.0
xunit.assert@2.5.0
xunit.core@2.5.0
xunit.extensibility.core@2.5.0
xunit.extensibility.execution@2.5.0
xunit.runner.visualstudio@2.5.0
xunit@2.5.0
"

inherit dotnet-pkg

DESCRIPTION="A command line C# REPL with syntax highlighting"
HOMEPAGE="https://fuqua.io/CSharpRepl/
	https://github.com/waf/CSharpRepl/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/waf/${MY_PN}.git"
else
	SRC_URI="https://github.com/waf/${MY_PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${MY_P}"

	KEYWORDS="~amd64"
fi

AZURE_DNCENG_V2_URI="https://pkgs.dev.azure.com/dnceng/public/_apis/packaging/feeds/d1622942-d16f-48e5-bc83-96f4539e7601/nuget/packages"
SRC_URI+="
	${NUGET_URIS}

	${AZURE_DNCENG_V2_URI}/Microsoft.FileFormats/versions/1.0.431901/content
		-> microsoft.fileformats.1.0.431901.nupkg
	${AZURE_DNCENG_V2_URI}/Microsoft.SymbolStore/versions/1.0.431901/content
		-> microsoft.symbolstore.1.0.431901.nupkg
"

LICENSE="MPL-2.0"
SLOT="0"
RESTRICT="test"  # Fails.

DOTNET_PKG_PROJECTS=( "${MY_PN}/${MY_PN}.csproj" )

DOCS=( ARCHITECTURE.md CHANGELOG.md README.md )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n ${EGIT_REPO_URI} ]] ; then
		git-r3_src_unpack
	fi
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/CSharpRepl" "${PN}"

	einstalldocs
}
