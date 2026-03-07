# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
argon@0.27.0
argon@0.33.5
autofac@9.0.0
basic.reference.assemblies.net100@1.8.4
basic.reference.assemblies.net80@1.8.4
basic.reference.assemblies.net90@1.8.4
castle.core@5.2.1
diffengine@15.11.0
diffengine@18.4.2
diffplex@1.7.2
emptyfiles@8.17.2
microsoft.applicationinsights@2.23.0
microsoft.bcl.asyncinterfaces@10.0.3
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.codeanalysis.analyzers@3.11.0
microsoft.codeanalysis.common@4.11.0
microsoft.codeanalysis.common@5.0.0
microsoft.codeanalysis.csharp.scripting@5.0.0
microsoft.codeanalysis.csharp@5.0.0
microsoft.codeanalysis.scripting.common@5.0.0
microsoft.codecoverage@18.3.0
microsoft.extensions.dependencyinjection.abstractions@10.0.0
microsoft.extensions.dependencyinjection.abstractions@10.0.3
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.2
microsoft.extensions.dependencyinjection.abstractions@9.0.13
microsoft.extensions.dependencyinjection@10.0.3
microsoft.extensions.dependencyinjection@8.0.1
microsoft.extensions.dependencyinjection@9.0.13
microsoft.extensions.logging.abstractions@10.0.0
microsoft.extensions.logging.abstractions@8.0.0
microsoft.extensions.timeprovider.testing@10.3.0
microsoft.identitymodel.abstractions@8.16.0
microsoft.identitymodel.jsonwebtokens@8.16.0
microsoft.identitymodel.logging@8.16.0
microsoft.identitymodel.tokens@8.16.0
microsoft.net.test.sdk@18.3.0
microsoft.netcore.platforms@7.0.4
microsoft.testing.extensions.telemetry@1.9.1
microsoft.testing.extensions.trxreport.abstractions@1.9.1
microsoft.testing.platform.msbuild@1.9.1
microsoft.testing.platform@1.9.1
microsoft.testplatform.objectmodel@18.3.0
microsoft.testplatform.testhost@18.3.0
microsoft.win32.registry@5.0.0
newtonsoft.json@13.0.4
nsubstitute@5.3.0
nuget.common@7.3.0
nuget.configuration@7.3.0
nuget.credentials@7.3.0
nuget.frameworks@7.3.0
nuget.packaging@7.3.0
nuget.protocol@7.3.0
nuget.resolver@7.3.0
nuget.versioning@7.3.0
simpleinfoname@3.1.0
simpleinfoname@3.2.0
spectre.console.cli@0.53.1
spectre.console.testing@0.54.0
spectre.console@0.54.0
spectre.verify.extensions@28.16.0
stylecop.analyzers@1.1.118
system.collections.immutable@9.0.0
system.diagnostics.diagnosticsource@10.0.0
system.diagnostics.eventlog@6.0.0
system.io.hashing@9.0.3
system.reflection.metadata@9.0.0
system.security.cryptography.pkcs@10.0.3
system.security.cryptography.pkcs@8.0.1
system.security.cryptography.pkcs@9.0.13
system.security.cryptography.protecteddata@8.0.0
verify.diffplex@3.1.2
verify.xunitv3@31.13.2
verify@27.0.0
verify@28.16.0
verify@31.13.2
xunit.abstractions@2.0.3
xunit.analyzers@1.18.0
xunit.analyzers@1.27.0
xunit.assert@2.9.3
xunit.core@2.9.3
xunit.extensibility.core@2.9.3
xunit.extensibility.execution@2.9.3
xunit.runner.visualstudio@3.1.5
xunit.v3.assert@3.2.2
xunit.v3.common@3.2.2
xunit.v3.core.mtp-v1@3.2.2
xunit.v3.extensibility.core@3.2.2
xunit.v3.mtp-v1@3.2.2
xunit.v3.runner.common@3.2.2
xunit.v3.runner.inproc.console@3.2.2
xunit.v3@3.2.2
xunit@2.9.3
"

inherit dotnet-pkg

DESCRIPTION="Cake (C# Make) is a cross platform build automation system with a C# DSL"
HOMEPAGE="https://cakebuild.net/
	https://github.com/cake-build/cake/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/cake-build/${PN}"
else
	SRC_URI="https://github.com/cake-build/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"

DOTNET_PKG_PROJECTS=( src/Cake )
DOCS=( README.md ReleaseNotes.md SECURITY.md )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	dotnet-pkg_src_prepare

	sed -i \
		-e "s|net.*;net9.0|net${DOTNET_PKG_COMPAT}|" \
		src/Shared.msbuild \
		tests/integration/Cake.Frosting/build/Build.csproj \
		|| die
}
