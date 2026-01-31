# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
acornima.extras@1.2.0
acornima@1.2.0
benchmarkdotnet.annotations@0.15.8
benchmarkdotnet@0.15.8
commandlineparser@2.9.1
fluentassertions@7.2.0
flurl.http.signed@4.0.2
flurl.signed@4.0.0
gee.external.capstone@2.3.0
githubactionstestlogger@3.0.1
iced@1.21.0
jurassic@3.2.9
meziantou.analyzer@2.0.267
microsoft.applicationinsights@2.23.0
microsoft.bcl.asyncinterfaces@1.1.0
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.codeanalysis.analyzers@3.11.0
microsoft.codeanalysis.common@4.14.0
microsoft.codeanalysis.csharp@4.14.0
microsoft.codecoverage@18.0.1
microsoft.diagnostics.netcore.client@0.2.410101
microsoft.diagnostics.netcore.client@0.2.510501
microsoft.diagnostics.runtime@3.1.512801
microsoft.diagnostics.tracing.traceevent@3.1.21
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.dependencyinjection.abstractions@10.0.1
microsoft.extensions.dependencyinjection.abstractions@6.0.0
microsoft.extensions.dependencyinjection@10.0.1
microsoft.extensions.logging.abstractions@6.0.0
microsoft.extensions.logging@2.1.1
microsoft.extensions.logging@6.0.0
microsoft.extensions.options@6.0.0
microsoft.extensions.primitives@6.0.0
microsoft.extensions.timeprovider.testing@10.1.0
microsoft.net.test.sdk@18.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netframework.referenceassemblies.net462@1.0.3
microsoft.netframework.referenceassemblies@1.0.3
microsoft.testing.extensions.telemetry@2.0.2
microsoft.testing.extensions.trxreport.abstractions@2.0.2
microsoft.testing.extensions.vstestbridge@2.0.2
microsoft.testing.platform.msbuild@2.0.2
microsoft.testing.platform@2.0.2
microsoft.testplatform.adapterutilities@18.0.1
microsoft.testplatform.objectmodel@18.0.1
microsoft.testplatform.testhost@18.0.1
microsoft.win32.registry@5.0.0
microsoft.win32.systemevents@6.0.0
mongodb.bson.signed@2.19.0
netstandard.library.ref@2.1.0
netstandard.library@2.0.3
newtonsoft.json@13.0.4
nil.js@2.6.1712
nodatime@3.3.0
nunit3testadapter@6.0.1
nunit@4.4.0
perfolizer@0.6.1
polysharp@1.15.0
pragmastat@3.2.4
sharpziplib@1.4.2
sourcemaps@0.3.0
system.buffers@4.5.1
system.codedom@9.0.5
system.configuration.configurationmanager@6.0.0
system.drawing.common@6.0.0
system.management@9.0.5
system.memory@4.5.5
system.numerics.vectors@4.4.0
system.numerics.vectors@4.5.0
system.reflection.typeextensions@4.7.0
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@6.0.0
system.security.cryptography.protecteddata@6.0.0
system.security.permissions@6.0.0
system.windows.extensions@6.0.0
test262harness@1.0.3
xunit.analyzers@1.26.0
xunit.runner.visualstudio@3.1.5
xunit.v3.assert@3.2.1
xunit.v3.common@3.2.1
xunit.v3.core.mtp-off@3.2.1
xunit.v3.extensibility.core@3.2.1
xunit.v3.mtp-off@3.2.1
xunit.v3.runner.common@3.2.1
xunit.v3.runner.inproc.console@3.2.1
yamldotnet@16.3.0
yantrajs.core@1.2.299
yantrajs.expressioncompiler@1.2.299
zio@0.21.2
zstring@2.6.0
"

inherit check-reqs dotnet-pkg

DESCRIPTION="Javascript Interpreter for .NET"
HOMEPAGE="https://github.com/sebastienros/jint/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sebastienros/${PN}"
else
	SRC_URI="https://github.com/sebastienros/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

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

src_prepare() {
	dotnet-pkg_src_prepare

	# Those files do not exist on musl. See bug https://bugs.gentoo.org/935450
	rm Jint.Tests.PublicInterface/TimeSystemTests.cs || die
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/Jint.Repl" "${PN}"

	einstalldocs
}
