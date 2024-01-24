# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGETS="
argon@0.13.0
autofixture.autonsubstitute@4.18.0
autofixture.nunit3@4.18.0
autofixture@4.18.0
bogus@34.0.2
castle.core@5.1.1
coverlet.collector@6.0.0
diffengine@13.0.0
emptyfiles@5.0.0
fare@2.1.1
mcmaster.extensions.commandlineutils@4.1.0
microsoft.build.framework@17.3.2
microsoft.build.framework@17.6.3
microsoft.build.framework@17.8.3
microsoft.build.locator@1.6.10
microsoft.build@17.3.2
microsoft.build@17.6.3
microsoft.build@17.8.3
microsoft.codecoverage@17.8.0
microsoft.extensions.fileproviders.abstractions@6.0.0
microsoft.extensions.filesystemglobbing@6.0.0
microsoft.extensions.primitives@6.0.0
microsoft.net.stringtools@17.3.2
microsoft.net.stringtools@17.6.3
microsoft.net.stringtools@17.8.3
microsoft.net.test.sdk@17.8.0
microsoft.netcore.platforms@1.1.0
microsoft.netcore.targets@1.1.0
microsoft.testplatform.objectmodel@17.8.0
microsoft.testplatform.testhost@17.8.0
microsoft.win32.primitives@4.3.0
microsoft.win32.systemevents@6.0.0
microsoft.win32.systemevents@7.0.0
mono.cecil@0.11.3
netarchtest.rules@1.3.2
netstandard.library@1.6.1
netstandard.library@2.0.0
newtonsoft.json@13.0.1
newtonsoft.json@13.0.3
nsubstitute@5.1.0
nuget.commands@6.8.0
nuget.common@6.8.0
nuget.configuration@6.8.0
nuget.credentials@6.8.0
nuget.dependencyresolver.core@6.8.0
nuget.frameworks@6.5.0
nuget.frameworks@6.8.0
nuget.librarymodel@6.8.0
nuget.packaging@6.8.0
nuget.projectmodel@6.8.0
nuget.protocol@6.8.0
nuget.versioning@6.8.0
nunit3testadapter@4.5.0
nunit@3.14.0
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
simpleinfoname@2.2.0
system.appcontext@4.3.0
system.buffers@4.3.0
system.codedom@6.0.0
system.collections.concurrent@4.3.0
system.collections.immutable@6.0.0
system.collections.immutable@7.0.0
system.collections@4.3.0
system.componentmodel.annotations@4.3.0
system.componentmodel.annotations@5.0.0
system.componentmodel@4.3.0
system.configuration.configurationmanager@6.0.0
system.configuration.configurationmanager@7.0.0
system.console@4.3.0
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.eventlog@6.0.0
system.diagnostics.eventlog@7.0.0
system.diagnostics.tools@4.3.0
system.diagnostics.tracing@4.3.0
system.drawing.common@6.0.0
system.drawing.common@7.0.0
system.formats.asn1@6.0.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.compression.zipfile@4.3.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io.hashing@8.0.0
system.io@4.3.0
system.linq.expressions@4.3.0
system.linq@4.3.0
system.management@6.0.2
system.memory@4.5.5
system.net.http@4.3.0
system.net.primitives@4.3.0
system.net.sockets@4.3.0
system.objectmodel@4.3.0
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.3.0
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.metadata@6.0.0
system.reflection.metadata@7.0.0
system.reflection.metadataloadcontext@6.0.0
system.reflection.metadataloadcontext@7.0.0
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.3.0
system.reflection@4.3.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.3.0
system.security.accesscontrol@6.0.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.pkcs@6.0.4
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.protecteddata@6.0.0
system.security.cryptography.protecteddata@7.0.0
system.security.cryptography.x509certificates@4.3.0
system.security.permissions@6.0.0
system.security.permissions@7.0.0
system.security.principal.windows@5.0.0
system.text.encoding.codepages@6.0.0
system.text.encoding.codepages@7.0.0
system.text.encoding.extensions@4.3.0
system.text.encoding@4.3.0
system.text.encodings.web@8.0.0
system.text.json@8.0.0
system.text.regularexpressions@4.3.0
system.threading.tasks.dataflow@6.0.0
system.threading.tasks.dataflow@7.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks@4.3.0
system.threading.timer@4.3.0
system.threading@4.3.0
system.windows.extensions@6.0.0
system.windows.extensions@7.0.0
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.3.0
tinycsvparser@2.7.0
verify.nunit@22.5.0
verify@22.5.0
"

inherit dotnet-pkg

DESCRIPTION=".NET Core tool to print or save all the licenses of a project"
HOMEPAGE="https://github.com/tomchavakis/nuget-license/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/tomchavakis/${PN}.git"
else
	SRC_URI="https://github.com/tomchavakis/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0"
SLOT="0"

DOTNET_PKG_PROJECTS=( src/NuGetUtility/NuGetUtility.csproj )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	dotnet-pkg_src_prepare

	rm tests/*/*/ReferencedPackagesReaderIntegrationTest.cs || die
}

src_test() {
	local -x RollForward=Major

	dotnet-pkg_src_test
}

src_install() {
	dotnet-pkg_src_install

	dotnet-pkg-base_dolauncher "/usr/share/${P}/NuGetUtility" "${PN}"
}
