# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=7.0
NUGETS="
argu@6.1.1
castle.core@5.1.1
coverlet.collector@3.0.3
fsharp.core@7.0.0
humanizer.core@2.14.1
icsharpcode.decompiler@8.0.0.7345
ionide.keepachangelog.tasks@0.1.8
ionide.languageserverprotocol@0.4.15
messagepack.annotations@2.3.85
messagepack@2.3.85
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.bcl.asyncinterfaces@7.0.0
microsoft.build.framework@17.6.3
microsoft.build.locator@1.5.5
microsoft.build@17.6.3
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.analyzerutilities@3.3.0
microsoft.codeanalysis.common@4.7.0-1.final
microsoft.codeanalysis.csharp.features@4.7.0-1.final
microsoft.codeanalysis.csharp.workspaces@4.7.0-1.final
microsoft.codeanalysis.csharp@4.7.0-1.final
microsoft.codeanalysis.elfie@1.0.0
microsoft.codeanalysis.features@4.7.0-1.final
microsoft.codeanalysis.scripting.common@4.7.0-1.final
microsoft.codeanalysis.visualbasic.workspaces@4.7.0-1.final
microsoft.codeanalysis.visualbasic@4.7.0-1.final
microsoft.codeanalysis.workspaces.common@4.7.0-1.final
microsoft.codeanalysis.workspaces.msbuild@4.7.0-1.final
microsoft.codeanalysis@4.7.0-1.final
microsoft.codecoverage@16.10.0
microsoft.csharp@4.0.1
microsoft.diasymreader@1.4.0
microsoft.net.stringtools@17.6.3
microsoft.net.test.sdk@16.10.0
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.platforms@2.0.0
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.testplatform.objectmodel@16.10.0
microsoft.testplatform.testhost@16.10.0
microsoft.visualstudio.threading.analyzers@17.0.64
microsoft.visualstudio.threading@17.0.64
microsoft.visualstudio.validation@16.10.26
microsoft.visualstudio.validation@16.10.35
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@5.0.0
microsoft.win32.systemevents@7.0.0
nerdbank.streams@2.8.54
netstandard.library@1.6.1
netstandard.library@2.0.0
newtonsoft.json@13.0.2
newtonsoft.json@9.0.1
nuget.frameworks@5.0.0
nunit@3.13.2
nunit3testadapter@4.0.0
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
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system.io.compression@4.3.0
runtime.native.system.net.http@4.3.0
runtime.native.system.security.cryptography.apple@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.unix.microsoft.win32.primitives@4.3.0
runtime.unix.system.console@4.3.0
runtime.unix.system.diagnostics.debug@4.3.0
runtime.unix.system.io.filesystem@4.3.0
runtime.unix.system.net.primitives@4.3.0
runtime.unix.system.net.sockets@4.3.0
runtime.unix.system.private.uri@4.3.0
runtime.unix.system.runtime.extensions@4.3.0
streamjsonrpc@2.10.44
system.appcontext@4.3.0
system.buffers@4.3.0
system.collections.concurrent@4.3.0
system.collections.immutable@5.0.0
system.collections.immutable@6.0.0
system.collections.immutable@7.0.0
system.collections@4.0.11
system.collections@4.3.0
system.composition.attributedmodel@7.0.0
system.composition.convention@7.0.0
system.composition.hosting@7.0.0
system.composition.runtime@7.0.0
system.composition.typedparts@7.0.0
system.composition@7.0.0
system.configuration.configurationmanager@4.4.0
system.configuration.configurationmanager@4.5.0
system.configuration.configurationmanager@7.0.0
system.console@4.3.0
system.data.datasetextensions@4.5.0
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.diagnosticsource@6.0.0
system.diagnostics.eventlog@6.0.0
system.diagnostics.eventlog@7.0.0
system.diagnostics.tools@4.0.1
system.diagnostics.tools@4.3.0
system.diagnostics.tracing@4.3.0
system.drawing.common@7.0.0
system.dynamic.runtime@4.0.11
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.0.11
system.globalization@4.3.0
system.io.compression.zipfile@4.3.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.0.1
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.0.1
system.io.filesystem@4.3.0
system.io.pipelines@6.0.1
system.io.pipelines@7.0.0
system.io@4.1.0
system.io@4.3.0
system.linq.expressions@4.1.0
system.linq.expressions@4.3.0
system.linq@4.1.0
system.linq@4.3.0
system.memory@4.5.4
system.net.http@4.3.0
system.net.http@4.3.4
system.net.nameresolution@4.3.0
system.net.primitives@4.3.0
system.net.sockets@4.3.0
system.net.websockets@4.3.0
system.objectmodel@4.0.12
system.objectmodel@4.3.0
system.private.uri@4.3.0
system.reflection.emit.ilgeneration@4.0.1
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.0.1
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.0.1
system.reflection.emit@4.3.0
system.reflection.emit@4.7.0
system.reflection.extensions@4.0.1
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.metadata@6.0.0
system.reflection.metadata@7.0.0
system.reflection.metadataloadcontext@7.0.0
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.1.0
system.reflection.typeextensions@4.3.0
system.reflection@4.1.0
system.reflection@4.3.0
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.1.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.0.1
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.1.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime.serialization.primitives@4.1.1
system.runtime@4.1.0
system.runtime@4.3.0
system.security.accesscontrol@4.5.0
system.security.accesscontrol@5.0.0
system.security.claims@4.3.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.protecteddata@4.5.0
system.security.cryptography.protecteddata@7.0.0
system.security.cryptography.x509certificates@4.3.0
system.security.permissions@4.5.0
system.security.permissions@7.0.0
system.security.principal.windows@4.3.0
system.security.principal.windows@4.5.0
system.security.principal.windows@5.0.0
system.security.principal@4.3.0
system.text.encoding.codepages@7.0.0
system.text.encoding.extensions@4.0.11
system.text.encoding.extensions@4.3.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.text.encodings.web@7.0.0
system.text.json@7.0.0
system.text.regularexpressions@4.1.0
system.text.regularexpressions@4.3.0
system.threading.channels@7.0.0
system.threading.tasks.dataflow@6.0.0
system.threading.tasks.dataflow@7.0.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.threadpool@4.3.0
system.threading.timer@4.3.0
system.threading@4.0.11
system.threading@4.3.0
system.windows.extensions@7.0.0
system.xml.readerwriter@4.0.11
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.0.11
system.xml.xdocument@4.3.0
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
S="${WORKDIR}/${P}/src"

LICENSE="MIT"
SLOT="0"

DOTNET_PKG_PROJECTS=( CSharpLanguageServer/CSharpLanguageServer.fsproj )

DOCS=( ../CHANGELOG.md ../README.md )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n ${EGIT_REPO_URI} ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	default

	dotnet-pkg-base_remove-global-json ../
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/CSharpLanguageServer" csharp-ls

	einstalldocs
}
