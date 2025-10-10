# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="9.0"
NUGETS="
argon@0.27.0
argon@0.32.0
autofac@8.4.0
basic.reference.assemblies.net80@1.8.3
basic.reference.assemblies.net90@1.8.3
castle.core@5.2.1
diffengine@15.11.0
diffengine@16.6.0
diffplex@1.7.2
emptyfiles@8.13.0
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.bcl.asyncinterfaces@9.0.9
microsoft.bcl.cryptography@9.0.9
microsoft.build.tasks.git@8.0.0
microsoft.codeanalysis.analyzers@3.11.0
microsoft.codeanalysis.common@4.11.0
microsoft.codeanalysis.common@4.14.0
microsoft.codeanalysis.csharp.scripting@4.14.0
microsoft.codeanalysis.csharp@4.14.0
microsoft.codeanalysis.scripting.common@4.14.0
microsoft.codecoverage@18.0.0
microsoft.csharp@4.7.0
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.logging.abstractions@8.0.0
microsoft.identitymodel.abstractions@8.14.0
microsoft.identitymodel.jsonwebtokens@8.14.0
microsoft.identitymodel.logging@8.14.0
microsoft.identitymodel.tokens@8.14.0
microsoft.net.test.sdk@18.0.0
microsoft.netcore.platforms@7.0.4
microsoft.sourcelink.common@8.0.0
microsoft.sourcelink.github@8.0.0
microsoft.testing.extensions.trxreport.abstractions@1.8.4
microsoft.testing.platform.msbuild@1.8.4
microsoft.testing.platform@1.8.4
microsoft.testplatform.objectmodel@18.0.0
microsoft.testplatform.testhost@18.0.0
microsoft.win32.registry@5.0.0
newtonsoft.json@13.0.4
nsubstitute@5.3.0
nuget.common@6.14.0
nuget.configuration@6.14.0
nuget.frameworks@6.14.0
nuget.packaging@6.14.0
nuget.protocol@6.14.0
nuget.resolver@6.14.0
nuget.versioning@6.14.0
simpleinfoname@3.1.0
simpleinfoname@3.1.2
spectre.console.cli@0.51.1
spectre.console@0.51.1
spectre.verify.extensions@28.16.0
stylecop.analyzers@1.1.118
system.codedom@8.0.0
system.collections.immutable@9.0.9
system.diagnostics.diagnosticsource@8.0.1
system.diagnostics.eventlog@6.0.0
system.formats.asn1@9.0.9
system.io.hashing@9.0.3
system.management@8.0.0
system.reflection.metadata@9.0.9
system.security.accesscontrol@5.0.0
system.security.cryptography.pkcs@9.0.9
system.security.cryptography.protecteddata@4.4.0
system.security.principal.windows@5.0.0
verify.diffplex@3.1.2
verify.xunitv3@30.19.2
verify@27.0.0
verify@28.16.0
verify@30.19.2
xunit.analyzers@1.24.0
xunit.runner.visualstudio@3.1.5
xunit.v3.assert@3.1.0
xunit.v3.common@3.1.0
xunit.v3.core@3.1.0
xunit.v3.extensibility.core@3.1.0
xunit.v3.runner.common@3.1.0
xunit.v3.runner.inproc.console@3.1.0
xunit.v3@3.1.0
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
PATCHES=( "${FILESDIR}/${PN}-4.2.0-no-git.patch" )

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
