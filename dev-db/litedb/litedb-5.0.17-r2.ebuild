# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=LiteDB

DOTNET_PKG_COMPAT=7.0
NUGETS="
benchmarkdotnet.annotations@0.12.0
benchmarkdotnet@0.12.0
commandlineparser@2.4.3
fluentassertions@5.10.2
microsoft.codeanalysis.analyzers@2.6.1
microsoft.codeanalysis.common@2.10.0
microsoft.codeanalysis.csharp@2.10.0
microsoft.codecoverage@17.4.1
microsoft.dotnet.platformabstractions@2.1.0
microsoft.net.test.sdk@17.4.1
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@2.0.0
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.netframework.referenceassemblies.net45@1.0.3
microsoft.netframework.referenceassemblies.net472@1.0.3
microsoft.netframework.referenceassemblies@1.0.3
microsoft.testplatform.objectmodel@17.4.1
microsoft.testplatform.testhost@17.4.1
microsoft.win32.primitives@4.0.1
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@4.5.0
netstandard.library@1.6.0
netstandard.library@1.6.1
netstandard.library@2.0.3
newtonsoft.json@13.0.1
nuget.frameworks@5.11.0
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
runtime.native.system.io.compression@4.1.0
runtime.native.system.io.compression@4.3.0
runtime.native.system.net.http@4.0.1
runtime.native.system.net.http@4.3.0
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
system.appcontext@4.1.0
system.appcontext@4.3.0
system.buffers@4.0.0
system.buffers@4.3.0
system.codedom@4.5.0
system.collections.concurrent@4.0.12
system.collections.concurrent@4.3.0
system.collections.immutable@1.5.0
system.collections@4.0.11
system.collections@4.3.0
system.configuration.configurationmanager@4.4.0
system.console@4.0.0
system.console@4.3.0
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.0.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.fileversioninfo@4.3.0
system.diagnostics.stacktrace@4.3.0
system.diagnostics.tools@4.0.1
system.diagnostics.tools@4.3.0
system.diagnostics.tracing@4.1.0
system.diagnostics.tracing@4.3.0
system.dynamic.runtime@4.3.0
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
system.io.filesystem@4.0.1
system.io.filesystem@4.3.0
system.io@4.1.0
system.io@4.3.0
system.linq.expressions@4.1.0
system.linq.expressions@4.3.0
system.linq@4.1.0
system.linq@4.3.0
system.management@4.5.0
system.net.http@4.1.0
system.net.http@4.3.0
system.net.nameresolution@4.3.0
system.net.primitives@4.0.11
system.net.primitives@4.3.0
system.net.sockets@4.1.0
system.net.sockets@4.3.0
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
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.1.0
system.reflection.typeextensions@4.3.0
system.reflection.typeextensions@4.5.1
system.reflection@4.1.0
system.reflection@4.3.0
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@4.5.2
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
system.runtime@4.1.0
system.runtime@4.3.0
system.security.accesscontrol@4.5.0
system.security.claims@4.3.0
system.security.cryptography.algorithms@4.2.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.algorithms@4.3.1
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
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.x509certificates@4.1.0
system.security.cryptography.x509certificates@4.3.0
system.security.principal.windows@4.3.0
system.security.principal.windows@4.5.0
system.security.principal@4.3.0
system.text.encoding.codepages@4.3.0
system.text.encoding.extensions@4.0.11
system.text.encoding.extensions@4.3.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.text.regularexpressions@4.1.0
system.text.regularexpressions@4.3.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.extensions@4.5.2
system.threading.tasks.parallel@4.3.0
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.thread@4.3.0
system.threading.threadpool@4.3.0
system.threading.timer@4.0.1
system.threading.timer@4.3.0
system.threading@4.0.11
system.threading@4.3.0
system.valuetuple@4.5.0
system.xml.readerwriter@4.0.11
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.0.11
system.xml.xdocument@4.3.0
system.xml.xmldocument@4.3.0
system.xml.xpath.xdocument@4.3.0
system.xml.xpath@4.3.0
xunit.abstractions@2.0.3
xunit.analyzers@1.0.0
xunit.assert@2.4.2
xunit.core@2.4.2
xunit.extensibility.core@2.4.2
xunit.extensibility.execution@2.4.2
xunit.runner.console@2.4.2
xunit.runner.reporters@2.4.2
xunit.runner.utility@2.4.2
xunit.runner.visualstudio@2.4.5
xunit@2.4.2
"

inherit check-reqs dotnet-pkg

DESCRIPTION=".NET NoSQL Document Store in a single data file"
HOMEPAGE="http://www.litedb.org/
	https://github.com/mbdavid/LiteDB/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/mbdavid/${MY_PN}.git"
else
	SRC_URI="https://github.com/mbdavid/${MY_PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

CHECKREQS_DISK_BUILD="2G"
DOTNET_PKG_BUILD_EXTRA_ARGS=( -p:RollForward=Major )
DOTNET_PKG_PROJECTS=( LiteDB.Shell/LiteDB.Shell.csproj )

pkg_setup() {
	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
}

src_test() {
	dotnet-pkg-base_test -p:RollForward=Major LiteDB.sln
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/LiteDB.Shell" "${PN}-shell"

	einstalldocs
}
