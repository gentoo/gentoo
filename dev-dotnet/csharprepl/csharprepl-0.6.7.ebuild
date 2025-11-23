# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="CSharpRepl"
MY_P="${MY_PN}-${PV}"

DOTNET_PKG_COMPAT="8.0"
NUGETS="
ben.demystifier@0.4.1
castle.core@5.1.1
coverlet.collector@6.0.2
coverlet.msbuild@6.0.2
humanizer.core@2.14.1
icsharpcode.decompiler@8.2.0.7535
microsoft.build.framework@17.3.2
microsoft.build.locator@1.7.8
microsoft.build.tasks.core@17.3.2
microsoft.build.utilities.core@17.3.2
microsoft.build@17.3.2
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.analyzerutilities@3.3.0
microsoft.codeanalysis.common@4.9.2
microsoft.codeanalysis.csharp.features@4.9.2
microsoft.codeanalysis.csharp.scripting@4.9.2
microsoft.codeanalysis.csharp.workspaces@4.9.2
microsoft.codeanalysis.csharp@4.9.2
microsoft.codeanalysis.elfie@1.0.0
microsoft.codeanalysis.features@4.9.2
microsoft.codeanalysis.scripting.common@4.9.2
microsoft.codeanalysis.workspaces.common@4.9.2
microsoft.codeanalysis.workspaces.msbuild@4.9.2
microsoft.codecoverage@17.9.0
microsoft.csharp@4.3.0
microsoft.csharp@4.7.0
microsoft.diasymreader@2.0.0
microsoft.extensions.caching.abstractions@8.0.0
microsoft.extensions.caching.memory@8.0.0
microsoft.extensions.dependencyinjection.abstractions@7.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.dependencymodel@8.0.0
microsoft.extensions.fileproviders.abstractions@6.0.0
microsoft.extensions.filesystemglobbing@6.0.0
microsoft.extensions.logging.abstractions@8.0.0
microsoft.extensions.options@8.0.0
microsoft.extensions.primitives@6.0.0
microsoft.extensions.primitives@8.0.0
microsoft.fileformats@1.0.431901
microsoft.net.stringtools@17.3.2
microsoft.net.test.sdk@17.9.0
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@2.0.0
microsoft.netcore.targets@1.1.0
microsoft.symbolstore@1.0.431901
microsoft.testplatform.objectmodel@17.9.0
microsoft.testplatform.testhost@17.9.0
microsoft.web.xdt@3.0.0
microsoft.win32.systemevents@6.0.0
newtonsoft.json@13.0.1
newtonsoft.json@13.0.3
nsubstitute@5.1.0
nuget.commands@6.9.1
nuget.common@6.9.1
nuget.configuration@6.9.1
nuget.credentials@6.9.1
nuget.dependencyresolver.core@6.9.1
nuget.frameworks@6.9.1
nuget.librarymodel@6.9.1
nuget.packagemanagement@6.9.1
nuget.packaging.core@6.9.1
nuget.packaging@6.9.1
nuget.projectmodel@6.9.1
nuget.protocol@6.9.1
nuget.resolver@6.9.1
nuget.versioning@6.9.1
prettyprompt@4.1.1
spectre.console.cli@0.48.0
spectre.console.testing@0.48.0
spectre.console@0.48.0
system.codedom@6.0.0
system.collections.immutable@6.0.0
system.collections.immutable@8.0.0
system.collections@4.3.0
system.commandline@2.0.0-beta4.22272.1
system.componentmodel.composition@4.5.0
system.composition.attributedmodel@8.0.0
system.composition.convention@8.0.0
system.composition.hosting@8.0.0
system.composition.runtime@8.0.0
system.composition.typedparts@8.0.0
system.composition@8.0.0
system.configuration.configurationmanager@8.0.0
system.data.datasetextensions@4.5.0
system.diagnostics.debug@4.3.0
system.diagnostics.eventlog@6.0.0
system.diagnostics.eventlog@8.0.0
system.drawing.common@6.0.0
system.dynamic.runtime@4.3.0
system.formats.asn1@6.0.0
system.globalization@4.3.0
system.io.abstractions.testinghelpers@21.0.2
system.io.abstractions@21.0.2
system.io.pipelines@8.0.0
system.io@4.3.0
system.linq.expressions@4.3.0
system.linq@4.3.0
system.memory@4.5.5
system.objectmodel@4.3.0
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.3.0
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.metadata@1.8.1
system.reflection.metadata@5.0.0
system.reflection.metadata@6.0.0
system.reflection.metadata@8.0.0
system.reflection.metadataloadcontext@6.0.0
system.reflection.metadataloadcontext@8.0.0
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.3.0
system.reflection@4.3.0
system.resources.extensions@6.0.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices@4.3.0
system.runtime@4.3.0
system.security.accesscontrol@4.5.0
system.security.accesscontrol@6.0.0
system.security.cryptography.pkcs@6.0.1
system.security.cryptography.pkcs@6.0.4
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.protecteddata@8.0.0
system.security.cryptography.xml@6.0.0
system.security.permissions@4.5.0
system.security.permissions@6.0.0
system.security.principal.windows@4.5.0
system.security.principal.windows@5.0.0
system.text.encoding.codepages@6.0.0
system.text.encoding@4.3.0
system.text.encodings.web@8.0.0
system.text.json@8.0.0
system.threading.channels@8.0.0
system.threading.tasks.dataflow@6.0.0
system.threading.tasks@4.3.0
system.threading@4.3.0
system.windows.extensions@6.0.0
testableio.system.io.abstractions.testinghelpers@21.0.2
testableio.system.io.abstractions.wrappers@21.0.2
testableio.system.io.abstractions@21.0.2
textcopy@6.2.1
xunit.abstractions@2.0.3
xunit.analyzers@1.11.0
xunit.assert@2.7.0
xunit.core@2.7.0
xunit.extensibility.core@2.7.0
xunit.extensibility.execution@2.7.0
xunit.runner.visualstudio@2.5.7
xunit@2.7.0
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

	KEYWORDS="amd64"
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

dotnet-pkg_force-compat

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
