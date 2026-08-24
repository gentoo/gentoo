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
fsharp.core@10.0.101
humanizer.core@2.14.1
icsharpcode.decompiler@9.1.0.7988
ionide.keepachangelog.tasks@0.1.8
microsoft.applicationinsights@2.23.0
microsoft.bcl.asyncinterfaces@10.0.1
microsoft.bcl.asyncinterfaces@10.0.8
microsoft.bcl.asyncinterfaces@5.0.0
microsoft.build.framework@18.7.1
microsoft.build.locator@1.10.12
microsoft.build@18.7.1
microsoft.codeanalysis.analyzers@5.9.0-1.26328.17
microsoft.codeanalysis.common@5.9.0
microsoft.codeanalysis.csharp.features@5.9.0
microsoft.codeanalysis.csharp.workspaces@5.9.0
microsoft.codeanalysis.csharp@5.9.0
microsoft.codeanalysis.elfie@1.0.0
microsoft.codeanalysis.features@5.9.0
microsoft.codeanalysis.scripting.common@5.9.0
microsoft.codeanalysis.visualbasic.workspaces@5.9.0
microsoft.codeanalysis.visualbasic@5.9.0
microsoft.codeanalysis.workspaces.common@5.9.0
microsoft.codeanalysis.workspaces.msbuild@5.9.0
microsoft.codeanalysis@5.9.0
microsoft.codecoverage@17.14.1
microsoft.diasymreader@2.0.0
microsoft.extensions.caching.abstractions@10.0.9
microsoft.extensions.caching.memory@10.0.9
microsoft.extensions.configuration.abstractions@10.0.9
microsoft.extensions.configuration.binder@10.0.9
microsoft.extensions.configuration@10.0.9
microsoft.extensions.dependencyinjection.abstractions@10.0.9
microsoft.extensions.dependencyinjection@10.0.1
microsoft.extensions.dependencyinjection@10.0.9
microsoft.extensions.dependencymodel@8.0.2
microsoft.extensions.logging.abstractions@10.0.1
microsoft.extensions.logging.abstractions@10.0.9
microsoft.extensions.logging.configuration@10.0.9
microsoft.extensions.logging.console@10.0.9
microsoft.extensions.logging@10.0.9
microsoft.extensions.options.configurationextensions@10.0.9
microsoft.extensions.options@10.0.1
microsoft.extensions.options@10.0.9
microsoft.extensions.primitives@10.0.1
microsoft.extensions.primitives@10.0.9
microsoft.net.stringtools@18.7.1
microsoft.net.test.sdk@17.14.1
microsoft.netcore.platforms@1.1.0
microsoft.testing.extensions.telemetry@2.1.0
microsoft.testing.extensions.trxreport.abstractions@2.1.0
microsoft.testing.extensions.vstestbridge@2.1.0
microsoft.testing.platform.msbuild@2.1.0
microsoft.testing.platform@2.1.0
microsoft.testplatform.objectmodel@17.14.1
microsoft.testplatform.objectmodel@18.0.1
microsoft.testplatform.testhost@17.14.1
microsoft.visualstudio.solutionpersistence@1.0.52
netstandard.library@2.0.3
newtonsoft.json@13.0.4
nuget.frameworks@6.14.0
nunit3testadapter@6.2.0
nunit@4.6.1
system.buffers@4.6.1
system.composition.attributedmodel@10.0.1
system.composition.convention@10.0.1
system.composition.hosting@10.0.1
system.composition.runtime@10.0.1
system.composition.typedparts@10.0.1
system.composition@10.0.1
system.configuration.configurationmanager@10.0.1
system.configuration.configurationmanager@10.0.4
system.configuration.configurationmanager@4.4.0
system.configuration.configurationmanager@4.5.0
system.data.datasetextensions@4.5.0
system.diagnostics.eventlog@10.0.1
system.diagnostics.eventlog@10.0.4
system.diagnostics.eventlog@6.0.0
system.io.pipelines@10.0.8
system.memory@4.6.3
system.numerics.vectors@4.6.1
system.reflection.metadataloadcontext@10.0.4
system.runtime.compilerservices.unsafe@6.1.2
system.security.cryptography.protecteddata@10.0.1
system.security.cryptography.protecteddata@10.0.4
system.security.cryptography.protecteddata@4.4.0
system.text.encodings.web@10.0.8
system.text.json@10.0.8
system.threading.tasks.extensions@4.6.3
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
