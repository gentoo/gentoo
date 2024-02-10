# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGETS="
castle.core@4.4.0
coverlet.msbuild@2.8.0
gapotchenko.fx.reflection.loader@2022.2.7
gapotchenko.fx@2022.2.7
mcmaster.extensions.commandlineutils@4.0.2
microsoft.bcl.asyncinterfaces@7.0.0
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.common@4.8.0-3.final
microsoft.codeanalysis.csharp.scripting@4.8.0-3.final
microsoft.codeanalysis.csharp@4.8.0-3.final
microsoft.codeanalysis.scripting.common@4.8.0-3.final
microsoft.codecoverage@16.9.1
microsoft.codecoverage@17.3.2
microsoft.csharp@4.0.1
microsoft.csharp@4.7.0
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.commandlineutils@1.1.1
microsoft.extensions.configuration.abstractions@8.0.0
microsoft.extensions.configuration.binder@8.0.0
microsoft.extensions.configuration@8.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.dependencyinjection@8.0.0
microsoft.extensions.logging.abstractions@8.0.0
microsoft.extensions.logging.configuration@8.0.0
microsoft.extensions.logging.console@8.0.0
microsoft.extensions.logging@8.0.0
microsoft.extensions.options.configurationextensions@8.0.0
microsoft.extensions.options@8.0.0
microsoft.extensions.primitives@8.0.0
microsoft.net.test.sdk@16.9.1
microsoft.net.test.sdk@17.3.2
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.netframework.referenceassemblies.net472@1.0.0
microsoft.netframework.referenceassemblies@1.0.0
microsoft.testplatform.objectmodel@17.3.2
microsoft.testplatform.testhost@17.3.2
microsoft.win32.primitives@4.3.0
moq@4.14.5
netstandard.library@1.6.1
netstandard.library@2.0.3
newtonsoft.json@13.0.1
newtonsoft.json@9.0.1
nuget.common@6.2.0
nuget.configuration@6.2.0
nuget.dependencyresolver.core@6.2.0
nuget.frameworks@5.11.0
nuget.frameworks@6.2.0
nuget.librarymodel@6.2.0
nuget.packaging@6.2.0
nuget.projectmodel@6.2.0
nuget.protocol@6.2.0
nuget.versioning@6.2.0
readline@2.0.1
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
strongnamer@0.2.5
system.appcontext@4.3.0
system.buffers@4.3.0
system.buffers@4.5.1
system.collections.concurrent@4.3.0
system.collections.immutable@7.0.0
system.collections.nongeneric@4.3.0
system.collections.specialized@4.3.0
system.collections@4.0.11
system.collections@4.3.0
system.componentmodel.annotations@5.0.0
system.componentmodel.primitives@4.3.0
system.componentmodel.typeconverter@4.3.0
system.componentmodel@4.3.0
system.console@4.3.0
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.tools@4.0.1
system.diagnostics.tools@4.3.0
system.diagnostics.tracesource@4.3.0
system.diagnostics.tracing@4.3.0
system.dynamic.runtime@4.0.11
system.dynamic.runtime@4.3.0
system.formats.asn1@5.0.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.0.11
system.globalization@4.3.0
system.io.compression.zipfile@4.3.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.0.1
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.0.1
system.io.filesystem@4.3.0
system.io@4.1.0
system.io@4.3.0
system.linq.expressions@4.1.0
system.linq.expressions@4.3.0
system.linq@4.1.0
system.linq@4.3.0
system.memory@4.5.4
system.memory@4.5.5
system.net.http@4.3.0
system.net.nameresolution@4.3.0
system.net.primitives@4.3.0
system.net.sockets@4.3.0
system.numerics.vectors@4.4.0
system.numerics.vectors@4.5.0
system.objectmodel@4.0.12
system.objectmodel@4.3.0
system.private.uri@4.3.0
system.reflection.emit.ilgeneration@4.0.1
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.0.1
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.0.1
system.reflection.emit@4.3.0
system.reflection.extensions@4.0.1
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.metadata@7.0.0
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.1.0
system.reflection.typeextensions@4.3.0
system.reflection@4.1.0
system.reflection@4.3.0
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.1.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.0.1
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.0.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.1.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime.serialization.primitives@4.1.1
system.runtime@4.1.0
system.runtime@4.3.0
system.security.claims@4.3.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.cng@5.0.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.pkcs@5.0.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.x509certificates@4.3.0
system.security.principal.windows@4.3.0
system.security.principal@4.3.0
system.text.encoding.codepages@7.0.0
system.text.encoding.extensions@4.0.11
system.text.encoding.extensions@4.3.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.text.encodings.web@7.0.0
system.text.encodings.web@8.0.0
system.text.json@7.0.0
system.text.json@8.0.0
system.text.regularexpressions@4.1.0
system.text.regularexpressions@4.3.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.extensions@4.5.1
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.threadpool@4.3.0
system.threading.timer@4.3.0
system.threading@4.0.11
system.threading@4.3.0
system.valuetuple@4.5.0
system.xml.readerwriter@4.0.11
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.0.11
system.xml.xdocument@4.3.0
system.xml.xmldocument@4.3.0
xunit.abstractions@2.0.3
xunit.analyzers@0.10.0
xunit.assert@2.4.1
xunit.core@2.4.1
xunit.extensibility.core@2.4.1
xunit.extensibility.execution@2.4.1
xunit.runner.visualstudio@2.4.3
xunit@2.4.1
"

inherit check-reqs dotnet-pkg

DESCRIPTION="Run C# scripts from the CLI"
HOMEPAGE="https://github.com/dotnet-script/dotnet-script/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
RESTRICT="test"                                                   # Tests fail.

SRC_URI+=" ${NUGET_URIS} "

CHECKREQS_DISK_BUILD="1100M"
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
		 -e "s|;net7.0;net6.0||g" \
		 -e "s|netstandard2.0|net8.0|g" \
		 -e "s|net472|net8.0|g" \
		 -i {} + || die

	edotnet sln remove src/Dotnet.Script.Desktop.Tests/Dotnet.Script.Desktop.Tests.csproj
	dotnet-pkg_src_prepare
}
