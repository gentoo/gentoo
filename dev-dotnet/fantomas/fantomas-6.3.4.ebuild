# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGETS="
dotnet-fsharplint@0.19.2
fantomas@6.3.0
fsdocs-tool@20.0.0
fsharp-analyzers@0.25.0

argu@6.1.1
cliwrap@3.6.4
commandlineparser@2.9.1
dotnet.reproduciblebuilds@1.1.1
editorconfig@0.15.0
fable.core@3.0.0
fparsec@1.1.1
fscheck@2.16.5
fsharp.analyzers.build@0.3.0
fsharp.core@5.0.1
fsharp.core@6.0.1
fsharp.core@8.0.101
fsharp.data.csv.core@6.3.0
fsharp.data.html.core@6.3.0
fsharp.data.http@6.3.0
fsharp.data.json.core@6.3.0
fsharp.data.runtime.utilities@6.3.0
fsharp.data.worldbank.core@6.3.0
fsharp.data.xml.core@6.3.0
fsharp.data@6.3.0
fslexyacc.runtime@11.2.0
fslexyacc@11.2.0
fsunit@6.0.0
fun.build@1.0.3
fun.result@2.0.9
g-research.fsharp.analyzers@0.9.3
gee.external.capstone@2.3.0
humanizer.core@2.14.1
iced@1.17.0
ignore@0.1.50
ionide.analyzers@0.9.0
ionide.keepachangelog.tasks@0.1.8
ionide.keepachangelog@0.1.8
messagepack.annotations@2.2.85
messagepack@2.2.85
microsoft.bcl.asyncinterfaces@1.1.0
microsoft.bcl.asyncinterfaces@5.0.0
microsoft.build.tasks.git@1.1.1
microsoft.codeanalysis.analyzers@3.3.3
microsoft.codeanalysis.common@4.1.0
microsoft.codeanalysis.csharp@4.1.0
microsoft.codecoverage@17.8.0
microsoft.diagnostics.netcore.client@0.2.251802
microsoft.diagnostics.runtime@2.2.332302
microsoft.diagnostics.tracing.traceevent@3.0.2
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.configuration.abstractions@2.1.1
microsoft.extensions.configuration.binder@2.1.1
microsoft.extensions.configuration@2.1.1
microsoft.extensions.dependencyinjection.abstractions@2.1.1
microsoft.extensions.logging.abstractions@2.1.1
microsoft.extensions.logging@2.1.1
microsoft.extensions.options@2.1.1
microsoft.extensions.primitives@2.1.1
microsoft.net.test.sdk@17.8.0
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.platforms@2.1.2
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.1.0
microsoft.netcore.targets@1.1.3
microsoft.sourcelink.azurerepos.git@1.1.1
microsoft.sourcelink.bitbucket.git@1.1.1
microsoft.sourcelink.common@1.1.1
microsoft.sourcelink.github@1.1.1
microsoft.sourcelink.gitlab@1.1.1
microsoft.testplatform.objectmodel@17.8.0
microsoft.testplatform.testhost@17.8.0
microsoft.visualstudio.threading.analyzers@16.9.60
microsoft.visualstudio.threading@16.9.60
microsoft.visualstudio.validation@15.5.31
microsoft.visualstudio.validation@16.8.33
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@5.0.0
nerdbank.streams@2.6.81
netstandard.library@2.0.3
newtonsoft.json@11.0.2
newtonsoft.json@12.0.2
newtonsoft.json@13.0.1
nuget.frameworks@6.5.0
nunit3testadapter@4.5.0
nunit@4.0.1
perfolizer@0.2.1
runtime.any.system.collections@4.3.0
runtime.any.system.diagnostics.tracing@4.3.0
runtime.any.system.globalization.calendars@4.3.0
runtime.any.system.globalization@4.3.0
runtime.any.system.io@4.3.0
runtime.any.system.reflection.primitives@4.3.0
runtime.any.system.reflection@4.3.0
runtime.any.system.resources.resourcemanager@4.3.0
runtime.any.system.runtime.handles@4.3.0
runtime.any.system.runtime.interopservices@4.3.0
runtime.any.system.runtime@4.3.0
runtime.any.system.text.encoding.extensions@4.3.0
runtime.any.system.text.encoding@4.3.0
runtime.any.system.threading.tasks@4.3.0
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system.net.http@4.3.0
runtime.native.system.security.cryptography.apple@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.unix.microsoft.win32.primitives@4.3.0
runtime.unix.system.diagnostics.debug@4.3.0
runtime.unix.system.io.filesystem@4.3.0
runtime.unix.system.net.primitives@4.3.0
runtime.unix.system.private.uri@4.3.0
runtime.unix.system.runtime.extensions@4.3.0
semanticversion@2.1.0
semanticversioning@2.0.2
serilog.sinks.console@5.0.1
serilog@3.1.1
serilogtracelistener@3.2.1-dev-00011
spectre.console@0.46.0
spectre.console@0.48.0
streamjsonrpc@2.8.28
system.buffers@4.3.0
system.buffers@4.5.1
system.codedom@5.0.0
system.collections.concurrent@4.3.0
system.collections.immutable@5.0.0
system.collections.immutable@7.0.0
system.collections@4.3.0
system.configuration.configurationmanager@4.4.0
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@5.0.1
system.diagnostics.diagnosticsource@7.0.0
system.diagnostics.tracing@4.3.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.abstractions.testinghelpers@20.0.4
system.io.abstractions@20.0.4
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io.pipelines@5.0.1
system.io@4.3.0
system.linq@4.3.0
system.management@5.0.0
system.memory@4.5.1
system.memory@4.5.3
system.memory@4.5.4
system.memory@4.5.5
system.net.http@4.3.4
system.net.primitives@4.3.0
system.net.websockets@4.3.0
system.numerics.vectors@4.4.0
system.private.uri@4.3.0
system.reflection.emit.ilgeneration@4.6.0
system.reflection.emit.ilgeneration@4.7.0
system.reflection.emit.lightweight@4.6.0
system.reflection.emit@4.7.0
system.reflection.metadata@1.6.0
system.reflection.metadata@5.0.0
system.reflection.primitives@4.3.0
system.reflection@4.3.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@4.5.2
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@4.7.1
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.3.0
system.runtime@4.3.1
system.security.accesscontrol@5.0.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.x509certificates@4.3.0
system.security.principal.windows@5.0.0
system.text.encoding.codepages@4.5.1
system.text.encoding.extensions@4.3.0
system.text.encoding@4.3.0
system.threading.tasks.dataflow@5.0.0
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.3.0
system.threading@4.3.0
testableio.system.io.abstractions.testinghelpers@20.0.4
testableio.system.io.abstractions.wrappers@20.0.4
testableio.system.io.abstractions@20.0.4
thoth.json.net@8.0.0
"

inherit check-reqs dotnet-pkg

DESCRIPTION="FSharp source code formatter"
HOMEPAGE="https://fsprojects.github.io/fantomas/
	https://github.com/fsprojects/fantomas/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fsprojects/${PN}.git"
else
	SRC_URI="https://github.com/fsprojects/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

FCS_COMMIT="050271d631956a4e0d0484a583d38236b727a46d"
SRC_URI+="
	https://github.com/dotnet/fsharp/archive/${FCS_COMMIT}.tar.gz
		-> fsharp-${FCS_COMMIT}.tar.gz
"

LICENSE="MIT"
SLOT="0"

CHECKREQS_DISK_BUILD="2G"
DOTNET_PKG_PROJECTS=(
	src/Fantomas/Fantomas.fsproj
)
DOTNET_PKG_BAD_PROJECTS=(
	src/Fantomas.Benchmarks/Fantomas.Benchmarks.fsproj
)
DOTNET_PKG_RESTORE_EXTRA_ARGS=(
	--force-evaluate
)

DOCS=( CHANGELOG.md README.md docs/docs/{contributors,end-users} )

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

	# Reimplementing "dotnet build.fsx -p Init" in shell.
	mkdir -p "${S}/.deps" || die
	ln -s "${WORKDIR}/fsharp-${FCS_COMMIT}" "${S}/.deps/${FCS_COMMIT}" || die
	find "${S}/.deps/${FCS_COMMIT}/src" -type f \
		 -exec sed -e "s|FSharp.Compiler|Fantomas.FCS|g" -i {} + || die
}

src_configure() {
	dotnet-pkg-base_restore_tools
	dotnet-pkg_src_configure
}

src_test() {
	local -a test_projects=(
		Fantomas.Core.Tests
		Fantomas.Tests
	)
	local test_project
	for test_project in "${test_projects[@]}" ; do
		dotnet-pkg-base_test "src/${test_project}/${test_project}.fsproj" \
			-p:RollForward=Major
	done
}
