# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
dotnet.script.dependencymodel.nuget@1.3.1
dotnet.script.dependencymodel@1.3.1
medallionshell@1.6.1
microsoft.build.framework@16.4.0
microsoft.build.tasks.core@16.4.0
microsoft.build.utilities.core@16.4.0
microsoft.build@16.4.0
microsoft.codeanalysis.analyzers@3.3.2
microsoft.codeanalysis.common@4.0.0-6.final
microsoft.codeanalysis.common@4.1.0-1.final
microsoft.codeanalysis.csharp.scripting@4.0.0-6.final
microsoft.codeanalysis.csharp.scripting@4.1.0-1.final
microsoft.codeanalysis.csharp@4.0.0-6.final
microsoft.codeanalysis.csharp@4.1.0-1.final
microsoft.codeanalysis.scripting.common@4.0.0-6.final
microsoft.codeanalysis.scripting.common@4.1.0-1.final
microsoft.codeanalysis.scripting@4.1.0-1.final
microsoft.codecoverage@16.5.0
microsoft.csharp@4.0.1
microsoft.csharp@4.3.0
microsoft.dotnet.internalabstractions@1.0.0
microsoft.dotnet.platformabstractions@3.1.6
microsoft.net.test.sdk@16.5.0
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.platforms@2.1.2
microsoft.netcore.platforms@3.1.0
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.netcore.targets@1.1.3
microsoft.testplatform.objectmodel@16.5.0
microsoft.testplatform.testhost@16.5.0
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@4.3.0
microsoft.win32.registry@4.7.0
netstandard.library@2.0.0
newtonsoft.json@9.0.1
nuget.common@5.2.0
nuget.configuration@5.2.0
nuget.dependencyresolver.core@5.2.0
nuget.frameworks@5.0.0
nuget.frameworks@5.2.0
nuget.librarymodel@5.2.0
nuget.packaging@5.2.0
nuget.projectmodel@5.2.0
nuget.protocol@5.2.0
nuget.versioning@5.2.0
nunit@3.12.0
nunit3testadapter@3.16.1
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
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system.net.http@4.3.0
runtime.native.system.security.cryptography.apple@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system@4.0.0
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.unix.microsoft.win32.primitives@4.3.0
runtime.unix.system.diagnostics.debug@4.3.0
runtime.unix.system.io.filesystem@4.3.0
runtime.unix.system.net.primitives@4.3.0
runtime.unix.system.private.uri@4.3.0
runtime.unix.system.runtime.extensions@4.3.0
system.appcontext@4.1.0
system.buffers@4.3.0
system.codedom@4.7.0
system.collections.concurrent@4.0.12
system.collections.concurrent@4.3.0
system.collections.immutable@1.5.0
system.collections.immutable@5.0.0
system.collections.nongeneric@4.3.0
system.collections.specialized@4.3.0
system.collections@4.0.11
system.collections@4.3.0
system.componentmodel.eventbasedasync@4.3.0
system.componentmodel.primitives@4.3.0
system.componentmodel.typeconverter@4.3.0
system.componentmodel@4.3.0
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.process@4.3.0
system.diagnostics.tools@4.0.1
system.diagnostics.tracesource@4.0.0
system.diagnostics.tracing@4.1.0
system.diagnostics.tracing@4.3.0
system.dynamic.runtime@4.0.11
system.dynamic.runtime@4.3.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.0.11
system.globalization@4.3.0
system.io.filesystem.primitives@4.0.1
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.0.1
system.io.filesystem@4.3.0
system.io@4.1.0
system.io@4.3.0
system.linq.expressions@4.1.0
system.linq.expressions@4.3.0
system.linq.parallel@4.0.1
system.linq@4.1.0
system.linq@4.3.0
system.memory@4.5.3
system.memory@4.5.4
system.net.http@4.3.4
system.net.primitives@4.3.0
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
system.reflection.metadata@5.0.0
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.1.0
system.reflection.typeextensions@4.3.0
system.reflection@4.1.0
system.reflection@4.3.0
system.resources.extensions@4.6.0
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.resources.writer@4.0.0
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.extensions@4.1.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.0.1
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.1.0
system.runtime.interopservices@4.3.0
system.runtime.loader@4.0.0
system.runtime.numerics@4.3.0
system.runtime.serialization.primitives@4.1.1
system.runtime@4.1.0
system.runtime@4.3.0
system.runtime@4.3.1
system.security.accesscontrol@4.7.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@4.7.0
system.security.cryptography.x509certificates@4.3.0
system.security.principal.windows@4.7.0
system.text.encoding.codepages@4.0.1
system.text.encoding.codepages@4.5.1
system.text.encoding.extensions@4.0.11
system.text.encoding.extensions@4.3.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.text.regularexpressions@4.1.0
system.text.regularexpressions@4.3.0
system.threading.tasks.dataflow@4.9.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.thread@4.0.0
system.threading.thread@4.3.0
system.threading.threadpool@4.3.0
system.threading@4.0.11
system.threading@4.3.0
system.xml.readerwriter@4.0.11
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.0.11
system.xml.xmldocument@4.3.0
system.xml.xpath.xmldocument@4.3.0
system.xml.xpath@4.3.0
"

inherit check-reqs dotnet-pkg

DESCRIPTION="C# scripting build automation task runner"
HOMEPAGE="https://github.com/yevhen/Nake/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/yevhen/${PN^}.git"
else
	SRC_URI="https://github.com/yevhen/${PN^}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${P^}"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0"
SLOT="0"

CHECKREQS_DISK_BUILD="2G"
DOTNET_PKG_PROJECTS=( "${S}/Source/Nake/Nake.csproj" )
PATCHES=( "${FILESDIR}/${PN}-3.0.0-csproj-framework.patch" )

DOTNET_PKG_RESTORE_EXTRA_ARGS=(
	-p:RollForward=Major
)
DOTNET_PKG_BUILD_EXTRA_ARGS=( "${DOTNET_PKG_RESTORE_EXTRA_ARGS[@]}" )
DOTNET_PKG_TEST_EXTRA_ARGS=( "${DOTNET_PKG_RESTORE_EXTRA_ARGS[@]}" )

pkg_setup() {
	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
}

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n ${EGIT_REPO_URI} ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	local -a bad_tests=(
		Source/Nake.Tests/Environment_variable_interpolation.cs
		Source/Nake.Tests/Loading_other_scripts.cs
		Source/Nake.Tests/Multi_level_caching.cs
		Source/Nake.Tests/Nuget_references.cs
		Source/Utility.Tests/ShellFixture.cs
	)
	rm "${bad_tests[@]}" || die

	dotnet-pkg_src_prepare
}
