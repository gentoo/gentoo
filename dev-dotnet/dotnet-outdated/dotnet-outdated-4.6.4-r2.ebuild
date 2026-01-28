# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
castle.core@5.1.1
csvhelper@30.0.1
dotnet-xunit@2.3.1
libuv@1.9.0
mcmaster.extensions.commandlineutils@4.0.2
microsoft.codeanalysis.analyzers@1.1.0
microsoft.codeanalysis.common@1.3.0
microsoft.codeanalysis.csharp@1.3.0
microsoft.codeanalysis.visualbasic@1.3.0
microsoft.codecoverage@17.9.0
microsoft.csharp@4.0.1
microsoft.extensions.dependencyinjection.abstractions@7.0.0
microsoft.extensions.dependencyinjection@7.0.0
microsoft.net.test.sdk@17.9.0
microsoft.netcore.app@1.0.0
microsoft.netcore.dotnethost@1.0.1
microsoft.netcore.dotnethostpolicy@1.0.1
microsoft.netcore.dotnethostresolver@1.0.1
microsoft.netcore.jit@1.0.2
microsoft.netcore.platforms@1.0.1
microsoft.netcore.runtime.coreclr@1.0.2
microsoft.netcore.targets@1.0.1
microsoft.netcore.windows.apisets@1.0.1
microsoft.testplatform.objectmodel@17.9.0
microsoft.testplatform.testhost@17.9.0
microsoft.visualbasic@10.0.1
microsoft.win32.primitives@4.0.1
microsoft.win32.registry@4.0.0
netstandard.library@1.6.0
newtonsoft.json@13.0.1
newtonsoft.json@13.0.3
nsubstitute@5.1.0
nuget.common@6.8.0
nuget.configuration@6.8.0
nuget.credentials@6.8.0
nuget.dependencyresolver.core@6.8.0
nuget.frameworks@6.8.0
nuget.librarymodel@6.8.0
nuget.packaging@6.8.0
nuget.projectmodel@6.8.0
nuget.protocol@6.8.0
nuget.versioning@6.8.0
runtime.native.system.io.compression@4.1.0
runtime.native.system.net.http@4.0.1
runtime.native.system.net.security@4.0.1
runtime.native.system.security.cryptography@4.0.0
runtime.native.system@4.0.0
system.appcontext@4.1.0
system.buffers@4.0.0
system.collections.concurrent@4.0.12
system.collections.immutable@1.2.0
system.collections@4.0.11
system.componentmodel.annotations@4.1.0
system.componentmodel.annotations@5.0.0
system.componentmodel@4.0.1
system.console@4.0.0
system.diagnostics.debug@4.0.11
system.diagnostics.diagnosticsource@4.0.0
system.diagnostics.eventlog@6.0.0
system.diagnostics.fileversioninfo@4.0.0
system.diagnostics.process@4.1.0
system.diagnostics.stacktrace@4.0.1
system.diagnostics.tools@4.0.1
system.diagnostics.tracing@4.1.0
system.dynamic.runtime@4.0.11
system.formats.asn1@6.0.0
system.globalization.calendars@4.0.1
system.globalization.extensions@4.0.1
system.globalization@4.0.11
system.io.abstractions.testinghelpers@19.2.64
system.io.abstractions@19.2.64
system.io.compression.zipfile@4.0.1
system.io.compression@4.1.0
system.io.filesystem.primitives@4.0.1
system.io.filesystem.watcher@4.0.0
system.io.filesystem@4.0.1
system.io.memorymappedfiles@4.0.0
system.io.unmanagedmemorystream@4.0.1
system.io@4.1.0
system.linq.expressions@4.1.0
system.linq.parallel@4.0.1
system.linq.queryable@4.0.1
system.linq@4.1.0
system.net.http@4.1.0
system.net.nameresolution@4.0.0
system.net.primitives@4.0.11
system.net.requests@4.0.11
system.net.security@4.0.0
system.net.sockets@4.1.0
system.net.webheadercollection@4.0.1
system.numerics.vectors@4.1.1
system.objectmodel@4.0.12
system.reflection.dispatchproxy@4.0.1
system.reflection.emit.ilgeneration@4.0.1
system.reflection.emit.lightweight@4.0.1
system.reflection.emit@4.0.1
system.reflection.extensions@4.0.1
system.reflection.metadata@1.3.0
system.reflection.metadata@1.6.0
system.reflection.primitives@4.0.1
system.reflection.typeextensions@4.1.0
system.reflection@4.1.0
system.resources.reader@4.0.0
system.resources.resourcemanager@4.0.1
system.runtime.extensions@4.1.0
system.runtime.handles@4.0.1
system.runtime.interopservices.runtimeinformation@4.0.0
system.runtime.interopservices@4.1.0
system.runtime.loader@4.0.0
system.runtime.numerics@4.0.1
system.runtime@4.1.0
system.security.claims@4.0.1
system.security.cryptography.algorithms@4.2.0
system.security.cryptography.cng@4.2.0
system.security.cryptography.csp@4.0.0
system.security.cryptography.encoding@4.0.0
system.security.cryptography.openssl@4.0.0
system.security.cryptography.pkcs@6.0.4
system.security.cryptography.primitives@4.0.0
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.x509certificates@4.1.0
system.security.principal.windows@4.0.0
system.security.principal@4.0.1
system.text.encoding.codepages@4.0.1
system.text.encoding.extensions@4.0.11
system.text.encoding@4.0.11
system.text.regularexpressions@4.1.0
system.threading.overlapped@4.0.1
system.threading.tasks.dataflow@4.6.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks.parallel@4.0.1
system.threading.tasks@4.0.11
system.threading.thread@4.0.0
system.threading.threadpool@4.0.10
system.threading.timer@4.0.1
system.threading@4.0.11
system.xml.readerwriter@4.0.11
system.xml.xdocument@4.0.11
system.xml.xmldocument@4.0.1
system.xml.xpath.xdocument@4.0.1
system.xml.xpath@4.0.1
testableio.system.io.abstractions.testinghelpers@19.2.64
testableio.system.io.abstractions.wrappers@19.2.64
testableio.system.io.abstractions@19.2.64
xunit.abstractions@2.0.3
xunit.analyzers@1.12.0
xunit.assert@2.7.1
xunit.core@2.7.1
xunit.extensibility.core@2.7.1
xunit.extensibility.execution@2.7.1
xunit.runner.visualstudio@2.5.8
xunit@2.7.1
"

inherit check-reqs dotnet-pkg

DESCRIPTION="Display and update outdated NuGet packages in a project"
HOMEPAGE="https://github.com/dotnet-outdated/dotnet-outdated/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

CHECKREQS_DISK_BUILD="1500M"
DOTNET_PKG_PROJECTS=( src/DotNetOutdated/DotNetOutdated.csproj )

DOCS=( CHANGELOG.md README.md )

dotnet-pkg_force-compat

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
	dotnet-pkg_src_prepare

	rm ./test/DotNetOutdated.Tests/EndToEndTests.cs || die
}
