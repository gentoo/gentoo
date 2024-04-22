# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=FsAutoComplete

DOTNET_PKG_COMPAT=8.0
NUGETS="
altcover@8.3.838
benchmarkdotnet.annotations@0.13.5
benchmarkdotnet@0.13.5
blackfox.vswhere@1.1.0
cliwrap@3.4.4
commandlineparser@2.4.3
communitytoolkit.highperformance@7.0.1
destructurama.fsharp@1.2.0
diffplex@1.7.1
dotnet-reportgenerator-globaltool@5.0.2
dotnet.reproduciblebuilds@1.1.1
expecto.diff@9.0.4
expecto@10.1.0
fake.api.github@5.20.4
fake.core.commandlineparsing@5.23.1
fake.core.context@5.23.1
fake.core.environment@5.23.1
fake.core.fakevar@5.23.1
fake.core.process@5.23.1
fake.core.releasenotes@5.23.1
fake.core.semver@5.23.1
fake.core.string@5.23.1
fake.core.target@5.23.1
fake.core.tasks@5.23.1
fake.core.trace@5.23.1
fake.core.userinput@5.23.1
fake.core.xml@5.23.1
fake.dotnet.assemblyinfofile@5.23.1
fake.dotnet.cli@5.23.1
fake.dotnet.msbuild@5.23.1
fake.dotnet.nuget@5.23.1
fake.dotnet.paket@5.23.1
fake.io.filesystem@5.23.1
fake.io.zip@5.23.1
fake.net.http@5.23.1
fake.tools.git@5.23.1
fantomas.client@0.9.0
fantomas.core@6.2.0
fantomas.fcs@6.2.0
fantomas@6.2.3
fparsec@1.1.1
fsharp-analyzers@0.23.0
fsharp.analyzers.build@0.3.0
fsharp.analyzers.sdk@0.23.0
fsharp.compiler.service@43.8.100
fsharp.control.asyncseq@3.2.1
fsharp.control.reactive@5.0.5
fsharp.core@5.0.1
fsharp.core@6.0.5
fsharp.core@8.0.100
fsharp.data.adaptive@1.2.13
fsharp.formatting@14.0.1
fsharp.umx@1.1.0
fsharplint.core@0.21.2
fsharpx.async@1.14.1
fstoolkit.errorhandling.taskresult@4.4.0
fstoolkit.errorhandling@4.4.0
gee.external.capstone@2.3.0
githubactionstestlogger@2.0.1
google.protobuf@3.22.0
grpc.core.api@2.51.0
grpc.core@2.46.6
grpc.net.client@2.51.0
grpc.net.common@2.51.0
grpc@2.46.6
humanizer.core@2.14.1
iced@1.17.0
icedtasks@0.9.2
icsharpcode.decompiler@7.2.1.6856
ionide.analyzers@0.7.0
ionide.keepachangelog.tasks@0.1.8
ionide.languageserverprotocol@0.4.20
ionide.projinfo.fcs@0.62.0
ionide.projinfo.projectsystem@0.62.0
ionide.projinfo.sln@0.62.0
ionide.projinfo@0.62.0
linkdotnet.stringbuilder@1.18.0
mcmaster.netcore.plugins@1.4.0
messagepack.annotations@2.5.108
messagepack@2.5.108
microsoft.bcl.asyncinterfaces@7.0.0
microsoft.bcl.hashcode@1.1.0
microsoft.build.framework@17.6.3
microsoft.build.locator@1.5.3
microsoft.build.tasks.core@17.4.0
microsoft.build.tasks.git@1.1.1
microsoft.build.utilities.core@17.4.0
microsoft.build.utilities.core@17.6.3
microsoft.build@17.2.0
microsoft.build@17.4.0
microsoft.codeanalysis.analyzers@3.3.3
microsoft.codeanalysis.common@4.5.0
microsoft.codeanalysis.csharp.workspaces@4.5.0
microsoft.codeanalysis.csharp@4.5.0
microsoft.codeanalysis.visualbasic.workspaces@4.5.0
microsoft.codeanalysis.visualbasic@4.5.0
microsoft.codeanalysis.workspaces.common@4.5.0
microsoft.codeanalysis@4.5.0
microsoft.codecoverage@17.4.1
microsoft.diagnostics.netcore.client@0.2.251802
microsoft.diagnostics.runtime@2.2.332302
microsoft.diagnostics.tracing.traceevent@3.0.2
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.caching.abstractions@6.0.0
microsoft.extensions.caching.memory@6.0.1
microsoft.extensions.configuration.abstractions@6.0.0
microsoft.extensions.configuration.binder@6.0.0
microsoft.extensions.configuration@6.0.1
microsoft.extensions.dependencyinjection.abstractions@6.0.0
microsoft.extensions.dependencyinjection@6.0.1
microsoft.extensions.dependencymodel@6.0.0
microsoft.extensions.logging.abstractions@6.0.2
microsoft.extensions.logging.configuration@6.0.0
microsoft.extensions.logging@6.0.0
microsoft.extensions.options.configurationextensions@6.0.0
microsoft.extensions.options@6.0.0
microsoft.extensions.primitives@6.0.0
microsoft.net.stringtools@17.4.0
microsoft.net.stringtools@17.6.3
microsoft.net.test.sdk@17.4.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.platforms@7.0.4
microsoft.netcore.targets@1.1.3
microsoft.netcore.targets@5.0.0
microsoft.netframework.referenceassemblies.net461@1.0.3
microsoft.netframework.referenceassemblies@1.0.3
microsoft.sourcelink.azurerepos.git@1.1.1
microsoft.sourcelink.bitbucket.git@1.1.1
microsoft.sourcelink.common@1.1.1
microsoft.sourcelink.github@1.1.1
microsoft.sourcelink.gitlab@1.1.1
microsoft.testplatform.objectmodel@17.4.1
microsoft.testplatform.testhost@17.4.1
microsoft.visualstudio.setup.configuration.interop@3.6.2115
microsoft.visualstudio.threading.analyzers@17.6.40
microsoft.visualstudio.threading@17.6.40
microsoft.visualstudio.validation@17.6.11
microsoft.win32.registry@5.0.0
microsoft.win32.systemevents@7.0.0
mono.cecil@0.11.4
mono.posix.netstandard@1.0.0
msbuild.structuredlogger@2.1.844
nerdbank.streams@2.10.66
netstandard.library@2.0.3
newtonsoft.json@13.0.1
newtonsoft.json@13.0.2
nuget.common@6.7.0
nuget.configuration@6.7.0
nuget.frameworks@6.3.0
nuget.frameworks@6.7.0
nuget.packaging@6.7.0
nuget.protocol@6.7.0
nuget.versioning@6.7.0
octokit@0.48.0
opentelemetry.api@1.3.2
opentelemetry.exporter.opentelemetryprotocol@1.3.2
opentelemetry@1.3.2
paket@8.0.0-alpha002
perfolizer@0.2.1
runtime.debian.8-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.2
runtime.fedora.23-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.2
runtime.fedora.24-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.2
runtime.native.System.Security.Cryptography.OpenSsl@4.3.2
runtime.native.system.net.http@4.3.0
runtime.native.system.security.cryptography.apple@4.3.0
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.2
runtime.opensuse.42.1-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.2
runtime.osx.10.10-x64.runtime.native.System.Security.Cryptography.Apple@4.3.0
runtime.osx.10.10-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.2
runtime.rhel.7-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.2
runtime.ubuntu.14.04-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.2
runtime.ubuntu.16.04-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.2
runtime.ubuntu.16.10-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.2
semanticversioning@2.0.2
serilog.sinks.async@1.5.0
serilog.sinks.console@4.0.1
serilog.sinks.file@5.0.0
serilog@2.11.0
streamjsonrpc@2.16.36
system.buffers@4.5.1
system.codedom@6.0.0
system.collections.concurrent@4.3.0
system.collections.immutable@7.0.0
system.collections@4.3.0
system.commandline@2.0.0-beta4.22272.1
system.componentmodel.annotations@5.0.0
system.composition.attributedmodel@6.0.0
system.composition.convention@6.0.0
system.composition.hosting@6.0.0
system.composition.runtime@6.0.0
system.composition.typedparts@6.0.0
system.composition@6.0.0
system.configuration.configurationmanager@6.0.0
system.configuration.configurationmanager@7.0.0
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@7.0.2
system.diagnostics.eventlog@7.0.0
system.diagnostics.tracing@4.3.0
system.drawing.common@7.0.0
system.formats.asn1@6.0.0
system.formats.asn1@7.0.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io.pipelines@7.0.0
system.io@4.3.0
system.linq@4.3.0
system.management@6.0.0
system.memory@4.5.5
system.net.http@4.3.4
system.net.primitives@4.3.0
system.numerics.vectors@4.5.0
system.reactive@5.0.0
system.reflection.emit.ilgeneration@4.7.0
system.reflection.emit.lightweight@4.7.0
system.reflection.emit@4.7.0
system.reflection.metadata@6.0.1
system.reflection.metadata@7.0.0
system.reflection.metadataloadcontext@6.0.0
system.reflection.primitives@4.3.0
system.reflection@4.3.0
system.resources.extensions@6.0.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.3.1
system.runtime.handles@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.3.1
system.security.accesscontrol@5.0.0
system.security.accesscontrol@6.0.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@5.0.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.pkcs@6.0.4
system.security.cryptography.pkcs@7.0.3
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@6.0.0
system.security.cryptography.protecteddata@7.0.1
system.security.cryptography.x509certificates@4.3.0
system.security.cryptography.xml@6.0.1
system.security.permissions@7.0.0
system.security.principal.windows@5.0.0
system.text.encoding.codepages@6.0.0
system.text.encoding.codepages@7.0.0
system.text.encoding@4.3.0
system.text.encodings.web@6.0.0
system.text.encodings.web@7.0.0
system.text.json@6.0.5
system.text.json@7.0.3
system.text.regularexpressions@4.3.1
system.threading.channels@6.0.0
system.threading.tasks.dataflow@6.0.0
system.threading.tasks.dataflow@7.0.0
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.3.0
system.threading@4.3.0
system.windows.extensions@7.0.0
yolodev.expecto.testsdk@0.14.2
"

inherit check-reqs dotnet-pkg

DESCRIPTION="F# language server using the Language Server Protocol"
HOMEPAGE="https://github.com/fsharp/FsAutoComplete/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fsharp/${MY_PN}.git"
else
	SRC_URI="https://github.com/fsharp/${MY_PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0"
SLOT="0"
RESTRICT="test"                               # TODO: Disable 19 failing tests.

CHECKREQS_DISK_BUILD="2G"
DOTNET_PKG_PROJECTS=( src/FsAutoComplete/FsAutoComplete.fsproj )
PATCHES=(
	"${FILESDIR}/${PN}-0.68.0-paket-dependencies.patch"
	"${FILESDIR}/${PN}-0.69.0-net8.0-only.patch"
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
