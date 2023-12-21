# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGET_APIS=(
	"https://api.nuget.org/v3-flatcontainer"
	"https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-tools/nuget/v3/flat2"
)
NUGETS="
benchmarkdotnet.annotations@0.13.10
benchmarkdotnet.diagnostics.windows@0.13.10
benchmarkdotnet@0.13.10
cake.scripting.abstractions@0.15.0
cake.scripting.transport@0.15.0
commandlineparser@2.9.1
diffplex@1.7.1
dotnet.script.dependencymodel.nuget@1.5.0
dotnet.script.dependencymodel@1.5.0
gee.external.capstone@2.3.0
humanizer.core@2.14.1
iced@1.17.0
icsharpcode.decompiler@8.2.0.7535
mcmaster.extensions.commandlineutils@4.1.0
mediatr@8.1.0
microsoft.aspnetcore.connections.abstractions@2.2.0
microsoft.aspnetcore.diagnostics.abstractions@2.2.0
microsoft.aspnetcore.diagnostics@2.2.0
microsoft.aspnetcore.hosting.abstractions@2.2.0
microsoft.aspnetcore.hosting.server.abstractions@2.2.0
microsoft.aspnetcore.hosting@2.2.0
microsoft.aspnetcore.http.abstractions@2.2.0
microsoft.aspnetcore.http.extensions@2.2.0
microsoft.aspnetcore.http.features@2.2.0
microsoft.aspnetcore.http@2.2.0
microsoft.aspnetcore.server.kestrel.core@2.2.0
microsoft.aspnetcore.server.kestrel.https@2.2.0
microsoft.aspnetcore.server.kestrel.transport.abstractions@2.2.0
microsoft.aspnetcore.server.kestrel.transport.sockets@2.2.0
microsoft.aspnetcore.server.kestrel@2.2.0
microsoft.aspnetcore.webutilities@2.2.0
microsoft.bcl.asyncinterfaces@1.1.0
microsoft.bcl.asyncinterfaces@7.0.0
microsoft.bcl.asyncinterfaces@8.0.0
microsoft.build.framework@17.3.2
microsoft.build.locator@1.6.10
microsoft.build.tasks.core@17.3.2
microsoft.build.utilities.core@17.3.2
microsoft.build@17.3.2
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.analyzerutilities@3.3.0
microsoft.codeanalysis.common@4.9.0-3.23611.3
microsoft.codeanalysis.csharp.features@4.9.0-3.23611.3
microsoft.codeanalysis.csharp.scripting@4.9.0-3.23611.3
microsoft.codeanalysis.csharp.workspaces@4.9.0-3.23611.3
microsoft.codeanalysis.csharp@4.9.0-3.23611.3
microsoft.codeanalysis.elfie@1.0.0
microsoft.codeanalysis.externalaccess.aspnetcore@4.9.0-3.23611.3
microsoft.codeanalysis.externalaccess.omnisharp.csharp@4.9.0-3.23611.3
microsoft.codeanalysis.externalaccess.omnisharp@4.9.0-3.23611.3
microsoft.codeanalysis.externalaccess.razorcompiler@4.9.0-3.23611.3
microsoft.codeanalysis.features@4.9.0-3.23611.3
microsoft.codeanalysis.scripting.common@4.9.0-3.23611.3
microsoft.codeanalysis.workspaces.common@4.9.0-3.23611.3
microsoft.codecoverage@17.8.0
microsoft.csharp@4.7.0
microsoft.diagnostics.netcore.client@0.2.251802
microsoft.diagnostics.runtime@2.2.332302
microsoft.diagnostics.tracing.traceevent@3.0.2
microsoft.diasymreader@2.0.0
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.caching.abstractions@8.0.0
microsoft.extensions.caching.memory@8.0.0
microsoft.extensions.configuration.abstractions@2.2.0
microsoft.extensions.configuration.abstractions@8.0.0
microsoft.extensions.configuration.binder@8.0.0
microsoft.extensions.configuration.commandline@8.0.0
microsoft.extensions.configuration.environmentvariables@8.0.0
microsoft.extensions.configuration.fileextensions@2.2.0
microsoft.extensions.configuration.fileextensions@8.0.0
microsoft.extensions.configuration.json@8.0.0
microsoft.extensions.configuration@8.0.0
microsoft.extensions.dependencyinjection.abstractions@2.2.0
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.dependencyinjection@8.0.0
microsoft.extensions.dependencymodel@8.0.0
microsoft.extensions.fileproviders.abstractions@2.2.0
microsoft.extensions.fileproviders.abstractions@8.0.0
microsoft.extensions.fileproviders.physical@8.0.0
microsoft.extensions.filesystemglobbing@8.0.0
microsoft.extensions.hosting.abstractions@2.2.0
microsoft.extensions.logging.abstractions@2.2.0
microsoft.extensions.logging.abstractions@7.0.1
microsoft.extensions.logging.abstractions@8.0.0
microsoft.extensions.logging.configuration@8.0.0
microsoft.extensions.logging.console@8.0.0
microsoft.extensions.logging@8.0.0
microsoft.extensions.objectpool@2.2.0
microsoft.extensions.options.configurationextensions@8.0.0
microsoft.extensions.options@8.0.0
microsoft.extensions.primitives@2.2.0
microsoft.extensions.primitives@8.0.0
microsoft.io.redist@6.0.0
microsoft.net.http.headers@2.2.0
microsoft.net.stringtools@17.3.2
microsoft.net.test.sdk@17.8.0
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.1.0
microsoft.netframework.referenceassemblies.net472@1.0.3
microsoft.netframework.referenceassemblies@1.0.3
microsoft.testplatform.objectmodel@17.8.0
microsoft.testplatform.testhost@17.8.0
microsoft.testplatform.translationlayer@17.8.0
microsoft.visualstudio.threading.analyzers@17.6.40
microsoft.visualstudio.threading@17.6.40
microsoft.visualstudio.validation@17.6.11
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@5.0.0
microsoft.win32.systemevents@6.0.0
nerdbank.streams@2.10.69
netstandard.library@1.6.1
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@13.0.3
nuget.common@6.8.0-rc.122
nuget.configuration@6.8.0-rc.122
nuget.dependencyresolver.core@6.8.0-rc.122
nuget.frameworks@6.8.0-rc.122
nuget.librarymodel@6.8.0-rc.122
nuget.packaging.core@6.8.0-rc.122
nuget.packaging@6.8.0-rc.122
nuget.projectmodel@6.8.0-rc.122
nuget.protocol@6.8.0-rc.122
nuget.versioning@6.8.0-rc.122
omnisharp.extensions.jsonrpc.generators@0.19.9
omnisharp.extensions.jsonrpc.testing@0.19.9
omnisharp.extensions.jsonrpc@0.19.9
omnisharp.extensions.languageclient@0.19.9
omnisharp.extensions.languageprotocol.testing@0.19.9
omnisharp.extensions.languageprotocol@0.19.9
omnisharp.extensions.languageserver.shared@0.19.9
omnisharp.extensions.languageserver@0.19.9
perfolizer@0.2.1
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
sqlitepclraw.bundle_green@2.1.0
sqlitepclraw.core@2.1.0
sqlitepclraw.lib.e_sqlite3@2.1.0
sqlitepclraw.provider.dynamic_cdecl@2.1.0
sqlitepclraw.provider.e_sqlite3@2.1.0
system.appcontext@4.3.0
system.buffers@4.3.0
system.buffers@4.4.0
system.buffers@4.5.0
system.buffers@4.5.1
system.codedom@6.0.0
system.collections.concurrent@4.3.0
system.collections.immutable@8.0.0
system.collections@4.3.0
system.componentmodel.annotations@5.0.0
system.componentmodel.composition@8.0.0
system.composition.attributedmodel@8.0.0
system.composition.convention@8.0.0
system.composition.hosting@8.0.0
system.composition.runtime@8.0.0
system.composition.typedparts@8.0.0
system.composition@8.0.0
system.configuration.configurationmanager@8.0.0
system.console@4.3.0
system.data.datasetextensions@4.5.0
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.diagnosticsource@4.5.0
system.diagnostics.diagnosticsource@8.0.0
system.diagnostics.eventlog@8.0.0
system.diagnostics.tools@4.3.0
system.diagnostics.tracing@4.3.0
system.drawing.common@6.0.0
system.formats.asn1@6.0.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.compression.zipfile@4.3.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io.pipelines@4.5.2
system.io.pipelines@7.0.0
system.io@4.3.0
system.linq.expressions@4.3.0
system.linq@4.3.0
system.management@5.0.0
system.memory@4.5.5
system.net.http@4.3.0
system.net.primitives@4.3.0
system.net.sockets@4.3.0
system.numerics.vectors@4.4.0
system.numerics.vectors@4.5.0
system.objectmodel@4.3.0
system.reactive@6.0.0
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.3.0
system.reflection.emit.lightweight@4.7.0
system.reflection.emit@4.3.0
system.reflection.emit@4.7.0
system.reflection.extensions@4.3.0
system.reflection.metadata@8.0.0
system.reflection.metadataloadcontext@6.0.0
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.3.0
system.reflection@4.3.0
system.resources.extensions@6.0.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@4.5.0
system.runtime.compilerservices.unsafe@4.5.1
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.0.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.3.0
system.security.accesscontrol@5.0.0
system.security.accesscontrol@6.0.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.cng@4.5.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.pkcs@6.0.1
system.security.cryptography.pkcs@6.0.4
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.protecteddata@8.0.0
system.security.cryptography.x509certificates@4.3.0
system.security.cryptography.xml@6.0.0
system.security.permissions@6.0.0
system.security.principal.windows@5.0.0
system.text.encoding.codepages@6.0.0
system.text.encoding.codepages@7.0.0
system.text.encoding.extensions@4.3.0
system.text.encoding@4.3.0
system.text.encodings.web@4.5.0
system.text.encodings.web@8.0.0
system.text.json@8.0.0
system.text.regularexpressions@4.3.0
system.threading.channels@6.0.0
system.threading.channels@7.0.0
system.threading.tasks.dataflow@8.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.extensions@4.5.1
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.3.0
system.threading.timer@4.3.0
system.threading@4.3.0
system.valuetuple@4.5.0
system.windows.extensions@6.0.0
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.3.0
xunit.abstractions@2.0.3
xunit.analyzers@1.4.0
xunit.assert@2.6.1
xunit.core@2.6.1
xunit.extensibility.core@2.6.1
xunit.extensibility.execution@2.6.1
xunit.runner.visualstudio@2.5.4
xunit@2.6.1
"

inherit check-reqs dotnet-pkg

DESCRIPTION="OmniSharp server (HTTP, STDIO) based on Roslyn workspaces"
HOMEPAGE="https://www.omnisharp.net/
	https://github.com/OmniSharp/omnisharp-roslyn/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/OmniSharp/${PN}.git"
else
	SRC_URI="https://github.com/OmniSharp/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"
RESTRICT="test"                                                   # Tests fail.

CHECKREQS_DISK_BUILD="2G"
DOTNET_PKG_PROJECTS=( src/OmniSharp.Stdio.Driver/OmniSharp.Stdio.Driver.csproj )

# These flags are set by Cake build script, except the removed below.
DOTNET_PKG_RESTORE_EXTRA_ARGS=(
	-p:AssemblyVersion="${PV}.0"
	-p:FileVersion="${PV}.0"
	-p:InformationalVersion="${PV}"
	-p:PackageVersion="${PV}"
	-p:RollForward=Major
)
DOTNET_PKG_BUILD_EXTRA_ARGS=(
	"${DOTNET_PKG_RESTORE_EXTRA_ARGS[@]}"
	--framework net6.0
)
DOTNET_PKG_TEST_EXTRA_ARGS=( "${DOTNET_PKG_RESTORE_EXTRA_ARGS[@]}" )

DOCS=( CHANGELOG.md README.md )

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

src_prepare() {
	sed -i */*/*.csproj \
		-e "/.*<RuntimeIdentifiers>.*/d" \
		-e "/.*<RuntimeFrameworkVersion>.*/d" \
		|| die
	rm NuGet.Config || die

	dotnet-pkg_src_prepare
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/OmniSharp" OmniSharp

	einstalldocs
}
