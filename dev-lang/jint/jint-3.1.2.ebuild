# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGETS="
benchmarkdotnet.annotations@0.13.12
benchmarkdotnet@0.13.12
commandlineparser@2.9.1
esprima@3.0.5
fluentassertions@6.12.0
flurl.http.signed@3.2.4
flurl.signed@3.0.6
gee.external.capstone@2.3.0
githubactionstestlogger@2.3.3
iced@1.17.0
jurassic@3.2.7
meziantou.analyzer@2.0.141
microsoft.bcl.asyncinterfaces@1.1.0
microsoft.bcl.timeprovider@8.0.0
microsoft.build.tasks.git@8.0.0
microsoft.codeanalysis.analyzers@3.3.3
microsoft.codeanalysis.common@4.1.0
microsoft.codeanalysis.csharp@4.1.0
microsoft.codecoverage@17.8.0
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
microsoft.extensions.timeprovider.testing@8.0.0
microsoft.net.test.sdk@17.8.0
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.platforms@2.1.2
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.1.0
microsoft.netcore.targets@1.1.3
microsoft.netframework.referenceassemblies.net462@1.0.3
microsoft.netframework.referenceassemblies@1.0.3
microsoft.sourcelink.common@8.0.0
microsoft.sourcelink.github@8.0.0
microsoft.testplatform.objectmodel@17.7.1
microsoft.testplatform.objectmodel@17.8.0
microsoft.testplatform.testhost@17.8.0
microsoft.win32.registry@5.0.0
mongodb.bson.signed@2.19.0
netstandard.library@2.0.3
newtonsoft.json@12.0.2
newtonsoft.json@13.0.1
nil.js@2.5.1677
nodatime@3.1.9
nuget.frameworks@6.5.0
nunit3testadapter@4.5.0
nunit@4.0.1
perfolizer@0.2.1
polysharp@1.14.1
runtime.any.system.io@4.3.0
runtime.any.system.reflection.primitives@4.3.0
runtime.any.system.reflection@4.3.0
runtime.any.system.runtime@4.3.0
runtime.any.system.text.encoding@4.3.0
runtime.any.system.threading.tasks@4.3.0
runtime.native.system@4.3.0
runtime.unix.system.private.uri@4.3.0
sharpziplib@1.4.2
system.buffers@4.5.1
system.codedom@5.0.0
system.collections.immutable@1.5.0
system.collections.immutable@5.0.0
system.configuration.configurationmanager@4.4.0
system.io@4.3.0
system.management@5.0.0
system.memory@4.5.1
system.memory@4.5.3
system.memory@4.5.4
system.memory@4.5.5
system.numerics.vectors@4.4.0
system.numerics.vectors@4.5.0
system.private.uri@4.3.0
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.3.0
system.reflection.emit.lightweight@4.7.0
system.reflection.emit@4.7.0
system.reflection.metadata@1.6.0
system.reflection.metadata@5.0.0
system.reflection.primitives@4.3.0
system.reflection@4.3.0
system.runtime.compilerservices.unsafe@4.5.2
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@4.7.1
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime@4.3.0
system.runtime@4.3.1
system.security.accesscontrol@5.0.0
system.security.cryptography.protecteddata@4.4.0
system.security.principal.windows@5.0.0
system.text.encoding.codepages@4.5.1
system.text.encoding@4.3.0
system.text.encodings.web@6.0.0
system.text.encodings.web@8.0.0
system.text.json@6.0.5
system.text.json@8.0.3
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.3.0
test262harness@1.0.0
xunit.abstractions@2.0.3
xunit.analyzers@1.11.0
xunit.assert@2.7.0
xunit.core@2.7.0
xunit.extensibility.core@2.7.0
xunit.extensibility.execution@2.7.0
xunit.runner.visualstudio@2.5.7
xunit@2.7.0
yamldotnet@15.1.1
yantrajs.core@1.2.206
yantrajs.expressioncompiler@1.2.206
zio@0.17.0
zstring@2.5.1
"

inherit check-reqs dotnet-pkg

DESCRIPTION="Javascript Interpreter for .NET"
HOMEPAGE="https://github.com/sebastienros/jint/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sebastienros/${PN}.git"
else
	SRC_URI="https://github.com/sebastienros/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"

CHECKREQS_DISK_BUILD="2G"
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
