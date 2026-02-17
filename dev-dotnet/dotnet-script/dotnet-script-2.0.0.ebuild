# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
castle.core@5.1.1
coverlet.msbuild@6.0.4
gapotchenko.fx.reflection.loader@2024.2.5
gapotchenko.fx@2024.2.5
mcmaster.extensions.commandlineutils@4.1.1
microsoft.bcl.asyncinterfaces@8.0.0
microsoft.bcl.hashcode@1.1.1
microsoft.codeanalysis.analyzers@3.11.0
microsoft.codeanalysis.common@5.0.0-2.final
microsoft.codeanalysis.csharp.scripting@5.0.0-2.final
microsoft.codeanalysis.csharp@5.0.0-2.final
microsoft.codeanalysis.scripting.common@5.0.0-2.final
microsoft.codecoverage@18.0.1
microsoft.csharp@4.7.0
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.commandlineutils@1.1.1
microsoft.extensions.configuration.abstractions@10.0.0
microsoft.extensions.configuration.abstractions@8.0.0
microsoft.extensions.configuration.abstractions@9.0.0
microsoft.extensions.configuration.binder@10.0.0
microsoft.extensions.configuration.binder@8.0.0
microsoft.extensions.configuration.binder@9.0.0
microsoft.extensions.configuration@10.0.0
microsoft.extensions.configuration@8.0.0
microsoft.extensions.configuration@9.0.0
microsoft.extensions.dependencyinjection.abstractions@10.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.dependencyinjection.abstractions@9.0.0
microsoft.extensions.dependencyinjection@10.0.0
microsoft.extensions.dependencyinjection@8.0.0
microsoft.extensions.dependencyinjection@9.0.0
microsoft.extensions.logging.abstractions@10.0.0
microsoft.extensions.logging.abstractions@8.0.0
microsoft.extensions.logging.abstractions@9.0.0
microsoft.extensions.logging.configuration@10.0.0
microsoft.extensions.logging.configuration@8.0.0
microsoft.extensions.logging.configuration@9.0.0
microsoft.extensions.logging.console@10.0.0
microsoft.extensions.logging.console@8.0.0
microsoft.extensions.logging.console@9.0.0
microsoft.extensions.logging@10.0.0
microsoft.extensions.logging@8.0.0
microsoft.extensions.logging@9.0.0
microsoft.extensions.options.configurationextensions@10.0.0
microsoft.extensions.options.configurationextensions@8.0.0
microsoft.extensions.options.configurationextensions@9.0.0
microsoft.extensions.options@10.0.0
microsoft.extensions.options@8.0.0
microsoft.extensions.options@9.0.0
microsoft.extensions.primitives@10.0.0
microsoft.extensions.primitives@8.0.0
microsoft.extensions.primitives@9.0.0
microsoft.net.test.sdk@18.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netframework.referenceassemblies.net472@1.0.3
microsoft.netframework.referenceassemblies@1.0.3
microsoft.testplatform.objectmodel@17.13.0
microsoft.testplatform.objectmodel@18.0.1
microsoft.testplatform.testhost@18.0.1
moq@4.20.72
netstandard.library@1.6.1
netstandard.library@2.0.3
newtonsoft.json@13.0.3
nuget.common@6.14.0
nuget.configuration@6.14.0
nuget.dependencyresolver.core@6.14.0
nuget.frameworks@6.14.0
nuget.librarymodel@6.14.0
nuget.packaging@6.14.0
nuget.projectmodel@6.14.0
nuget.protocol@6.14.0
nuget.versioning@6.14.0
readline@2.0.1
strongnamer@0.2.5
system.buffers@4.4.0
system.buffers@4.5.1
system.buffers@4.6.0
system.collections.immutable@8.0.0
system.collections.immutable@9.0.0
system.componentmodel.annotations@5.0.0
system.diagnostics.eventlog@6.0.0
system.formats.asn1@6.0.0
system.formats.asn1@8.0.1
system.memory@4.5.3
system.memory@4.5.4
system.memory@4.5.5
system.memory@4.6.0
system.numerics.vectors@4.4.0
system.numerics.vectors@4.5.0
system.numerics.vectors@4.6.0
system.reflection.metadata@1.6.0
system.reflection.metadata@9.0.0
system.runtime.compilerservices.unsafe@4.5.2
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.compilerservices.unsafe@6.1.0
system.runtime.interopservices.runtimeinformation@4.0.0
system.security.cryptography.cng@5.0.0
system.security.cryptography.pkcs@6.0.4
system.security.cryptography.protecteddata@4.4.0
system.text.encoding.codepages@8.0.0
system.text.encodings.web@8.0.0
system.text.json@8.0.5
system.threading.tasks.extensions@4.5.4
system.threading.tasks.extensions@4.6.0
system.valuetuple@4.5.0
xunit.abstractions@2.0.3
xunit.analyzers@1.18.0
xunit.assert@2.9.3
xunit.core@2.9.3
xunit.extensibility.core@2.9.3
xunit.extensibility.execution@2.9.3
xunit.runner.visualstudio@3.1.5
xunit@2.9.3
"

inherit check-reqs dotnet-pkg

DESCRIPTION="Run C# scripts from the CLI"
HOMEPAGE="https://github.com/dotnet-script/dotnet-script/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"

CHECKREQS_DISK_BUILD="600M"
DOTNET_PKG_BUILD_EXTRA_ARGS=( -maxCpuCount:"1" )
DOTNET_PKG_BAD_PROJECTS=(
	src/Dotnet.Script.Desktop.Tests
	src/Dotnet.Script.Shared.Tests
	src/Dotnet.Script.Tests
)
DOTNET_PKG_PROJECTS=( src/Dotnet.Script/Dotnet.Script.csproj )

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
	find src -type f -name "*.csproj" -exec sed \
		-e "s|;net9.0;net8.0||g" \
		-e "s|net472|net10.0|g" \
		-e "s|netstandard2.0|net10.0|g" \
		-i {} + \
		|| die

	dotnet-pkg_src_prepare
}
