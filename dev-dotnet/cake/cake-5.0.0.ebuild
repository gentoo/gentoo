# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="9.0"
NUGETS="
argon@0.15.0
argon@0.24.2
autofac@8.1.1
basic.reference.assemblies.net80@1.7.9
basic.reference.assemblies.net90@1.7.9
castle.core@5.1.1
diffengine@15.1.1
diffengine@15.5.3
emptyfiles@8.1.0
emptyfiles@8.5.0
microsoft.bcl.cryptography@9.0.0
microsoft.bcl.timeprovider@8.0.1
microsoft.build.tasks.git@8.0.0
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.common@4.11.0
microsoft.codeanalysis.common@4.12.0-3.final
microsoft.codeanalysis.csharp.scripting@4.12.0-3.final
microsoft.codeanalysis.csharp@4.12.0-3.final
microsoft.codeanalysis.scripting.common@4.12.0-3.final
microsoft.codecoverage@17.11.1
microsoft.csharp@4.7.0
microsoft.extensions.dependencyinjection.abstractions@9.0.0
microsoft.extensions.dependencyinjection@9.0.0
microsoft.identitymodel.abstractions@8.2.0
microsoft.identitymodel.jsonwebtokens@8.2.0
microsoft.identitymodel.logging@8.2.0
microsoft.identitymodel.tokens@8.2.0
microsoft.net.test.sdk@17.11.1
microsoft.netcore.platforms@7.0.4
microsoft.sourcelink.common@8.0.0
microsoft.sourcelink.github@8.0.0
microsoft.testplatform.objectmodel@17.11.1
microsoft.testplatform.testhost@17.11.1
microsoft.win32.registry@5.0.0
newtonsoft.json@13.0.3
nsubstitute@5.3.0
nuget.common@6.11.1
nuget.configuration@6.11.1
nuget.frameworks@6.11.1
nuget.packaging@6.11.1
nuget.protocol@6.11.1
nuget.resolver@6.11.1
nuget.versioning@6.11.1
simpleinfoname@2.2.0
simpleinfoname@3.0.1
spectre.console.cli@0.49.1
spectre.console@0.49.1
spectre.verify.extensions@22.3.1
stylecop.analyzers@1.1.118
system.codedom@8.0.0
system.collections.immutable@9.0.0
system.diagnostics.diagnosticsource@8.0.1
system.diagnostics.eventlog@6.0.0
system.formats.asn1@9.0.0
system.io.hashing@8.0.0
system.management@8.0.0
system.reflection.metadata@9.0.0
system.security.accesscontrol@5.0.0
system.security.cryptography.pkcs@9.0.0
system.security.cryptography.protecteddata@4.4.0
system.security.principal.windows@5.0.0
verify.xunit@28.2.0
verify@23.0.0
verify@28.2.0
xunit.abstractions@2.0.3
xunit.analyzers@1.16.0
xunit.assert@2.9.2
xunit.core@2.9.2
xunit.extensibility.core@2.9.2
xunit.extensibility.execution@2.9.2
xunit.runner.visualstudio@2.8.2
xunit@2.9.2
"

inherit dotnet-pkg

DESCRIPTION="Cake (C# Make) is a cross platform build automation system with a C# DSL"
HOMEPAGE="https://cakebuild.net/
	https://github.com/cake-build/cake/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/cake-build/${PN}.git"
else
	SRC_URI="https://github.com/cake-build/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
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

src_test() {
	dotnet-pkg-base_restore src/Cake.Common.Tests
	dotnet-pkg-base_test src/Cake.Common.Tests
}
