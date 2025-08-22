# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="8.0"

# Required tools are on top, they are listed in ".config/dotnet-tools.json".
NUGETS="
dotnet-fsharplint@0.19.2
fantomas@7.0.1
fsdocs-tool@21.0.0-beta-002
fsharp-analyzers@0.25.0

argu@6.2.4
benchmarkdotnet.annotations@0.14.0
benchmarkdotnet@0.14.0
cliwrap@3.6.4
cliwrap@3.6.7
commandlineparser@2.9.1
dotnet.reproduciblebuilds@1.1.1
editorconfig@0.15.0
fable.core@3.1.6
fparsec@1.1.1
fscheck@2.16.5
fsharp.analyzers.build@0.3.0
fsharp.core@4.3.4
fsharp.core@5.0.1
fsharp.core@6.0.0
fsharp.core@6.0.2
fsharp.core@8.0.100
fsharp.core@9.0.100
fsharp.data.csv.core@6.3.0
fsharp.data.html.core@6.3.0
fsharp.data.http@6.3.0
fsharp.data.json.core@6.3.0
fsharp.data.runtime.utilities@6.3.0
fsharp.data.worldbank.core@6.3.0
fsharp.data.xml.core@6.3.0
fsharp.data@6.3.0
fslexyacc.runtime@11.3.0
fslexyacc@11.3.0
fsunit@6.0.1
fun.build@1.0.3
fun.result@2.0.9
g-research.fsharp.analyzers@0.9.3
gee.external.capstone@2.3.0
humanizer.core@2.14.1
iced@1.17.0
ignore@0.2.1
ionide.analyzers@0.9.0
ionide.keepachangelog.tasks@0.1.8
ionide.keepachangelog@0.1.8
messagepack.annotations@2.5.187
messagepack@2.5.187
microsoft.bcl.asyncinterfaces@1.1.0
microsoft.bcl.asyncinterfaces@8.0.0
microsoft.build.tasks.git@1.1.1
microsoft.codeanalysis.analyzers@3.3.3
microsoft.codeanalysis.common@4.1.0
microsoft.codeanalysis.csharp@4.1.0
microsoft.codecoverage@17.12.0
microsoft.diagnostics.netcore.client@0.2.251802
microsoft.diagnostics.runtime@2.2.332302
microsoft.diagnostics.tracing.traceevent@3.1.8
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.configuration.abstractions@2.1.1
microsoft.extensions.configuration.binder@2.1.1
microsoft.extensions.configuration@2.1.1
microsoft.extensions.dependencyinjection.abstractions@2.1.1
microsoft.extensions.logging.abstractions@2.1.1
microsoft.extensions.logging@2.1.1
microsoft.extensions.options@2.1.1
microsoft.extensions.primitives@2.1.1
microsoft.net.stringtools@17.6.3
microsoft.net.test.sdk@17.12.0
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.platforms@2.0.0
microsoft.netcore.platforms@2.1.2
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.1.3
microsoft.sourcelink.azurerepos.git@1.1.1
microsoft.sourcelink.bitbucket.git@1.1.1
microsoft.sourcelink.common@1.1.1
microsoft.sourcelink.github@1.1.1
microsoft.sourcelink.gitlab@1.1.1
microsoft.testplatform.objectmodel@17.12.0
microsoft.testplatform.testhost@17.12.0
microsoft.visualstudio.threading.analyzers@17.10.48
microsoft.visualstudio.threading@17.10.48
microsoft.visualstudio.validation@17.8.8
microsoft.win32.registry@4.4.0
microsoft.win32.registry@5.0.0
nerdbank.streams@2.11.74
netstandard.library@2.0.3
newtonsoft.json@13.0.3
nunit3testadapter@4.6.0
nunit@4.2.2
perfolizer@0.3.17
runtime.any.system.runtime@4.3.0
runtime.native.system@4.3.0
runtime.unix.system.private.uri@4.3.0
semanticversion@2.1.0
semanticversioning@2.0.2
serilog.sinks.console@6.0.0
serilog@4.1.0
serilogtracelistener@3.2.1-dev-00011
spectre.console@0.46.0
spectre.console@0.49.1
streamjsonrpc@2.20.20
system.buffers@4.5.1
system.buffers@4.6.0
system.codedom@5.0.0
system.collections.immutable@8.0.0
system.configuration.configurationmanager@4.4.0
system.diagnostics.diagnosticsource@8.0.1
system.io.abstractions.testinghelpers@21.1.3
system.io.abstractions@21.1.3
system.io.pipelines@8.0.0
system.management@5.0.0
system.memory@4.5.5
system.memory@4.6.0
system.numerics.vectors@4.6.0
system.private.uri@4.3.0
system.reflection.emit.ilgeneration@4.7.0
system.reflection.emit.lightweight@4.7.0
system.reflection.emit@4.7.0
system.reflection.metadata@1.6.0
system.reflection.metadata@5.0.0
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.compilerservices.unsafe@6.1.0
system.runtime@4.3.1
system.security.accesscontrol@4.4.0
system.security.accesscontrol@5.0.0
system.security.cryptography.protecteddata@4.4.0
system.security.principal.windows@4.4.0
system.security.principal.windows@5.0.0
system.text.encoding.codepages@4.5.1
system.text.encodings.web@8.0.0
system.text.json@8.0.5
system.threading.tasks.dataflow@6.0.0
system.threading.tasks.extensions@4.5.4
testableio.system.io.abstractions.testinghelpers@21.1.3
testableio.system.io.abstractions.wrappers@21.1.3
testableio.system.io.abstractions@21.1.3
thoth.json.net@12.0.0
"

inherit check-reqs dotnet-pkg

DESCRIPTION="FSharp source code formatter"
HOMEPAGE="https://fsprojects.github.io/fantomas/
	https://github.com/fsprojects/fantomas/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fsprojects/${PN}"
else
	SRC_URI="https://github.com/fsprojects/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

# See file "Directory.Build.props" -> tag "FCSCommitHash".
FCS_COMMIT="e668b90e3c087e5fba8a855e502af60bf35be45e"
SRC_URI+="
	https://github.com/dotnet/fsharp/archive/${FCS_COMMIT}.tar.gz
		-> fsharp-${FCS_COMMIT}.gh.tar.gz
"

LICENSE="Apache-2.0 MIT"
SLOT="0"

PATCHES=( "${FILESDIR}/fantomas-7.0.0-directory-build-props.patch" )

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
		dotnet-pkg-base_test "${S}/src/${test_project}" -p:RollForward=Major
	done
}
