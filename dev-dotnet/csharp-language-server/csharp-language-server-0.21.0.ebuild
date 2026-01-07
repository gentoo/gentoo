# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
argu@6.2.5
castle.core@5.2.1
coverlet.collector@6.0.4
dotnet.reproduciblebuilds@1.2.25
fsharp.control.asyncseq@3.2.1
fsharp.core@4.7.2
fsharp.core@6.0.0
humanizer.core@2.14.1
icsharpcode.decompiler@9.1.0.7988
ionide.keepachangelog.tasks@0.1.8
ionide.languageserverprotocol@0.7.0
messagepack.annotations@2.5.108
messagepack@2.5.108
microsoft.bcl.asyncinterfaces@5.0.0
microsoft.bcl.asyncinterfaces@7.0.0
microsoft.bcl.asyncinterfaces@9.0.0
microsoft.build.framework@18.0.2
microsoft.build.locator@1.9.1
microsoft.build@18.0.2
microsoft.codeanalysis.analyzers@3.11.0
microsoft.codeanalysis.common@5.0.0
microsoft.codeanalysis.csharp.features@5.0.0
microsoft.codeanalysis.csharp.workspaces@5.0.0
microsoft.codeanalysis.csharp@5.0.0
microsoft.codeanalysis.elfie@1.0.0
microsoft.codeanalysis.features@5.0.0
microsoft.codeanalysis.scripting.common@5.0.0
microsoft.codeanalysis.visualbasic.workspaces@5.0.0
microsoft.codeanalysis.visualbasic@5.0.0
microsoft.codeanalysis.workspaces.common@5.0.0
microsoft.codeanalysis.workspaces.msbuild@5.0.0
microsoft.codeanalysis@5.0.0
microsoft.codecoverage@17.14.1
microsoft.diasymreader@2.0.0
microsoft.extensions.caching.abstractions@9.0.9
microsoft.extensions.caching.memory@9.0.9
microsoft.extensions.configuration.abstractions@9.0.9
microsoft.extensions.configuration.binder@9.0.9
microsoft.extensions.configuration@9.0.9
microsoft.extensions.dependencyinjection.abstractions@9.0.9
microsoft.extensions.dependencyinjection@9.0.0
microsoft.extensions.dependencyinjection@9.0.9
microsoft.extensions.logging.abstractions@9.0.0
microsoft.extensions.logging.abstractions@9.0.9
microsoft.extensions.logging.configuration@9.0.9
microsoft.extensions.logging.console@9.0.9
microsoft.extensions.logging@9.0.9
microsoft.extensions.options.configurationextensions@9.0.9
microsoft.extensions.options@9.0.0
microsoft.extensions.options@9.0.9
microsoft.extensions.primitives@9.0.0
microsoft.extensions.primitives@9.0.9
microsoft.net.stringtools@17.4.0
microsoft.net.stringtools@18.0.2
microsoft.net.test.sdk@17.14.1
microsoft.netcore.platforms@1.1.0
microsoft.testplatform.objectmodel@17.14.1
microsoft.testplatform.testhost@17.14.1
microsoft.visualstudio.solutionpersistence@1.0.52
microsoft.visualstudio.threading.analyzers@17.6.40
microsoft.visualstudio.threading@17.6.40
microsoft.visualstudio.validation@17.0.71
microsoft.visualstudio.validation@17.6.11
nerdbank.streams@2.10.66
netstandard.library@2.0.0
newtonsoft.json@13.0.4
nuget.frameworks@6.14.0
nunit3testadapter@4.6.0
nunit@3.14.0
streamjsonrpc@2.16.36
system.composition.attributedmodel@9.0.0
system.composition.convention@9.0.0
system.composition.hosting@9.0.0
system.composition.runtime@9.0.0
system.composition.typedparts@9.0.0
system.composition@9.0.0
system.configuration.configurationmanager@4.4.0
system.configuration.configurationmanager@4.5.0
system.configuration.configurationmanager@9.0.0
system.data.datasetextensions@4.5.0
system.diagnostics.eventlog@6.0.0
system.diagnostics.eventlog@9.0.0
system.reflection.metadataloadcontext@9.0.0
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.protecteddata@9.0.0
system.security.cryptography.protecteddata@9.0.6
"

inherit dotnet-pkg

DESCRIPTION="Roslyn-based LSP language server for C#"
HOMEPAGE="https://github.com/razzmatazz/csharp-language-server/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/razzmatazz/${PN}"
else
	SRC_URI="https://github.com/razzmatazz/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

# Tests hang. Also they spin up a web server so maybe that's part of the problem.
RESTRICT="test"

DOTNET_PKG_PROJECTS=( src/CSharpLanguageServer )
DOTNET_PKG_BAD_PROJECTS=( tests/CSharpLanguageServer.Tests )

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
