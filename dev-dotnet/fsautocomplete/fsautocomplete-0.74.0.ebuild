# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

REAL_PN="FsAutoComplete"

DOTNET_PKG_COMPAT="8.0"
NUGETS="
System.Security.Cryptography.OpenSsl@5.0.0
altcover@8.9.3
benchmarkdotnet.annotations@0.14.0
benchmarkdotnet@0.14.0
cliwrap@3.6.6
commandlineparser@2.9.1
communitytoolkit.highperformance@8.2.2
destructurama.fsharp@2.0.0
diffplex@1.7.2
dotnet-reportgenerator-globaltool@5.3.8
dotnet.reproduciblebuilds@1.2.4
expecto.diff@10.2.1
expecto@10.2.1
fantomas.client@0.9.0
fantomas@6.3.11
fparsec@1.1.1
fsharp-analyzers@0.27.0
fsharp.analyzers.build@0.3.0
fsharp.analyzers.sdk@0.27.0
fsharp.compiler.service@43.8.400
fsharp.control.asyncseq@3.2.1
fsharp.control.reactive@5.0.5
fsharp.core@5.0.1
fsharp.core@8.0.400
fsharp.data.adaptive@1.2.15
fsharp.formatting@14.0.1
fsharp.umx@1.1.0
fsharplint.core@0.23.0
fsharpx.async@1.14.1
fstoolkit.errorhandling.taskresult@4.16.0
fstoolkit.errorhandling@4.16.0
gee.external.capstone@2.3.0
githubactionstestlogger@2.4.1
google.protobuf@3.27.3
grpc.core.api@2.65.0
grpc.core@2.46.6
grpc.net.client@2.65.0
grpc.net.common@2.65.0
grpc@2.46.6
humanizer.core@2.14.1
iced@1.21.0
icedtasks@0.11.7
icsharpcode.decompiler@8.2.0.7535
ionide.analyzers@0.12.0
ionide.keepachangelog.tasks@0.1.8
ionide.languageserverprotocol@0.6.0
ionide.projinfo.fcs@0.66.0
ionide.projinfo.projectsystem@0.66.0
ionide.projinfo.sln@0.66.0
ionide.projinfo@0.66.0
linkdotnet.stringbuilder@1.18.0
mcmaster.netcore.plugins@1.4.0
messagepack.annotations@2.5.172
messagepack@2.5.172
microsoft.bcl.asyncinterfaces@8.0.0
microsoft.bcl.hashcode@1.1.1
microsoft.build.framework@17.11.4
microsoft.build.locator@1.7.8
microsoft.build.tasks.core@17.11.4
microsoft.build.utilities.core@17.11.4
microsoft.build@17.11.4
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.common@4.11.0
microsoft.codeanalysis.csharp.workspaces@4.11.0
microsoft.codeanalysis.csharp@4.11.0
microsoft.codeanalysis.visualbasic.workspaces@4.11.0
microsoft.codeanalysis.visualbasic@4.11.0
microsoft.codeanalysis.workspaces.common@4.11.0
microsoft.codeanalysis@4.11.0
microsoft.codecoverage@17.10.0
microsoft.diagnostics.netcore.client@0.2.532401
microsoft.diagnostics.runtime@3.1.512801
microsoft.diagnostics.tracing.traceevent@3.1.13
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.caching.abstractions@8.0.0
microsoft.extensions.caching.memory@8.0.0
microsoft.extensions.configuration.abstractions@8.0.0
microsoft.extensions.configuration.binder@8.0.2
microsoft.extensions.configuration@8.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.1
microsoft.extensions.dependencyinjection@8.0.0
microsoft.extensions.dependencymodel@8.0.1
microsoft.extensions.diagnostics.abstractions@8.0.0
microsoft.extensions.logging.abstractions@8.0.1
microsoft.extensions.logging.configuration@8.0.0
microsoft.extensions.logging@8.0.0
microsoft.extensions.options.configurationextensions@8.0.0
microsoft.extensions.options@8.0.2
microsoft.extensions.primitives@8.0.0
microsoft.io.redist@6.0.0
microsoft.net.stringtools@17.11.4
microsoft.net.test.sdk@17.10.0
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@5.0.0
microsoft.netcore.platforms@7.0.4
microsoft.netcore.targets@5.0.0
microsoft.testplatform.objectmodel@17.10.0
microsoft.testplatform.testhost@17.10.0
microsoft.visualstudio.threading.analyzers@17.11.20
microsoft.visualstudio.threading@17.11.20
microsoft.visualstudio.validation@17.8.8
microsoft.win32.registry@5.0.0
mono.cecil@0.11.5
nerdbank.streams@2.11.74
netstandard.library@2.0.3
newtonsoft.json@13.0.3
nuget.frameworks@6.11.0
opentelemetry.api.providerbuilderextensions@1.9.0
opentelemetry.api@1.9.0
opentelemetry.exporter.opentelemetryprotocol@1.9.0
opentelemetry.instrumentation.runtime@1.9.0
opentelemetry@1.9.0
paket@8.0.3
perfolizer@0.3.17
runtime.debian.8-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.debian.9-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.fedora.23-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.fedora.24-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.fedora.27-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.fedora.28-x64.runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.native.System.Security.Cryptography.Apple@4.3.1
runtime.native.System.Security.Cryptography.OpenSsl@4.3.3
runtime.native.system.net.http@4.3.1
runtime.native.system@4.3.1
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
semanticversioning@2.0.2
serilog.sinks.async@2.0.0
serilog.sinks.console@6.0.0
serilog.sinks.file@6.0.0
serilog@4.0.1
streamjsonrpc@2.19.27
system.buffers@4.5.1
system.codedom@8.0.0
system.collections.concurrent@4.3.0
system.collections.immutable@8.0.0
system.collections@4.3.0
system.commandline@2.0.0-beta4.22272.1
system.componentmodel.annotations@5.0.0
system.composition.attributedmodel@8.0.0
system.composition.convention@8.0.0
system.composition.hosting@8.0.0
system.composition.runtime@8.0.0
system.composition.typedparts@8.0.0
system.composition@8.0.0
system.configuration.configurationmanager@8.0.0
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@8.0.1
system.diagnostics.eventlog@8.0.0
system.diagnostics.tracing@4.3.0
system.formats.asn1@8.0.1
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io.pipelines@8.0.0
system.io@4.3.0
system.linq@4.3.0
system.management@8.0.0
system.memory@4.5.5
system.net.http@4.3.4
system.net.primitives@4.3.1
system.numerics.vectors@4.5.0
system.reactive@5.0.0
system.reflection.emit.ilgeneration@4.7.0
system.reflection.emit.lightweight@4.7.0
system.reflection.emit@4.7.0
system.reflection.metadata@8.0.0
system.reflection.metadataloadcontext@8.0.0
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.7.0
system.reflection@4.3.0
system.resources.extensions@8.0.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@6.0.0
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
system.security.cryptography.pkcs@8.0.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@8.0.0
system.security.cryptography.x509certificates@4.3.2
system.security.cryptography.xml@8.0.1
system.security.principal.windows@5.0.0
system.text.encoding.codepages@8.0.0
system.text.encoding@4.3.0
system.text.encodings.web@8.0.0
system.text.json@8.0.3
system.text.json@8.0.4
system.text.regularexpressions@4.3.1
system.threading.channels@8.0.0
system.threading.tasks.dataflow@8.0.1
system.threading.tasks.extensions@4.5.4
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

	EGIT_REPO_URI="https://github.com/ionide/${REAL_PN}.git"
else
	SRC_URI="https://github.com/ionide/${REAL_PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${REAL_PN}-${PV}"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
RESTRICT="test"                        # Has >=19 failing tests (uses expecto).

CHECKREQS_DISK_BUILD="2G"
DOTNET_PKG_PROJECTS=( src/FsAutoComplete/FsAutoComplete.fsproj )
PATCHES=( "${FILESDIR}/${PN}-0.73.0-paket-dependencies.patch" )

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
