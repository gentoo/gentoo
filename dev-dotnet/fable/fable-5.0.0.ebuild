# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
blackfox.commandline@1.0.0
easybuild.packagereleasenotes.tasks@2.1.0
easybuild.tools@7.0.0
expecto@10.2.3
fable.ast@5.0.0-rc.3
fable.browser.blob@1.1.4
fable.browser.dom@2.4.4
fable.browser.event@1.4.4
fable.browser.event@1.4.5
fable.browser.gamepad@1.0.3
fable.browser.webstorage@1.0.4
fable.core@3.1.6
fable.core@4.5.0
fable.fluentui@1.0.0
fable.jester@0.33.0
fable.jsonprovider@1.1.1
fable.node@1.0.2
fable.promise@2.2.2
fable.python@4.24.0
fable.react.types@18.3.0
fable.react.types@18.4.0
fable.react@9.4.0
fable.reactdom.types@18.2.0
fable.reacttestinglibrary@0.33.0
fake.core.context@6.1.4
fake.core.environment@6.1.4
fake.core.fakevar@6.1.4
fake.core.string@6.1.4
fake.core.trace@6.1.4
fake.io.filesystem@6.1.4
feliz.compilerplugins@3.1.0
feliz@3.2.0
fsharp.analyzers.build@0.5.0
fsharp.analyzers.sdk@0.36.0
fsharp.compiler.service@43.10.101
fsharp.core@10.0.107
fsharp.core@4.7.0
fsharp.core@4.7.2
fsharp.core@6.0.2
fsharp.core@7.0.200
fsharp.data.adaptive@1.2.26
fsharp.systemtextjson@1.4.36
fsharp.umx@1.1.0
fstoolkit.errorhandling@5.2.0
g-research.fsharp.analyzers@0.22.0
ionide.analyzers@0.15.0
mcmaster.netcore.plugins@2.0.0
microsoft.build.tasks.git@10.0.202
microsoft.codecoverage@18.4.0
microsoft.extensions.configuration.abstractions@10.0.6
microsoft.extensions.configuration.binder@10.0.6
microsoft.extensions.configuration@10.0.6
microsoft.extensions.dependencyinjection.abstractions@10.0.6
microsoft.extensions.dependencyinjection@10.0.6
microsoft.extensions.filesystemglobbing@10.0.6
microsoft.extensions.logging.abstractions@10.0.6
microsoft.extensions.logging.abstractions@6.0.0
microsoft.extensions.logging.configuration@10.0.6
microsoft.extensions.logging.console@10.0.6
microsoft.extensions.logging@10.0.6
microsoft.extensions.options.configurationextensions@10.0.6
microsoft.extensions.options@10.0.6
microsoft.extensions.primitives@10.0.6
microsoft.extensions.primitives@5.0.1
microsoft.net.test.sdk@18.4.0
microsoft.netcore.platforms@1.1.0
microsoft.sourcelink.common@10.0.202
microsoft.sourcelink.github@10.0.202
microsoft.testplatform.objectmodel@18.4.0
microsoft.testplatform.testhost@18.4.0
mono.cecil@0.11.4
netstandard.library@2.0.3
newtonsoft.json@13.0.1
newtonsoft.json@13.0.3
semver@3.0.0
simpleexec@13.0.0
source-map-sharp@1.0.9
system.buffers@4.6.1
system.io.hashing@10.0.6
system.memory@4.6.3
system.numerics.vectors@4.6.1
system.runtime.compilerservices.unsafe@6.1.2
thoth.json.core@0.7.0
thoth.json.net@12.0.0
thoth.json.python@0.5.1
xunit.abstractions@2.0.3
xunit.analyzers@1.18.0
xunit.assert@2.9.3
xunit.core@2.9.3
xunit.extensibility.core@2.9.3
xunit.extensibility.execution@2.9.3
xunit.runner.visualstudio@3.1.5
xunit@2.9.3
"

inherit check-reqs dotnet-pkg

DESCRIPTION="F# to JavaScript, TypeScript, Python, Rust and Dart Compiler"
HOMEPAGE="http://fable.io/
	https://github.com/fable-compiler/fable/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fable-compiler/${PN}"
else
	SRC_URI="https://github.com/fable-compiler/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${P^}"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0 MIT"
SLOT="0"

CHECKREQS_DISK_BUILD="2G"
DOTNET_PKG_PROJECTS=(
	src/Fable.Cli/Fable.Cli.fsproj
)
DOTNET_PKG_BAD_PROJECTS=(
	src/quicktest/QuickTest.fsproj
	tests/Js/Main/Fable.Tests.fsproj
	tests/Rust/Fable.Tests.Rust.fsproj
)

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
	rm ./Fable.Standalone.sln || die

	if use debug ; then
		DOTNET_PKG_BAD_PROJECTS+=(
			# Seems to hang but in reality it fails with USE="debug", bug #922684
			tests/Python/Fable.Tests.Python.fsproj
		)
	fi

	dotnet-pkg_src_prepare
}
