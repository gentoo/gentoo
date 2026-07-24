# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
argon@0.27.0
argon@0.34.0
autofac@9.1.0
basic.reference.assemblies.net100@1.8.8
basic.reference.assemblies.net80@1.8.8
basic.reference.assemblies.net90@1.8.8
castle.core@5.2.1
coverlet.collector@8.0.1
diffengine@15.11.0
diffengine@19.2.0
diffplex@1.7.2
emptyfiles@8.18.1
microsoft.applicationinsights@2.23.0
microsoft.bcl.asyncinterfaces@10.0.8
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.codeanalysis.analyzers@5.3.0-2.25625.1
microsoft.codeanalysis.common@4.11.0
microsoft.codeanalysis.common@5.3.0
microsoft.codeanalysis.csharp.scripting@5.3.0
microsoft.codeanalysis.csharp@5.3.0
microsoft.codeanalysis.scripting.common@5.3.0
microsoft.codecoverage@18.5.1
microsoft.diasymreader@2.2.6
microsoft.extensions.dependencyinjection.abstractions@10.0.8
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.dependencyinjection@10.0.8
microsoft.extensions.dependencymodel@8.0.2
microsoft.extensions.logging.abstractions@8.0.0
microsoft.extensions.timeprovider.testing@10.6.0
microsoft.identitymodel.abstractions@8.18.0
microsoft.identitymodel.jsonwebtokens@8.18.0
microsoft.identitymodel.logging@8.18.0
microsoft.identitymodel.tokens@8.18.0
microsoft.net.test.sdk@18.5.1
microsoft.netcore.platforms@7.0.4
microsoft.testing.extensions.codecoverage@18.7.0
microsoft.testing.extensions.telemetry@2.0.2
microsoft.testing.extensions.trxreport.abstractions@2.0.2
microsoft.testing.extensions.trxreport.abstractions@2.2.3
microsoft.testing.extensions.trxreport@2.2.3
microsoft.testing.platform.msbuild@2.0.2
microsoft.testing.platform@2.0.2
microsoft.testing.platform@2.2.1
microsoft.testing.platform@2.2.3
microsoft.testplatform.objectmodel@18.5.1
microsoft.testplatform.testhost@18.5.1
microsoft.win32.registry@5.0.0
newtonsoft.json@13.0.4
nsubstitute@5.3.0
nuget.common@7.6.0
nuget.configuration@7.6.0
nuget.credentials@7.6.0
nuget.frameworks@7.6.0
nuget.packaging@7.6.0
nuget.protocol@7.6.0
nuget.resolver@7.6.0
nuget.versioning@7.6.0
simpleinfoname@3.1.0
simpleinfoname@3.2.0
spectre.console.ansi@0.55.2
spectre.console.cli@0.55.0
spectre.console.testing@0.55.2
spectre.console@0.55.2
spectre.verify.extensions@28.16.0
stylecop.analyzers@1.1.118
system.collections.immutable@9.0.0
system.diagnostics.diagnosticsource@10.0.0
system.diagnostics.eventlog@6.0.0
system.io.hashing@9.0.3
system.reflection.metadata@9.0.0
system.security.cryptography.pkcs@10.0.8
system.security.cryptography.pkcs@8.0.1
system.security.cryptography.pkcs@9.0.16
system.security.cryptography.protecteddata@8.0.0
verify.diffplex@3.1.2
verify.xunitv3@31.17.0
verify@27.0.0
verify@28.16.0
verify@31.17.0
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
xunit.v3.core.mtp-v2@3.2.2
xunit.v3.extensibility.core@3.2.2
xunit.v3.mtp-v2@3.2.2
xunit.v3.runner.common@3.2.2
xunit.v3.runner.inproc.console@3.2.2
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

DOTNET_PKG_PROJECTS=( src/Cake/Cake.csproj )
DOCS=( README.md ReleaseNotes.md SECURITY.md )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}
