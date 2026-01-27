# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

APP_PN="FsAutoComplete"
DOTNET_PKG_COMPAT="10.0"

NUGETS="
System.Security.Cryptography.OpenSsl@5.0.0
runtime.debian.8-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.debian.9-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.fedora.23-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.fedora.24-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.fedora.27-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.fedora.28-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.native.System.Security.Cryptography.Apple@4.3.1
runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.opensuse.13.2-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.opensuse.42.1-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.opensuse.42.3-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.osx.10.10-x64.runtime.native.System.Security.Cryptography.Apple@4.3.1
runtime.osx.10.10-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.rhel.7-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.ubuntu.14.04-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.ubuntu.16.04-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.ubuntu.16.10-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.ubuntu.18.04-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3

altcover@9.0.1
benchmarkdotnet.annotations@0.14.0
benchmarkdotnet@0.14.0
cliwrap@3.6.7
commandlineparser@2.9.1
communitytoolkit.highperformance@8.3.2
destructurama.fsharp@2.0.0
diffplex@1.7.2
dotnet-reportgenerator-globaltool@5.3.8
dotnet.reproduciblebuilds@1.2.25
expecto.diff@10.2.1
expecto@10.2.3
fantomas.client@0.9.1
fantomas@7.0.3
fparsec@1.1.1
fsharp-analyzers@0.33.0
fsharp.analyzers.build@0.3.0
fsharp.analyzers.sdk@0.34.1
fsharp.compiler.service@43.10.100
fsharp.control.asyncseq@3.2.1
fsharp.control.reactive@5.0.5
fsharp.core@10.0.100
fsharp.data.adaptive@1.2.18
fsharp.formatting@14.0.1
fsharp.umx@1.1.0
fsharplint.core@0.23.0
fsharpx.async@1.14.1
fstoolkit.errorhandling.taskresult@4.18.0
fstoolkit.errorhandling@4.18.0
gee.external.capstone@2.3.0
githubactionstestlogger@2.4.1
google.protobuf@3.28.3
grpc.core.api@2.66.0
grpc.core@2.46.6
grpc.net.client@2.66.0
grpc.net.common@2.66.0
grpc@2.46.6
humanizer.core@2.14.1
iced@1.21.0
icedtasks@0.11.7
icsharpcode.decompiler@8.2.0.7535
ionide.analyzers@0.14.10
ionide.keepachangelog.tasks@0.3.1
ionide.languageserverprotocol@0.7.0
ionide.projinfo.fcs@0.74.1
ionide.projinfo.projectsystem@0.74.1
ionide.projinfo@0.74.1
linkdotnet.stringbuilder@1.18.0
mcmaster.netcore.plugins@2.0.0
messagepack.annotations@2.5.192
messagepack@2.5.187
messagepack@2.5.192
microsoft.bcl.asyncinterfaces@9.0.1
microsoft.bcl.cryptography@9.0.1
microsoft.bcl.hashcode@6.0.0
microsoft.build.framework@17.12.6
microsoft.build.locator@1.7.8
microsoft.build.tasks.core@17.12.6
microsoft.build.utilities.core@17.12.6
microsoft.build@17.12.6
microsoft.codeanalysis.analyzers@3.11.0
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.common@4.11.0
microsoft.codeanalysis.csharp.workspaces@4.11.0
microsoft.codeanalysis.csharp@4.11.0
microsoft.codeanalysis.visualbasic.workspaces@4.11.0
microsoft.codeanalysis.visualbasic@4.11.0
microsoft.codeanalysis.workspaces.common@4.11.0
microsoft.codeanalysis@4.11.0
microsoft.codecoverage@17.12.0
microsoft.diagnostics.netcore.client@0.2.553101
microsoft.diagnostics.runtime@3.1.512801
microsoft.diagnostics.tracing.traceevent@3.1.18
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.caching.abstractions@9.0.1
microsoft.extensions.caching.memory@9.0.1
microsoft.extensions.configuration.abstractions@9.0.1
microsoft.extensions.configuration.binder@9.0.1
microsoft.extensions.configuration@9.0.1
microsoft.extensions.dependencyinjection.abstractions@9.0.1
microsoft.extensions.dependencyinjection@9.0.1
microsoft.extensions.diagnostics.abstractions@9.0.1
microsoft.extensions.logging.abstractions@6.0.0
microsoft.extensions.logging.abstractions@9.0.1
microsoft.extensions.logging.configuration@9.0.1
microsoft.extensions.logging@8.0.0
microsoft.extensions.logging@9.0.1
microsoft.extensions.options.configurationextensions@9.0.1
microsoft.extensions.options@9.0.1
microsoft.extensions.primitives@9.0.1
microsoft.io.redist@6.0.1
microsoft.net.stringtools@17.12.6
microsoft.net.stringtools@17.6.3
microsoft.net.test.sdk@17.12.0
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@5.0.0
microsoft.netcore.platforms@7.0.4
microsoft.netcore.targets@5.0.0
microsoft.testplatform.objectmodel@17.12.0
microsoft.testplatform.testhost@17.12.0
microsoft.testplatform.translationlayer@17.13.0
microsoft.visualstudio.solutionpersistence@1.0.28
microsoft.visualstudio.threading.analyzers@17.10.48
microsoft.visualstudio.threading.analyzers@17.12.19
microsoft.visualstudio.threading@17.10.48
microsoft.visualstudio.threading@17.12.19
microsoft.visualstudio.validation@17.8.8
microsoft.win32.registry@5.0.0
mono.cecil@0.11.6
nerdbank.streams@2.11.74
nerdbank.streams@2.11.79
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@13.0.3
nuget.frameworks@6.12.1
opentelemetry.api.providerbuilderextensions@1.10.0
opentelemetry.api@1.10.0
opentelemetry.exporter.opentelemetryprotocol@1.10.0
opentelemetry.instrumentation.runtime@1.9.0
opentelemetry@1.10.0
paket@10.0.0-alpha011
perfolizer@0.3.17
ply@0.3.1
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.debian.9-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.fedora.27-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.fedora.28-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.native.system.net.http@4.3.1
runtime.native.system.security.cryptography.apple@4.3.1
runtime.native.system.security.cryptography.openssl@4.3.3
runtime.native.system@4.3.1
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.opensuse.42.3-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple@4.3.1
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.3
runtime.ubuntu.18.04-x64.runtime.native.system.security.cryptography.openssl@4.3.3
semanticversioning@2.0.2
serilog.extensions.logging@8.0.0
serilog.sinks.async@2.1.0
serilog.sinks.console@6.0.0
serilog.sinks.file@6.0.0
serilog@3.1.1
serilog@4.1.0
streamjsonrpc@2.16.36
streamjsonrpc@2.20.20
streamjsonrpc@2.8.28
system.buffers@4.6.0
system.codedom@8.0.0
system.collections.concurrent@4.3.0
system.collections.immutable@9.0.1
system.collections@4.3.0
system.commandline@2.0.0
system.componentmodel.annotations@5.0.0
system.composition.attributedmodel@9.0.1
system.composition.convention@9.0.1
system.composition.hosting@9.0.1
system.composition.runtime@9.0.1
system.composition.typedparts@9.0.1
system.composition@8.0.0
system.composition@9.0.1
system.configuration.configurationmanager@8.0.0
system.configuration.configurationmanager@9.0.1
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@9.0.0
system.diagnostics.diagnosticsource@9.0.1
system.diagnostics.eventlog@9.0.1
system.diagnostics.tracing@4.3.0
system.formats.asn1@9.0.1
system.formats.nrbf@9.0.1
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io.pipelines@8.0.0
system.io.pipelines@9.0.1
system.io@4.3.0
system.linq@4.3.0
system.management@8.0.0
system.memory@4.6.0
system.net.http@4.3.4
system.net.primitives@4.3.1
system.numerics.vectors@4.6.0
system.reactive@5.0.0
system.reflection.emit.ilgeneration@4.7.0
system.reflection.emit.lightweight@4.6.0
system.reflection.emit.lightweight@4.7.0
system.reflection.emit@4.7.0
system.reflection.metadata@1.6.0
system.reflection.metadata@6.0.0
system.reflection.metadata@8.0.0
system.reflection.metadata@9.0.0
system.reflection.metadata@9.0.1
system.reflection.metadataloadcontext@8.0.0
system.reflection.metadataloadcontext@9.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.7.0
system.reflection@4.3.0
system.resources.extensions@9.0.1
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@6.1.0
system.runtime.extensions@4.3.1
system.runtime.handles@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.3.1
system.security.accesscontrol@5.0.0
system.security.accesscontrol@6.0.1
system.security.cryptography.algorithms@4.3.1
system.security.cryptography.cng@5.0.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@5.0.0
system.security.cryptography.pkcs@9.0.1
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@9.0.1
system.security.cryptography.x509certificates@4.3.2
system.security.cryptography.xml@9.0.1
system.security.principal.windows@5.0.0
system.text.encoding.codepages@7.0.0
system.text.encoding.codepages@9.0.1
system.text.encoding@4.3.0
system.text.encodings.web@9.0.1
system.text.json@8.0.5
system.text.json@9.0.1
system.text.regularexpressions@4.3.1
system.threading.channels@7.0.0
system.threading.channels@9.0.1
system.threading.tasks.dataflow@9.0.1
system.threading.tasks.extensions@4.6.0
system.threading.tasks@4.3.0
system.threading@4.3.0
telplin@0.9.6
yolodev.expecto.testsdk@0.14.3
"

inherit check-reqs dotnet-pkg

DESCRIPTION="F# language server using the Language Server Protocol"
HOMEPAGE="https://github.com/ionide/FsAutoComplete/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ionide/${APP_PN}"
else
	SRC_URI="https://github.com/ionide/${APP_PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${APP_PN}-${PV}"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"

CHECKREQS_DISK_BUILD="2G"
PATCHES=( "${FILESDIR}/${PN}-0.73.0-paket-dependencies.patch" )

DOTNET_PKG_PROJECTS=( src/FsAutoComplete )
DOTNET_PKG_BAD_PROJECTS=(
	test/FsAutoComplete.Tests.Lsp
	test/FsAutoComplete.Tests.TestExplorer
)

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
	dotnet-pkg_src_prepare

	rm paket.lock || die
	sed -i paket.dependencies -e "s|@NUGET_PACKAGES@|${NUGET_PACKAGES}|g" || die
}

src_configure() {
	dotnet-pkg-base_restore_tools
	edotnet paket install

	dotnet-pkg_src_configure
}
