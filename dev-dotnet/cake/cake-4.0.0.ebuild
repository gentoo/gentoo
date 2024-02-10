# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGETS="
argon@0.13.0
autofac@7.1.0
basic.reference.assemblies.net80@1.4.5
castle.core@5.1.1
diffengine@12.4.2
diffengine@13.0.0
emptyfiles@4.6.0
emptyfiles@5.0.0
microsoft.codeanalysis.analyzers@3.0.0
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.common@3.9.0
microsoft.codeanalysis.common@4.8.0-3.final
microsoft.codeanalysis.csharp.scripting@4.8.0-3.final
microsoft.codeanalysis.csharp@4.8.0-3.final
microsoft.codeanalysis.scripting.common@4.8.0-3.final
microsoft.codecoverage@17.8.0
microsoft.csharp@4.7.0
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.dependencyinjection@8.0.0
microsoft.net.test.sdk@17.8.0
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@2.1.2
microsoft.netcore.platforms@5.0.0
microsoft.netcore.platforms@7.0.4
microsoft.netcore.targets@1.1.0
microsoft.sourcelink.common@8.0.0
microsoft.testplatform.objectmodel@17.8.0
microsoft.testplatform.testhost@17.8.0
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@5.0.0
netstandard.library@1.6.1
newtonsoft.json@13.0.1
newtonsoft.json@13.0.3
nsubstitute@5.1.0
nuget.common@6.7.0
nuget.configuration@6.7.0
nuget.frameworks@6.5.0
nuget.frameworks@6.7.0
nuget.packaging@6.7.0
nuget.protocol@6.7.0
nuget.resolver@6.7.0
nuget.versioning@6.7.0
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
simpleinfoname@2.1.1
simpleinfoname@2.2.0
spectre.console.cli@0.47.0
spectre.console@0.47.0
spectre.verify.extensions@22.3.0
stylecop.analyzers@1.1.118
system.appcontext@4.3.0
system.buffers@4.3.0
system.codedom@6.0.0
system.collections.concurrent@4.3.0
system.collections.immutable@8.0.0
system.collections@4.3.0
system.console@4.3.0
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.diagnosticsource@4.7.1
system.diagnostics.eventlog@6.0.0
system.diagnostics.tools@4.3.0
system.diagnostics.tracing@4.3.0
system.formats.asn1@6.0.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.compression.zipfile@4.3.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io.hashing@7.0.0
system.io.hashing@8.0.0
system.io@4.3.0
system.linq.expressions@4.3.0
system.linq@4.3.0
system.management@6.0.2
system.memory@4.5.4
system.memory@4.5.5
system.net.http@4.3.0
system.net.nameresolution@4.3.0
system.net.primitives@4.3.0
system.net.sockets@4.3.0
system.objectmodel@4.3.0
system.private.uri@4.3.0
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.3.0
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.metadata@8.0.0
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.3.0
system.reflection@4.3.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.3.0
system.security.accesscontrol@5.0.0
system.security.claims@4.3.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.pkcs@6.0.4
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.x509certificates@4.3.0
system.security.principal.windows@4.3.0
system.security.principal.windows@5.0.0
system.security.principal@4.3.0
system.text.encoding.codepages@4.5.1
system.text.encoding.extensions@4.3.0
system.text.encoding@4.3.0
system.text.regularexpressions@4.3.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.3.0
system.threading.threadpool@4.3.0
system.threading.timer@4.3.0
system.threading@4.3.0
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.3.0
verify.xunit@22.5.0
verify@22.3.0
verify@22.5.0
xunit.abstractions@2.0.3
xunit.analyzers@1.4.0
xunit.assert@2.6.1
xunit.core@2.6.1
xunit.extensibility.core@2.6.1
xunit.extensibility.execution@2.6.1
xunit.runner.visualstudio@2.5.3
xunit@2.6.1
"

inherit dotnet-pkg

DESCRIPTION="Cake (C# Make) is a cross platform build automation system"
HOMEPAGE="https://cakebuild.net/
	https://github.com/cake-build/cake/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/cake-build/${PN}.git"
else
	SRC_URI="https://github.com/cake-build/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "
S="${WORKDIR}/${P}/src"

LICENSE="MIT"
SLOT="0"

# Collision with dev-lang/coffee, file: cake, bug https://bugs.gentoo.org/914496
RDEPEND="
	!dev-lang/coffee-script
"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.0-no-git.patch"
)

DOTNET_PKG_PROJECTS=( Cake/Cake.csproj )

DOCS=( README.md ReleaseNotes.md SECURITY.md )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	dotnet-pkg-base_remove-global-json ../
	dotnet-pkg_src_prepare

	sed -e "s|net.*;net8.0|net${DOTNET_PKG_COMPAT}|" -i Shared.msbuild || die
}

src_test() {
	dotnet-pkg-base_test Cake.Core.Tests/Cake.Core.Tests.csproj
}

src_install() {
	# For docs, install them from higher directory.
	cd .. || die

	dotnet-pkg_src_install
}
