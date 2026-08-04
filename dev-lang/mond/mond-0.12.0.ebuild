# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
benchmarkdotnet.annotations@0.15.8
benchmarkdotnet@0.15.8
commandlineparser@2.9.1
fleck@1.2.0
gee.external.capstone@2.3.0
iced@1.21.0
microsoft.applicationinsights@2.23.0
microsoft.aspnetcore.app.internal.assets@10.0.7
microsoft.aspnetcore.authorization@10.0.10
microsoft.aspnetcore.components.analyzers@10.0.10
microsoft.aspnetcore.components.forms@10.0.10
microsoft.aspnetcore.components.web@10.0.10
microsoft.aspnetcore.components.webassembly.devserver@10.0.10
microsoft.aspnetcore.components.webassembly@10.0.10
microsoft.aspnetcore.components@10.0.10
microsoft.aspnetcore.metadata@10.0.10
microsoft.bcl.asyncinterfaces@1.1.0
microsoft.build.tasks.git@10.0.301
microsoft.codeanalysis.analyzers@3.11.0
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.common@4.14.0
microsoft.codeanalysis.common@4.3.0
microsoft.codeanalysis.csharp@4.14.0
microsoft.codeanalysis.csharp@4.3.0
microsoft.codecoverage@18.8.1
microsoft.diagnostics.netcore.client@0.2.410101
microsoft.diagnostics.netcore.client@0.2.510501
microsoft.diagnostics.runtime@3.1.512801
microsoft.diagnostics.tracing.traceevent@3.1.21
microsoft.dotnet.hotreload.webassembly.browser@10.0.107
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.configuration.abstractions@10.0.10
microsoft.extensions.configuration.binder@10.0.10
microsoft.extensions.configuration.fileextensions@10.0.10
microsoft.extensions.configuration.json@10.0.10
microsoft.extensions.configuration@10.0.10
microsoft.extensions.dependencyinjection.abstractions@10.0.10
microsoft.extensions.dependencyinjection.abstractions@6.0.0
microsoft.extensions.dependencyinjection@10.0.10
microsoft.extensions.dependencyinjection@6.0.0
microsoft.extensions.dependencymodel@8.0.2
microsoft.extensions.diagnostics.abstractions@10.0.10
microsoft.extensions.diagnostics@10.0.10
microsoft.extensions.fileproviders.abstractions@10.0.10
microsoft.extensions.fileproviders.physical@10.0.10
microsoft.extensions.filesystemglobbing@10.0.10
microsoft.extensions.logging.abstractions@10.0.10
microsoft.extensions.logging.abstractions@6.0.0
microsoft.extensions.logging@10.0.10
microsoft.extensions.logging@2.1.1
microsoft.extensions.logging@6.0.0
microsoft.extensions.options.configurationextensions@10.0.10
microsoft.extensions.options@10.0.10
microsoft.extensions.options@6.0.0
microsoft.extensions.primitives@10.0.10
microsoft.extensions.primitives@6.0.0
microsoft.extensions.validation@10.0.10
microsoft.jsinterop.webassembly@10.0.10
microsoft.jsinterop@10.0.10
microsoft.net.test.sdk@18.8.1
microsoft.netcore.platforms@1.1.0
microsoft.sourcelink.common@10.0.301
microsoft.sourcelink.github@10.0.301
microsoft.testing.extensions.telemetry@2.1.0
microsoft.testing.extensions.trxreport.abstractions@2.1.0
microsoft.testing.extensions.vstestbridge@2.1.0
microsoft.testing.platform.msbuild@2.1.0
microsoft.testing.platform@2.1.0
microsoft.testplatform.objectmodel@18.0.1
microsoft.testplatform.objectmodel@18.8.1
microsoft.testplatform.testhost@18.8.1
microsoft.visualstudio.diagnosticshub.benchmarkdotnetdiagnosers@18.7.37220.1
netstandard.library.ref@2.1.0
netstandard.library@2.0.3
nunit3testadapter@6.2.0
nunit@4.6.1
perfolizer@0.6.1
pragmastat@3.2.4
system.buffers@4.5.1
system.buffers@4.6.1
system.codedom@9.0.5
system.collections.immutable@5.0.0
system.collections.immutable@6.0.0
system.io.hashing@10.0.10
system.management@9.0.5
system.memory@4.5.4
system.memory@4.6.3
system.numerics.vectors@4.4.0
system.numerics.vectors@4.6.1
system.reflection.metadata@5.0.0
system.reflection.typeextensions@4.7.0
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.compilerservices.unsafe@6.1.2
system.text.encoding.codepages@6.0.0
system.threading.tasks.extensions@4.5.4
"

inherit dotnet-pkg

DESCRIPTION="Mond is a scripting language for .NET Core"
HOMEPAGE="https://mond.rohan.dev/
	https://github.com/Rohansi/Mond/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Rohansi/${PN^}"
else
	SRC_URI="https://github.com/Rohansi/${PN^}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${P^}"
	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

DOTNET_PKG_PROJECTS=( Mond.Repl/Mond.Repl.csproj )
DOCS=( README.md Examples )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_configure() {
	dotnet-pkg_src_configure
	dotnet-pkg-base_restore Mond.Tests
}

src_test() {
	dotnet-pkg-base_test Mond.Tests
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/Mond.Repl" "${PN}"
	docompress -x "/usr/share/doc/${PF}/Examples"
	einstalldocs
}
