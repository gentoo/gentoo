# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_beta/-beta-}"

DOTNET_PKG_COMPAT=7.0
NUGETS="
benchmarkdotnet.annotations@0.13.7
benchmarkdotnet@0.13.7
commandlineparser@2.9.1
esprima@3.0.0-rc-04
flurl.http.signed@3.2.4
flurl.signed@3.0.6
gee.external.capstone@2.3.0
githubactionstestlogger@2.3.3
iced@1.17.0
jurassic@3.2.6
microsoft.bcl.asyncinterfaces@1.1.0
microsoft.build.tasks.git@1.1.1
microsoft.codeanalysis.analyzers@3.3.3
microsoft.codeanalysis.common@4.1.0
microsoft.codeanalysis.csharp@4.1.0
microsoft.codecoverage@17.7.2
microsoft.diagnostics.netcore.client@0.2.251802
microsoft.diagnostics.runtime@2.2.332302
microsoft.diagnostics.tracing.traceevent@3.0.2
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.configuration.abstractions@2.1.1
microsoft.extensions.configuration.binder@2.1.1
microsoft.extensions.configuration@2.1.1
microsoft.extensions.dependencyinjection.abstractions@2.1.1
microsoft.extensions.dependencyinjection.abstractions@7.0.0
microsoft.extensions.dependencyinjection@7.0.0
microsoft.extensions.logging.abstractions@2.1.1
microsoft.extensions.logging@2.1.1
microsoft.extensions.options@2.1.1
microsoft.extensions.primitives@2.1.1
microsoft.net.test.sdk@17.7.2
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.platforms@2.1.2
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.1.0
microsoft.netcore.targets@1.1.3
microsoft.sourcelink.common@1.1.1
microsoft.sourcelink.github@1.1.1
microsoft.testplatform.objectmodel@17.7.1
microsoft.testplatform.objectmodel@17.7.2
microsoft.testplatform.testhost@17.7.2
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@5.0.0
mongodb.bson.signed@2.19.0
netstandard.library@1.6.1
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@13.0.1
newtonsoft.json@13.0.3
nil.js@2.5.1665
nodatime@3.1.9
nuget.frameworks@6.5.0
nullable@1.3.1
nunit@3.13.3
nunit3testadapter@4.5.0
perfolizer@0.2.1
polysharp@1.13.2
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
runtime.unix.microsoft.win32.primitives@4.3.0
runtime.unix.system.console@4.3.0
runtime.unix.system.diagnostics.debug@4.3.0
runtime.unix.system.io.filesystem@4.3.0
runtime.unix.system.net.primitives@4.3.0
runtime.unix.system.net.sockets@4.3.0
runtime.unix.system.private.uri@4.3.0
runtime.unix.system.runtime.extensions@4.3.0
sharpziplib@1.4.0
system.appcontext@4.3.0
system.buffers@4.3.0
system.buffers@4.5.1
system.codedom@5.0.0
system.collections.concurrent@4.3.0
system.collections.immutable@5.0.0
system.collections@4.3.0
system.console@4.3.0
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.tools@4.3.0
system.diagnostics.tracing@4.3.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.compression.zipfile@4.3.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io@4.3.0
system.linq.expressions@4.3.0
system.linq@4.3.0
system.management@5.0.0
system.memory@4.5.1
system.memory@4.5.3
system.memory@4.5.4
system.net.http@4.3.0
system.net.nameresolution@4.3.0
system.net.primitives@4.3.0
system.net.sockets@4.3.0
system.numerics.vectors@4.4.0
system.numerics.vectors@4.5.0
system.objectmodel@4.3.0
system.private.uri@4.3.0
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.3.0
system.reflection.emit.lightweight@4.7.0
system.reflection.emit@4.3.0
system.reflection.emit@4.7.0
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.metadata@5.0.0
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.3.0
system.reflection@4.3.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@4.5.2
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@4.7.1
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.3.0
system.runtime@4.3.1
system.security.accesscontrol@5.0.0
system.security.claims@4.3.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.x509certificates@4.3.0
system.security.principal.windows@4.3.0
system.security.principal.windows@5.0.0
system.security.principal@4.3.0
system.text.encoding.codepages@4.5.1
system.text.encoding.extensions@4.3.0
system.text.encoding@4.3.0
system.text.encodings.web@6.0.0
system.text.json@6.0.5
system.text.regularexpressions@4.3.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.3.0
system.threading.threadpool@4.3.0
system.threading.timer@4.3.0
system.threading@4.3.0
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.3.0
test262harness@0.0.22
xunit.abstractions@2.0.3
xunit.analyzers@1.2.0
xunit.assert@2.5.0
xunit.core@2.5.0
xunit.extensibility.core@2.5.0
xunit.extensibility.execution@2.5.0
xunit.runner.visualstudio@2.5.0
xunit@2.5.0
yamldotnet@12.0.1
yantrajs.core@1.2.179
yantrajs.expressioncompiler@1.2.179
zio@0.15.0
zstring@2.4.4
"

inherit check-reqs dotnet-pkg

DESCRIPTION="Javascript Interpreter for .NET"
HOMEPAGE="https://github.com/sebastienros/jint/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sebastienros/${PN}.git"
else
	SRC_URI="https://github.com/sebastienros/${PN}/archive/v${MY_PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="BSD-2"
SLOT="0"

CHECKREQS_DISK_BUILD="2G"
DOTNET_PKG_RESTORE_EXTRA_ARGS=(
	-p:TargetFramework="net${DOTNET_PKG_COMPAT}"
	-p:TargetFrameworks="net${DOTNET_PKG_COMPAT}"
)
DOTNET_PKG_BUILD_EXTRA_ARGS=( "${DOTNET_PKG_RESTORE_EXTRA_ARGS[@]}" )
DOTNET_PKG_TEST_EXTRA_ARGS=( "${DOTNET_PKG_RESTORE_EXTRA_ARGS[@]}" )
DOTNET_PKG_PROJECTS=( Jint.Repl/Jint.Repl.csproj )
DOTNET_PKG_BAD_PROJECTS=(
	Jint.Benchmark/Jint.Benchmark.csproj
	Jint.Tests.Test262/Jint.Tests.Test262.csproj
	Jint.Tests/Jint.Tests.csproj
)

pkg_setup() {
	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/Jint.Repl" "${PN}"

	einstalldocs
}
