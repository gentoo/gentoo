# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
argon@0.27.0
argon@0.35.0
argon@0.35.1
argon@0.37.0
autofac@9.3.2
basic.reference.assemblies.net100@1.8.11
castle.core@5.2.1
coverlet.collector@10.0.1
diffengine@15.11.0
diffengine@19.3.2
diffengine@20.3.1
diffplex@1.9.0
emptyfiles@8.18.2
microsoft.applicationinsights@2.23.0
microsoft.bcl.asyncinterfaces@10.0.12
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.bcl.cryptography@10.0.2
microsoft.codeanalysis.analyzers@5.9.0-1.26328.17
microsoft.codeanalysis.common@4.11.0
microsoft.codeanalysis.common@5.9.0
microsoft.codeanalysis.csharp.scripting@5.9.0
microsoft.codeanalysis.csharp@5.9.0
microsoft.codeanalysis.scripting.common@5.9.0
microsoft.codecoverage@18.10.0
microsoft.diasymreader@2.2.10
microsoft.extensions.dependencyinjection.abstractions@10.0.12
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.dependencyinjection@10.0.12
microsoft.extensions.dependencymodel@10.0.10
microsoft.extensions.logging.abstractions@8.0.0
microsoft.extensions.timeprovider.testing@10.10.0
microsoft.identitymodel.abstractions@8.22.0
microsoft.identitymodel.jsonwebtokens@8.22.0
microsoft.identitymodel.logging@8.22.0
microsoft.identitymodel.tokens@8.22.0
microsoft.net.test.sdk@18.10.0
microsoft.netcore.platforms@7.0.4
microsoft.testing.extensions.codecoverage@18.11.2
microsoft.testing.extensions.telemetry@2.4.0
microsoft.testing.extensions.trxreport.abstractions@2.4.0
microsoft.testing.extensions.trxreport@2.4.0
microsoft.testing.platform.msbuild@2.4.0
microsoft.testing.platform@2.4.0
microsoft.testplatform.objectmodel@18.10.0
microsoft.testplatform.testhost@18.10.0
microsoft.win32.registry@5.0.0
newtonsoft.json@13.0.4
nsubstitute@6.2.0
nuget.common@7.9.0
nuget.configuration@7.9.0
nuget.credentials@7.9.0
nuget.frameworks@7.9.0
nuget.packaging@7.9.0
nuget.protocol@7.9.0
nuget.resolver@7.9.0
nuget.versioning@7.9.0
simpleinfoname@3.1.0
simpleinfoname@3.2.0
spectre.console.ansi@0.57.2
spectre.console.cli@0.55.0
spectre.console.testing@0.57.2
spectre.console@0.57.2
spectre.verify.extensions@28.16.0
stylecop.analyzers@1.1.118
system.diagnostics.eventlog@6.0.0
system.io.hashing@9.0.3
system.security.accesscontrol@6.0.1
system.security.cryptography.pkcs@10.0.12
system.security.cryptography.protecteddata@8.0.0
verify.diffplex@3.3.1
verify.xunitv3@33.0.1
verify@28.16.0
verify@31.24.1
verify@33.0.1
xunit.abstractions@2.0.3
xunit.analyzers@1.18.0
xunit.analyzers@2.1.0
xunit.assert@2.9.3
xunit.core@2.9.3
xunit.extensibility.core@2.9.3
xunit.extensibility.execution@2.9.3
xunit.runner.visualstudio@4.0.0
xunit.v3.assert@4.0.1
xunit.v3.common@4.0.1
xunit.v3.core.mtp-v2@4.0.1
xunit.v3.extensibility.core@4.0.1
xunit.v3.mtp-v2@4.0.1
xunit.v3.runner.common@4.0.1
xunit.v3.runner.inproc.console@4.0.1
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

PATCHES=( "${FILESDIR}/${PN}-6.3.0-net10.patch" )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}
