# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGETS="
argu@6.2.3
castle.core@5.1.1
coverlet.collector@3.0.3
dotnet.reproduciblebuilds@1.1.1
fsharp.core@4.3.2
fsharp.core@6.0.0
fsharp.core@6.0.6
fsharpplus@1.6.1
humanizer.core@2.14.1
icsharpcode.decompiler@8.2.0.7535
ionide.keepachangelog.tasks@0.1.8
ionide.languageserverprotocol@0.6.0
messagepack.annotations@2.5.108
messagepack@2.5.108
microsoft.bcl.asyncinterfaces@7.0.0
microsoft.bcl.asyncinterfaces@8.0.0
microsoft.build.framework@17.10.4
microsoft.build.locator@1.7.8
microsoft.build.tasks.core@17.7.2
microsoft.build.tasks.git@1.1.1
microsoft.build.utilities.core@17.7.2
microsoft.build@17.10.4
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.analyzerutilities@3.3.0
microsoft.codeanalysis.common@4.10.0
microsoft.codeanalysis.csharp.features@4.10.0
microsoft.codeanalysis.csharp.workspaces@4.10.0
microsoft.codeanalysis.csharp@4.10.0
microsoft.codeanalysis.elfie@1.0.0
microsoft.codeanalysis.features@4.10.0
microsoft.codeanalysis.scripting.common@4.10.0
microsoft.codeanalysis.visualbasic.workspaces@4.10.0
microsoft.codeanalysis.visualbasic@4.10.0
microsoft.codeanalysis.workspaces.common@4.10.0
microsoft.codeanalysis.workspaces.msbuild@4.10.0
microsoft.codeanalysis@4.10.0
microsoft.codecoverage@17.6.3
microsoft.diasymreader@2.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.logging.abstractions@8.0.0
microsoft.net.stringtools@17.10.4
microsoft.net.stringtools@17.4.0
microsoft.net.stringtools@17.7.2
microsoft.net.test.sdk@17.6.3
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@5.0.0
microsoft.sourcelink.azurerepos.git@1.1.1
microsoft.sourcelink.bitbucket.git@1.1.1
microsoft.sourcelink.common@1.1.1
microsoft.sourcelink.github@1.1.1
microsoft.sourcelink.gitlab@1.1.1
microsoft.testplatform.objectmodel@17.6.3
microsoft.testplatform.testhost@17.6.3
microsoft.visualstudio.setup.configuration.interop@3.2.2146
microsoft.visualstudio.threading.analyzers@17.6.40
microsoft.visualstudio.threading@17.6.40
microsoft.visualstudio.validation@17.6.11
microsoft.win32.registry@5.0.0
nerdbank.streams@2.10.66
netstandard.library@2.0.0
newtonsoft.json@13.0.3
nuget.frameworks@6.5.0
nunit3testadapter@4.0.0
nunit@3.13.2
serilog.sinks.async@1.5.0
serilog.sinks.console@5.0.1
serilog@3.1.1
streamjsonrpc@2.16.36
system.buffers@4.5.1
system.codedom@7.0.0
system.collections.immutable@8.0.0
system.composition.attributedmodel@8.0.0
system.composition.convention@8.0.0
system.composition.hosting@8.0.0
system.composition.runtime@8.0.0
system.composition.typedparts@8.0.0
system.composition@8.0.0
system.configuration.configurationmanager@4.4.0
system.configuration.configurationmanager@8.0.0
system.data.datasetextensions@4.5.0
system.diagnostics.diagnosticsource@7.0.2
system.diagnostics.eventlog@6.0.0
system.diagnostics.eventlog@8.0.0
system.formats.asn1@7.0.0
system.io.pipelines@7.0.0
system.io.pipelines@8.0.0
system.memory@4.5.5
system.numerics.vectors@4.5.0
system.reflection.metadata@1.6.0
system.reflection.metadata@6.0.0
system.reflection.metadata@8.0.0
system.reflection.metadataloadcontext@8.0.0
system.resources.extensions@8.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.security.accesscontrol@5.0.0
system.security.cryptography.pkcs@7.0.2
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.protecteddata@8.0.0
system.security.cryptography.xml@7.0.1
system.security.permissions@8.0.0
system.security.principal.windows@5.0.0
system.text.encoding.codepages@7.0.0
system.text.encodings.web@7.0.0
system.text.encodings.web@8.0.0
system.text.json@7.0.3
system.text.json@8.0.0
system.threading.channels@7.0.0
system.threading.tasks.dataflow@7.0.0
system.threading.tasks.dataflow@8.0.0
system.threading.tasks.extensions@4.5.4
system.windows.extensions@8.0.0
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
