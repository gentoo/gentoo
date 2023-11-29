# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

DOTNET_PKG_COMPAT=6.0
NUGETS="
boogie.abstractinterpretation@2.16.8
boogie.basetypes@2.16.8
boogie.codecontractsextender@2.16.8
boogie.concurrency@2.16.8
boogie.core@2.16.8
boogie.executionengine@2.16.8
boogie.graph@2.16.8
boogie.houdini@2.16.8
boogie.model@2.16.8
boogie.provers.smtlib@2.16.8
boogie.vcexpr@2.16.8
boogie.vcgeneration@2.16.8
castle.core@4.4.0
commandlineparser@2.8.0
commandlineparser@2.9.1
coverlet.collector@3.2.0
diffplex@1.7.0
humanizer.core@2.2.0
jetbrains.annotations@2021.1.0
mediatr@8.1.0
microsoft.bcl.asyncinterfaces@1.1.1
microsoft.bcl.asyncinterfaces@5.0.0
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.build.framework@17.0.0
microsoft.build.locator@1.4.1
microsoft.build.tasks.core@17.0.0
microsoft.build.utilities.core@17.0.0
microsoft.build@17.0.0
microsoft.codeanalysis.analyzers@3.0.0
microsoft.codeanalysis.analyzers@3.3.2
microsoft.codeanalysis.common@3.7.0
microsoft.codeanalysis.common@4.0.1
microsoft.codeanalysis.csharp.workspaces@4.0.1
microsoft.codeanalysis.csharp@3.7.0
microsoft.codeanalysis.csharp@4.0.1
microsoft.codeanalysis.visualbasic.workspaces@4.0.1
microsoft.codeanalysis.visualbasic@4.0.1
microsoft.codeanalysis.workspaces.common@4.0.1
microsoft.codeanalysis.workspaces.msbuild@4.0.1
microsoft.codeanalysis@4.0.1
microsoft.codecoverage@16.11.0
microsoft.codecoverage@16.9.4
microsoft.codecoverage@17.1.0
microsoft.csharp@4.0.1
microsoft.dotnet.platformabstractions@2.0.4
microsoft.extensions.configuration.abstractions@2.0.0
microsoft.extensions.configuration.abstractions@5.0.0
microsoft.extensions.configuration.binder@2.0.0
microsoft.extensions.configuration.binder@5.0.0
microsoft.extensions.configuration.commandline@5.0.0
microsoft.extensions.configuration.fileextensions@5.0.0
microsoft.extensions.configuration.json@5.0.0
microsoft.extensions.configuration@2.0.0
microsoft.extensions.configuration@5.0.0
microsoft.extensions.dependencyinjection.abstractions@2.0.0
microsoft.extensions.dependencyinjection.abstractions@5.0.0
microsoft.extensions.dependencyinjection@2.0.0
microsoft.extensions.dependencyinjection@5.0.0
microsoft.extensions.dependencymodel@2.0.4
microsoft.extensions.fileproviders.abstractions@5.0.0
microsoft.extensions.fileproviders.physical@5.0.0
microsoft.extensions.filesystemglobbing@5.0.0
microsoft.extensions.logging.abstractions@2.0.0
microsoft.extensions.logging.abstractions@5.0.0
microsoft.extensions.logging.configuration@5.0.0
microsoft.extensions.logging.console@5.0.0
microsoft.extensions.logging@2.0.0
microsoft.extensions.logging@5.0.0
microsoft.extensions.options.configurationextensions@2.0.0
microsoft.extensions.options.configurationextensions@5.0.0
microsoft.extensions.options@2.0.0
microsoft.extensions.options@5.0.0
microsoft.extensions.primitives@2.0.0
microsoft.extensions.primitives@5.0.0
microsoft.net.stringtools@1.0.0
microsoft.net.test.sdk@16.11.0
microsoft.net.test.sdk@16.9.4
microsoft.net.test.sdk@17.1.0
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@2.1.2
microsoft.netcore.platforms@3.0.0
microsoft.netcore.platforms@3.1.0
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.testplatform.extensions.trxlogger@17.0.0
microsoft.testplatform.objectmodel@16.11.0
microsoft.testplatform.objectmodel@16.9.4
microsoft.testplatform.objectmodel@17.0.0
microsoft.testplatform.objectmodel@17.1.0
microsoft.testplatform.testhost@16.11.0
microsoft.testplatform.testhost@16.9.4
microsoft.testplatform.testhost@17.1.0
microsoft.visualstudio.threading.analyzers@16.7.56
microsoft.visualstudio.threading@16.7.56
microsoft.visualstudio.validation@15.5.31
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@4.3.0
microsoft.win32.registry@4.6.0
microsoft.win32.systemevents@4.7.0
microsoft.win32.systemevents@6.0.0
moq@4.16.1
nerdbank.streams@2.6.81
netstandard.library@1.6.1
netstandard.library@2.0.3
newtonsoft.json@11.0.2
newtonsoft.json@13.0.1
newtonsoft.json@9.0.1
nuget.frameworks@5.0.0
nuget.frameworks@5.11.0
omnisharp.extensions.jsonrpc.generators@0.19.5
omnisharp.extensions.jsonrpc.testing@0.19.5
omnisharp.extensions.jsonrpc@0.19.5
omnisharp.extensions.languageclient@0.19.5
omnisharp.extensions.languageprotocol.testing@0.19.5
omnisharp.extensions.languageprotocol@0.19.5
omnisharp.extensions.languageserver.shared@0.19.5
omnisharp.extensions.languageserver@0.19.5
rangetree@3.0.1
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
serilog.extensions.logging@3.0.1
serilog.settings.configuration@3.1.0
serilog.sinks.debug@2.0.0
serilog.sinks.file@5.0.0
serilog.sinks.inmemory@0.11.0
serilog@2.10.0
serilog@2.12.0
system.appcontext@4.1.0
system.appcontext@4.3.0
system.buffers@4.3.0
system.buffers@4.4.0
system.codedom@4.4.0
system.collections.concurrent@4.3.0
system.collections.immutable@1.5.0
system.collections.immutable@1.7.0
system.collections.immutable@1.7.1
system.collections.immutable@5.0.0
system.collections.nongeneric@4.0.1
system.collections.nongeneric@4.3.0
system.collections.specialized@4.0.1
system.collections.specialized@4.3.0
system.collections@4.0.11
system.collections@4.3.0
system.commandline@2.0.0-beta4.22272.1
system.componentmodel.primitives@4.3.0
system.componentmodel.typeconverter@4.3.0
system.componentmodel@4.3.0
system.composition.attributedmodel@1.0.31
system.composition.convention@1.0.31
system.composition.hosting@1.0.31
system.composition.runtime@1.0.31
system.composition.typedparts@1.0.31
system.composition@1.0.31
system.configuration.configurationmanager@4.7.0
system.configuration.configurationmanager@6.0.0
system.console@4.3.0
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.tools@4.0.1
system.diagnostics.tools@4.3.0
system.diagnostics.tracesource@4.3.0
system.diagnostics.tracing@4.3.0
system.drawing.common@4.7.0
system.drawing.common@6.0.0
system.dynamic.runtime@4.0.11
system.dynamic.runtime@4.3.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.0.1
system.globalization.extensions@4.3.0
system.globalization@4.0.11
system.globalization@4.3.0
system.io.compression.zipfile@4.3.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.0.1
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.0.1
system.io.filesystem@4.3.0
system.io.pipelines@4.7.3
system.io.pipelines@5.0.1
system.io@4.1.0
system.io@4.3.0
system.linq.async@6.0.1
system.linq.expressions@4.1.0
system.linq.expressions@4.3.0
system.linq@4.1.0
system.linq@4.3.0
system.memory@4.5.3
system.memory@4.5.4
system.net.http@4.3.0
system.net.nameresolution@4.3.0
system.net.primitives@4.3.0
system.net.sockets@4.3.0
system.net.websockets@4.3.0
system.numerics.vectors@4.4.0
system.objectmodel@4.0.12
system.objectmodel@4.3.0
system.private.uri@4.3.0
system.reactive@4.4.1
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
system.runtime.caching@6.0.0
system.runtime.compilerservices.unsafe@4.4.0
system.runtime.compilerservices.unsafe@4.5.2
system.runtime.compilerservices.unsafe@4.7.0
system.runtime.compilerservices.unsafe@4.7.1
system.runtime.compilerservices.unsafe@5.0.0
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
system.security.accesscontrol@4.6.0
system.security.accesscontrol@4.7.0
system.security.accesscontrol@6.0.0
system.security.claims@4.3.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.cng@4.7.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.pkcs@4.7.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@4.7.0
system.security.cryptography.protecteddata@6.0.0
system.security.cryptography.x509certificates@4.3.0
system.security.cryptography.xml@4.7.0
system.security.permissions@4.7.0
system.security.permissions@6.0.0
system.security.principal.windows@4.3.0
system.security.principal.windows@4.6.0
system.security.principal.windows@4.7.0
system.security.principal@4.3.0
system.text.encoding.codepages@4.0.1
system.text.encoding.codepages@4.5.1
system.text.encoding.extensions@4.0.11
system.text.encoding.extensions@4.3.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.text.json@4.7.0
system.text.json@5.0.2
system.text.regularexpressions@4.1.0
system.text.regularexpressions@4.3.0
system.threading.channels@4.7.1
system.threading.tasks.dataflow@4.9.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.extensions@4.5.3
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.threadpool@4.3.0
system.threading.timer@4.3.0
system.threading@4.0.11
system.threading@4.3.0
system.windows.extensions@4.7.0
system.windows.extensions@6.0.0
system.xml.readerwriter@4.0.11
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.0.11
system.xml.xdocument@4.3.0
system.xml.xmldocument@4.3.0
tomlyn@0.16.2
validation@2.4.18
xunit.abstractions@2.0.2
xunit.abstractions@2.0.3
xunit.analyzers@0.10.0
xunit.analyzers@1.0.0
xunit.assert@2.4.1
xunit.assert@2.4.2
xunit.assertmessages@2.4.0
xunit.core@2.4.1
xunit.core@2.4.2
xunit.extensibility.core@2.4.0
xunit.extensibility.core@2.4.1
xunit.extensibility.core@2.4.2
xunit.extensibility.execution@2.4.0
xunit.extensibility.execution@2.4.1
xunit.extensibility.execution@2.4.2
xunit.runner.visualstudio@2.4.3
xunit.runner.visualstudio@2.5.1
xunit.skippablefact@1.4.8
xunit@2.4.1
xunit@2.4.2
"

inherit check-reqs dotnet-pkg edo java-pkg-2 multiprocessing python-any-r1

DESCRIPTION="Dafny is a verification-aware programming language"
HOMEPAGE="https://dafny.org/
	https://github.com/dafny-lang/dafny/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/dafny-lang/${PN}.git"
else
	SRC_URI="https://github.com/dafny-lang/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64"
fi

SRC_URI+="
	${NUGET_URIS}
	test? ( https://registry.npmjs.org/bignumber.js/-/bignumber.js-9.1.2.tgz )
"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!dev-lang/dafny-bin
	>=virtual/jre-1.8:*
	sci-mathematics/z3
"
DEPEND=">=virtual/jdk-1.8:*"
BDEPEND="
	${RDEPEND}
	dev-dotnet/coco
	test? (
		${PYTHON_DEPS}
		dev-lang/boogie
		dev-lang/go
		dev-python/OutputCheck
		dev-python/lit
		net-libs/nodejs[npm]
	)
"

CHECKREQS_DISK_BUILD="2G"
DOTNET_PKG_PROJECTS=(
	"${S}/Source/Dafny/Dafny.csproj"
	"${S}/Source/TestDafny/TestDafny.csproj"
)
PATCHES=(
	"${FILESDIR}/${PN}-3.12.0-DafnyCore-csproj.patch"
	"${FILESDIR}/${PN}-3.12.0-DafnyRuntime-csproj.patch"
	"${FILESDIR}/${PN}-4.1.0-lit.patch"
	"${FILESDIR}/${PN}-4.2.0-lit-use-system-boogie.patch"
	"${FILESDIR}/${PN}-4.3.0-net6.0-upgrade.patch"
)

DOCS=(
	CODE_OF_CONDUCT.md
	CONTRIBUTING.md
	NOTICES.txt
	README.md
	RELEASE_NOTES.md
	docs/DafnyCheatsheet.pdf
	docs/DafnyRef/out/DafnyRef.pdf
)

pkg_setup() {
	# Clean the environment.
	unset NPM_CONFIG_USERCONFIG

	if [[ -n "${_JAVA_OPTIONS}" ]] ; then
		ewarn "Cleaning _JAVA_OPTIONS because when set compile and test may fail"

		unset _JAVA_OPTIONS
	fi

	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
	java-pkg-2_pkg_setup

	# We need to set up Python only for running test tools (called via lit).
	if use test ; then
		python-any-r1_pkg_setup
	fi
}

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n ${EGIT_REPO_URI} ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	# Remove bad tests (recursive).
	local -a bad_tests
	bad_tests=(
		# Following tests fail:
		DafnyTestGeneration/TestGeneration.dfy
		DafnyTests/TestAttribute.dfy
		auditor/TestAuditor.dfy
		benchmarks/sequence-race/SequenceRace.dfy
		dafny0/Fuel.dfy
		dafny0/JavaUseRuntimeLib.dfy
		dafny0/Stdin.dfy
		examples/Simple_compiler/Compiler.dfy
		separate-verification/assumptions.dfy
		server/counterexample_none.transcript
		unicodechars/comp/Arrays.dfy
		unicodechars/comp/Collections.dfy
		unicodechars/comp/Comprehensions.dfy
		unicodechars/expectations/Expect.dfy

		# Following tests are very slow:
		comp/Arrays.dfy
		comp/BranchCoverage.dfy
		comp/Collections.dfy
		comp/CompileWithArguments.dfy
		comp/Comprehensions.dfy
		comp/Extern.dfy
		comp/MainMethod.dfy
		comp/Print.dfy
		comp/TailRecursion.dfy
		comp/UnicodeStrings.dfy
		comp/Uninitialized.dfy
		comp/compile1quiet/CompileRunQuietly.dfy
		comp/compile3/JustRun.dfy
		comp/manualcompile/ManualCompile.dfy
		concurrency/06-ThreadOwnership.dfy
		concurrency/07-CounterThreadOwnership.dfy
		concurrency/09-CounterNoStateMachine.dfy
		concurrency/10-SequenceInvariant.dfy
		concurrency/11-MutexGuard2.dfy
		concurrency/12-MutexLifetime-short.dfy
		dafny0/RlimitMultiplier.dfy
		dafny0/Strings.dfy
		dafny1/SchorrWaite.dfy
		dafny2/MinWindowMax.dfy
		dafny2/SmallestMissingNumber-functional.dfy
		dafny2/SnapshotableTrees.dfy
		dafny4/UnionFind.dfy
		dafny4/git-issue250.dfy
		expectations/Expect.dfy
		git-issues/git-issue-356.dfy
		git-issues/git-issue-Main0.dfy
		git-issues/git-issue-Main4.dfy
		git-issues/git-issue-MainE.dfy
		hofs/VectorUpdate.dfy
		metatests/ConsistentWhenSupported.dfy
		separate-verification/app.dfy
		traits/TraitCompile.dfy
		unicodechars/comp/CompileWithArguments.dfy
	)
	local bad_test
	for bad_test in "${bad_tests[@]}" ; do
		rm -r "${S}/Test/${bad_test}"					\
			|| die "failed to remove test ${bad_test}"
	done

	# Update lit's "lit.site.cfg" file.
	local dotnet_exec="${DOTNET_PKG_EXECUTABLE} exec ${DOTNET_PKG_OUTPUT}"
	local lit_config="${S}/Test/lit.site.cfg"
	sed "/^defaultDafnyExecutable/s|=.*|= '${dotnet_exec}/Dafny.dll '|" \
		-i "${lit_config}" || die "failed to update ${lit_config}"
	sed "/^dafnyExecutable/s|=.*|= '${dotnet_exec}/Dafny.dll '|" \
		-i "${lit_config}" || die "failed to update ${lit_config}"
	sed "/^testDafnyExecutableCompiler/s|=.*|= '${dotnet_exec}/TestDafny.dll for-each-compiler '|" \
		-i "${lit_config}" || die "failed to update ${lit_config}"
	sed "/^testDafnyExecutableResolver/s|=.*|= '${dotnet_exec}/TestDafny.dll for-each-resolver '|" \
		-i "${lit_config}" || die "failed to update ${lit_config}"
	sed "/^defaultServerExecutable/s|=.*|= '${dotnet_exec}/DafnyServer.dll'|" \
		-i "${lit_config}" || die "failed to update ${lit_config}"
	sed "/^serverExecutable/s|=.*|= '${dotnet_exec}/DafnyServer.dll'|" \
		-i "${lit_config}" || die "failed to update ${lit_config}"

	dotnet-pkg_src_prepare
	java-pkg-2_src_prepare
}

src_compile () {
	# In 4.3.0 the DafnyRuntime JAR has mismatched version, by mistake?

	einfo "Building dependency-less DafnyRuntime JAR."
	local dafny_runtime_java="${S}/Source/DafnyRuntime/DafnyRuntimeJava/"
	mkdir -p "${dafny_runtime_java}/build/libs/" || die
	pushd "${dafny_runtime_java}/build" || die
	ejavac -d ./ "${dafny_runtime_java}/src/main/java/dafny"/*.java
	edo jar cvf "DafnyRuntime-4.2.0.jar" dafny/*
	cp "DafnyRuntime-4.2.0.jar" "${dafny_runtime_java}/build/libs/" || die
	popd || die

	# Build main dotnet package.
	dotnet-pkg_src_compile
}

src_test() {
	# The test "dafny0/DafnyLibClient.dfy" expects to use "DafnyRuntime.dll"
	# from the "Binaries" directory.
	ln -s "${DOTNET_PKG_OUTPUT}/DafnyRuntime.dll" "${S}/Binaries/" || die

	einfo "Installing bignumber.js package required for tests using NodeJS."
	local -a npm_opts
	npm_opts=(
		--audit false
		--color false
		--foreground-scripts
		--offline
		--progress false
		--verbose
	)
	edob npm "${npm_opts[@]}" install "${DISTDIR}/bignumber.js-9.1.2.tgz"

	einfo "Starting tests using the lit test tool."
	local -a lit_opts
	lit_opts=(
		--order=lexical
		--time-tests
		--verbose
		--workers="$(makeopts_jobs)"
	)
	edob lit "${lit_opts[@]}" "${S}/Test"
}

src_install() {
	dotnet-pkg-base_install

	local -a dafny_exes
	dafny_exes=(
		Dafny
		DafnyDriver
		DafnyLanguageServer
		DafnyServer
		TestDafny
	)
	local dafny_exe
	for dafny_exe in "${dafny_exes[@]}" ; do
		dotnet-pkg-base_dolauncher "/usr/share/${P}/${dafny_exe}" "${dafny_exe}"
	done

	dosym -r /usr/bin/Dafny /usr/bin/dafny
	dosym -r /usr/bin/DafnyServer /usr/bin/dafny-server

	einstalldocs
}
