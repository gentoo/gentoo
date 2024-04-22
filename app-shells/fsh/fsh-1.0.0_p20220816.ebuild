# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=7.0
NUGETS="
dotnet-xunit@2.3.1
fsharp.compiler.service@26.0.1
fsharp.core@5.0.2
fsunit.xunit@3.4.0
libuv@1.9.0
microsoft.codeanalysis.analyzers@1.1.0
microsoft.codeanalysis.common@1.3.0
microsoft.codeanalysis.csharp@1.3.0
microsoft.codeanalysis.visualbasic@1.3.0
microsoft.codecoverage@15.9.0
microsoft.csharp@4.0.1
microsoft.dotnet.platformabstractions@1.0.3
microsoft.extensions.dependencymodel@1.0.3
microsoft.net.test.sdk@15.9.0
microsoft.netcore.app@1.0.0
microsoft.netcore.dotnethost@1.0.1
microsoft.netcore.dotnethostpolicy@1.0.1
microsoft.netcore.dotnethostresolver@1.0.1
microsoft.netcore.jit@1.0.2
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.runtime.coreclr@1.0.2
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.netcore.windows.apisets@1.0.1
microsoft.testplatform.objectmodel@15.9.0
microsoft.testplatform.testhost@15.9.0
microsoft.visualbasic@10.0.1
microsoft.win32.primitives@4.0.1
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@4.0.0
netstandard.library@1.6.0
netstandard.library@1.6.1
netstandard.library@2.0.3
newtonsoft.json@9.0.1
nhamcrest@2.0.1
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
runtime.native.system.data.sqlclient.sni@4.3.0
runtime.native.system.io.compression@4.1.0
runtime.native.system.io.compression@4.3.0
runtime.native.system.net.http@4.0.1
runtime.native.system.net.http@4.3.0
runtime.native.system.net.security@4.0.1
runtime.native.system.net.security@4.3.0
runtime.native.system.security.cryptography.apple@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system.security.cryptography@4.0.0
runtime.native.system@4.0.0
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
runtime.win7-x64.runtime.native.system.data.sqlclient.sni@4.3.0
runtime.win7-x86.runtime.native.system.data.sqlclient.sni@4.3.0
system.appcontext@4.1.0
system.appcontext@4.3.0
system.buffers@4.0.0
system.buffers@4.3.0
system.collections.concurrent@4.0.12
system.collections.concurrent@4.3.0
system.collections.immutable@1.2.0
system.collections.immutable@1.5.0
system.collections.nongeneric@4.0.1
system.collections.specialized@4.0.1
system.collections@4.0.11
system.collections@4.3.0
system.componentmodel.annotations@4.1.0
system.componentmodel.eventbasedasync@4.0.11
system.componentmodel.primitives@4.1.0
system.componentmodel.typeconverter@4.1.0
system.componentmodel@4.0.1
system.console@4.0.0
system.console@4.3.0
system.data.common@4.3.0
system.data.sqlclient@4.3.0
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.0.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.fileversioninfo@4.0.0
system.diagnostics.process@4.1.0
system.diagnostics.stacktrace@4.0.1
system.diagnostics.textwritertracelistener@4.0.0
system.diagnostics.tools@4.0.1
system.diagnostics.tools@4.3.0
system.diagnostics.tracesource@4.0.0
system.diagnostics.tracing@4.1.0
system.diagnostics.tracing@4.3.0
system.dynamic.runtime@4.0.11
system.globalization.calendars@4.0.1
system.globalization.calendars@4.3.0
system.globalization.extensions@4.0.1
system.globalization.extensions@4.3.0
system.globalization@4.0.11
system.globalization@4.3.0
system.io.compression.zipfile@4.0.1
system.io.compression.zipfile@4.3.0
system.io.compression@4.1.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.0.1
system.io.filesystem.primitives@4.3.0
system.io.filesystem.watcher@4.0.0
system.io.filesystem@4.0.1
system.io.filesystem@4.3.0
system.io.memorymappedfiles@4.0.0
system.io.pipes@4.3.0
system.io.unmanagedmemorystream@4.0.1
system.io@4.1.0
system.io@4.3.0
system.linq.expressions@4.1.0
system.linq.expressions@4.3.0
system.linq.parallel@4.0.1
system.linq.queryable@4.0.1
system.linq@4.1.0
system.linq@4.3.0
system.net.http@4.1.0
system.net.http@4.3.0
system.net.nameresolution@4.0.0
system.net.nameresolution@4.3.0
system.net.primitives@4.0.11
system.net.primitives@4.3.0
system.net.requests@4.0.11
system.net.security@4.0.0
system.net.security@4.3.0
system.net.sockets@4.1.0
system.net.sockets@4.3.0
system.net.webheadercollection@4.0.1
system.numerics.vectors@4.1.1
system.objectmodel@4.0.12
system.objectmodel@4.3.0
system.private.datacontractserialization@4.1.1
system.private.uri@4.3.0
system.reflection.dispatchproxy@4.0.1
system.reflection.emit.ilgeneration@4.0.1
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.0.1
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.0.1
system.reflection.emit@4.3.0
system.reflection.extensions@4.0.1
system.reflection.extensions@4.3.0
system.reflection.metadata@1.3.0
system.reflection.metadata@1.6.0
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.1.0
system.reflection.typeextensions@4.3.0
system.reflection@4.1.0
system.reflection@4.3.0
system.resources.reader@4.0.0
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.runtime.extensions@4.1.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.0.1
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.0.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.1.0
system.runtime.interopservices@4.3.0
system.runtime.loader@4.0.0
system.runtime.numerics@4.0.1
system.runtime.numerics@4.3.0
system.runtime.serialization.json@4.0.2
system.runtime.serialization.primitives@4.1.1
system.runtime@4.1.0
system.runtime@4.3.0
system.security.claims@4.0.1
system.security.claims@4.3.0
system.security.cryptography.algorithms@4.2.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.2.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.csp@4.0.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.0.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.0.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.primitives@4.0.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.x509certificates@4.1.0
system.security.cryptography.x509certificates@4.3.0
system.security.principal.windows@4.0.0
system.security.principal.windows@4.3.0
system.security.principal@4.0.1
system.security.principal@4.3.0
system.text.encoding.codepages@4.0.1
system.text.encoding.codepages@4.3.0
system.text.encoding.extensions@4.0.11
system.text.encoding.extensions@4.3.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.text.regularexpressions@4.1.0
system.text.regularexpressions@4.3.0
system.threading.overlapped@4.0.1
system.threading.overlapped@4.3.0
system.threading.tasks.dataflow@4.6.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.parallel@4.0.1
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.thread@4.0.0
system.threading.thread@4.3.0
system.threading.threadpool@4.0.10
system.threading.threadpool@4.3.0
system.threading.timer@4.0.1
system.threading.timer@4.3.0
system.threading@4.0.11
system.threading@4.3.0
system.xml.readerwriter@4.0.11
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.0.11
system.xml.xdocument@4.3.0
system.xml.xmldocument@4.0.1
system.xml.xmlserializer@4.0.11
system.xml.xpath.xdocument@4.0.1
system.xml.xpath.xmldocument@4.0.1
system.xml.xpath@4.0.1
xunit.abstractions@2.0.3
xunit.analyzers@0.10.0
xunit.assert@2.4.1
xunit.core@2.4.1
xunit.extensibility.core@2.4.1
xunit.extensibility.execution@2.4.1
xunit.runner.visualstudio@2.4.1
xunit@2.4.1
"

inherit dotnet-pkg

DESCRIPTION="F# Shell with integrated F# scripting"
HOMEPAGE="https://github.com/ChrisPritchard/FSH/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ChrisPritchard/FSH.git"
else
	[[ "${PV}" == *_p20220816 ]] && COMMIT=6356c92841af4ca69b835cd7c60899d2009f5d28

	SRC_URI="https://github.com/ChrisPritchard/FSH/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN^^}-${COMMIT}"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

DOTNET_PKG_PROJECTS=( src/FSH.fsproj )
DOTNET_PKG_BUILD_EXTRA_ARGS=( -p:RollForward=Major )
DOTNET_PKG_TEST_EXTRA_ARGS=( "${DOTNET_PKG_BUILD_EXTRA_ARGS[@]}" )

DOCS=( README.md )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n ${EGIT_REPO_URI} ]] ; then
		git-r3_src_unpack
	fi
}

src_install() {
	dotnet-pkg_src_install

	dotnet-pkg-base_dolauncher "/usr/share/${P}/${PN^^}" "${PN}"
}
