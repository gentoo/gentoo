# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGETS="
argu@6.1.1
castle.core@5.1.1
coverlet.collector@3.0.3
dotnet.reproduciblebuilds@1.1.1
fsharp.core@6.0.0
fsharp.core@8.0.100
humanizer.core@2.14.1
icsharpcode.decompiler@8.1.1.7464
ionide.keepachangelog.tasks@0.1.8
messagepack.annotations@2.5.108
messagepack@2.5.108
microsoft.bcl.asyncinterfaces@7.0.0
microsoft.build.framework@17.7.2
microsoft.build.locator@1.6.10
microsoft.build.tasks.git@1.1.1
microsoft.build@17.7.2
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.analyzerutilities@3.3.0
microsoft.codeanalysis.common@4.7.0
microsoft.codeanalysis.csharp.features@4.7.0
microsoft.codeanalysis.csharp.workspaces@4.7.0
microsoft.codeanalysis.csharp@4.7.0
microsoft.codeanalysis.elfie@1.0.0
microsoft.codeanalysis.features@4.7.0
microsoft.codeanalysis.scripting.common@4.7.0
microsoft.codeanalysis.visualbasic.workspaces@4.7.0
microsoft.codeanalysis.visualbasic@4.7.0
microsoft.codeanalysis.workspaces.common@4.7.0
microsoft.codeanalysis.workspaces.msbuild@4.7.0
microsoft.codeanalysis@4.7.0
microsoft.codecoverage@16.10.0
microsoft.csharp@4.0.1
microsoft.diasymreader@2.0.0
microsoft.net.stringtools@17.4.0
microsoft.net.stringtools@17.7.2
microsoft.net.test.sdk@16.10.0
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@2.0.0
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.0.1
microsoft.sourcelink.azurerepos.git@1.1.1
microsoft.sourcelink.bitbucket.git@1.1.1
microsoft.sourcelink.common@1.1.1
microsoft.sourcelink.github@1.1.1
microsoft.sourcelink.gitlab@1.1.1
microsoft.testplatform.objectmodel@16.10.0
microsoft.testplatform.testhost@16.10.0
microsoft.visualstudio.threading.analyzers@17.6.40
microsoft.visualstudio.threading@17.6.40
microsoft.visualstudio.validation@17.6.11
microsoft.win32.registry@5.0.0
microsoft.win32.systemevents@7.0.0
nerdbank.streams@2.10.66
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@13.0.1
newtonsoft.json@13.0.3
newtonsoft.json@9.0.1
nuget.frameworks@5.0.0
nunit3testadapter@4.0.0
nunit@3.13.2
streamjsonrpc@2.16.36
system.buffers@4.5.1
system.collections.immutable@6.0.0
system.collections.immutable@7.0.0
system.collections@4.0.11
system.composition.attributedmodel@7.0.0
system.composition.convention@7.0.0
system.composition.hosting@7.0.0
system.composition.runtime@7.0.0
system.composition.typedparts@7.0.0
system.composition@7.0.0
system.configuration.configurationmanager@4.4.0
system.configuration.configurationmanager@4.5.0
system.configuration.configurationmanager@7.0.0
system.data.datasetextensions@4.5.0
system.diagnostics.debug@4.0.11
system.diagnostics.diagnosticsource@7.0.2
system.diagnostics.eventlog@6.0.0
system.diagnostics.eventlog@7.0.0
system.diagnostics.tools@4.0.1
system.drawing.common@7.0.0
system.dynamic.runtime@4.0.11
system.globalization@4.0.11
system.io.filesystem.primitives@4.0.1
system.io.filesystem@4.0.1
system.io.pipelines@7.0.0
system.io@4.1.0
system.linq.expressions@4.1.0
system.linq@4.1.0
system.memory@4.5.4
system.memory@4.5.5
system.numerics.vectors@4.4.0
system.numerics.vectors@4.5.0
system.objectmodel@4.0.12
system.reflection.emit.ilgeneration@4.0.1
system.reflection.emit.ilgeneration@4.7.0
system.reflection.emit.lightweight@4.0.1
system.reflection.emit.lightweight@4.7.0
system.reflection.emit@4.0.1
system.reflection.emit@4.7.0
system.reflection.extensions@4.0.1
system.reflection.metadata@1.6.0
system.reflection.metadata@6.0.0
system.reflection.metadata@7.0.0
system.reflection.metadataloadcontext@7.0.0
system.reflection.primitives@4.0.1
system.reflection.typeextensions@4.1.0
system.reflection@4.1.0
system.resources.resourcemanager@4.0.1
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.1.0
system.runtime.handles@4.0.1
system.runtime.interopservices@4.1.0
system.runtime.serialization.primitives@4.1.1
system.runtime@4.1.0
system.security.accesscontrol@4.5.0
system.security.accesscontrol@5.0.0
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.protecteddata@4.5.0
system.security.cryptography.protecteddata@7.0.0
system.security.permissions@4.5.0
system.security.permissions@7.0.0
system.security.principal.windows@4.5.0
system.security.principal.windows@5.0.0
system.text.encoding.extensions@4.0.11
system.text.encoding@4.0.11
system.text.encodings.web@7.0.0
system.text.json@7.0.0
system.text.json@7.0.3
system.text.regularexpressions@4.1.0
system.threading.channels@7.0.0
system.threading.tasks.dataflow@7.0.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.0.11
system.threading@4.0.11
system.windows.extensions@7.0.0
system.xml.readerwriter@4.0.11
system.xml.xdocument@4.0.11
"

inherit dotnet-pkg

DESCRIPTION="Roslyn-based LSP language server for C#"
HOMEPAGE="https://github.com/razzmatazz/csharp-language-server/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/razzmatazz/${PN}.git"
else
	SRC_URI="https://github.com/razzmatazz/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"

DOTNET_PKG_PROJECTS=( src/CSharpLanguageServer/CSharpLanguageServer.fsproj )

DOCS=( CHANGELOG.md README.md )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/CSharpLanguageServer" csharp-ls

	einstalldocs
}
