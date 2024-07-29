# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

DOTNET_PKG_COMPAT=6.0
NUGETS="
boogie.abstractinterpretation@3.1.6
boogie.basetypes@3.1.6
boogie.codecontractsextender@3.1.6
boogie.concurrency@3.1.6
boogie.core@3.1.6
boogie.executionengine@3.1.6
boogie.graph@3.1.6
boogie.houdini@3.1.6
boogie.model@3.1.6
boogie.provers.leanauto@3.1.6
boogie.provers.smtlib@3.1.6
boogie.vcexpr@3.1.6
boogie.vcgeneration@3.1.6
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
microsoft.netframework.referenceassemblies.net452@1.0.2
microsoft.netframework.referenceassemblies@1.0.2
microsoft.testplatform.extensions.trxlogger@17.9.0
microsoft.testplatform.objectmodel@16.11.0
microsoft.testplatform.objectmodel@16.9.4
microsoft.testplatform.objectmodel@17.1.0
microsoft.testplatform.objectmodel@17.9.0
microsoft.testplatform.testhost@16.11.0
microsoft.testplatform.testhost@16.9.4
microsoft.testplatform.testhost@17.1.0
microsoft.testplatform.testhost@17.9.0
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
system.collections.nongeneric@4.3.0
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

inherit check-reqs dotnet-pkg edo java-pkg-2 multiprocessing python-any-r1 optfeature

DESCRIPTION="Dafny is a verification-aware programming language"
HOMEPAGE="https://dafny.org/
	https://github.com/dafny-lang/dafny/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/dafny-lang/${PN}.git"
else
	SRC_URI="https://github.com/dafny-lang/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
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
DEPEND="
	>=virtual/jdk-1.8:*
"
BDEPEND="
	${RDEPEND}
	dev-dotnet/coco
	test? (
		${PYTHON_DEPS}
		>=dev-lang/boogie-3.1.6
		dev-go/go-tools
		dev-lang/go
		dev-python/OutputCheck
		dev-python/lit
		dev-python/psutil
		net-libs/nodejs[npm]
	)
"

CHECKREQS_DISK_BUILD="2G"
DOTNET_PKG_PROJECTS=( "${S}/Source/Dafny/Dafny.csproj" )

PATCHES=(
	"${FILESDIR}/${PN}-3.12.0-DafnyCore-csproj.patch"
	"${FILESDIR}/${PN}-3.12.0-DafnyRuntime-csproj.patch"
	"${FILESDIR}/${PN}-4.5.0-lit-config.patch"
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

TEST_S="${S}/Source/IntegrationTests/TestFiles/LitTests/LitTest"

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
	# Unpack manually to skip additional archives, eg "bignumber.js".

	nuget_link-system-nugets
	nuget_link-nuget-archives

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	else
		unpack "${P}.tar.gz"
	fi
}

src_prepare() {
	# Using "for-each-compiler" will fail because of Cargo requiring network access.
	while read -r test_file ; do
		if grep "// RUN: %testDafnyForEachCompiler" "${test_file}" >/dev/null ; then
			rm "${test_file}" || die "failed to remove test ${bad_test}"
		fi
	done < <(find "${TEST_S}" -type f -name "*.dfy")

	# Remove bad tests (recursive).
	local -a bad_tests=(
		# Unsupported test build (and those that need network access):
		comp/rust

		# Following tests fail:
		VSComp2010/Problem2-Invert.dfy
		ast/function.dfy
		auditor/TestAuditor.dfy
		benchmarks/sequence-race/SequenceRace.dfy
		c++/extern.dfy
		c++/functions.dfy
		c++/tuple.dfy
		cli/projectFile/projectFile.dfy
		cli/runArgument.dfy
		comp/CoverageReport.dfy
		comp/Libraries/consumer.dfy
		concurrency/06-ThreadOwnership.dfy
		dafny0/Fuel.legacy.dfy
		dafny0/Stdin.dfy
		dafny1/MoreInduction.dfy
		dafny4/Lucas-up.legacy.dfy
		dafny4/Primes.dfy
		doofiles/allowWarningsDoo.dfy
		doofiles/semanticOptions.dfy
		doofiles/standardLibraryOptionMismatch.dfy
		examples/Simple_compiler/Compiler.dfy
		exports/ExportRefinement.dfy
		exports/IncludeSkipTranslate.dfy
		git-issues/git-issue-2026.dfy
		git-issues/git-issue-2299.dfy
		git-issues/git-issue-2301.dfy
		git-issues/git-issue-3855.dfy
		git-issues/git-issue-505.dfy
		gomodule/multimodule/DerivedModule.dfy
		gomodule/singlemodule/dafnysource/helloworld.dfy
		lambdas/MatrixAssoc.dfy
		metatests/InconsistentCompilerBehavior.dfy
		metatests/TestBeyondVerifierExpect.dfy
		pythonmodule/multimodule/DerivedModule.dfy
		pythonmodule/nestedmodule/SomeTestModule.dfy
		pythonmodule/singlemodule/dafnysource/helloworld.dfy
		separate-verification/assumptions.dfy
		server/counterexample_none.transcript
		triggers/emptyTrigger.dfy
		unicodecharsFalse/DafnyTests/RunAllTestsOption.dfy
		unicodecharsFalse/comp/Print.dfy
		verification/isolate-assertions.dfy
		verification/outOfResourceAndIsolateAssertions.dfy
		verification/progress.dfy
		vstte2012/Combinators.dfy
		wishlist/exists-b-exists-not-b.dfy

		# Following tests are very slow:
		DafnyTests/RunAllTests/RunAllTestsOption.dfy
		VSI-Benchmarks/b4.dfy
		blogposts/TestGenerationNoInliningEnumerativeDefinitions.dfy
		comp/BranchCoverage.dfy
		comp/CompileWithArguments.dfy
		comp/Extern.dfy
		comp/ExternCtors.dfy
		comp/MainMethod.dfy
		comp/Print.dfy
		comp/SequenceConcatOptimization.dfy
		comp/compile1quiet/CompileRunQuietly.dfy
		comp/compile1verbose/CompileAndThenRun.dfy
		comp/compile3/JustRun.dfy
		comp/manualcompile/ManualCompile.dfy
		comp/replaceables/complex/user.dfy
		comp/rust/strings.dfy
		concurrency/07-CounterThreadOwnership.dfy
		concurrency/08-CounterNoTermination.dfy
		concurrency/09-CounterNoStateMachine.dfy
		concurrency/10-SequenceInvariant.dfy
		concurrency/12-MutexLifetime-short.dfy
		dafny0/ModuleInsertion.dfy
		dafny0/NoTypeArgs.dfy
		dafny0/RlimitMultiplier.dfy
		dafny1/ExtensibleArray.dfy
		dafny1/ExtensibleArrayAuto.dfy
		dafny1/SchorrWaite.dfy
		dafny2/SnapshotableTrees.dfy
		dafny4/git-issue250.dfy
		git-issues/git-issue-Main4.dfy
		git-issues/git-issue-MainE.dfy
		separate-verification/app.dfy
		unicodecharsFalse/comp/CompileWithArguments.dfy
		unicodecharsFalse/expectations/Expect.dfy
		unicodecharsFalse/expectations/ExpectAndExceptions.dfy
		unicodecharsFalse/expectations/ExpectWithNonStringMessage.dfy
		verification/filter.dfy
	)
	local bad_test
	for bad_test in "${bad_tests[@]}" ; do
		if [[ -e "${TEST_S}/${bad_test}" ]] ; then
			rm -r "${TEST_S}/${bad_test}" || die "failed to remove test ${bad_test}"
		else
			ewarn "Test file ${bad_test} does not exist"
		fi
	done

	dotnet-pkg_src_prepare

	# Update lit's "lit.site.cfg" file.
	local dotnet_exec="${DOTNET_PKG_EXECUTABLE} exec ${DOTNET_PKG_OUTPUT}"
	local lit_config="${TEST_S}/lit.site.cfg"

	sed -i "${lit_config}" \
		-e "/^defaultDafnyExecutable/s|=.*|= '${dotnet_exec}/Dafny.dll '|" \
		-e "/^dafnyExecutable/s|=.*|= '${dotnet_exec}/Dafny.dll '|" \
		-e "/^defaultServerExecutable/s|=.*|= '${dotnet_exec}/DafnyServer.dll'|" \
		-e "/^serverExecutable/s|=.*|= '${dotnet_exec}/DafnyServer.dll'|" \
		-e "s|dotnet run |${DOTNET_PKG_EXECUTABLE} run |g" \
		|| die "failed to update ${lit_config}"
}

src_compile () {
	einfo "Building DafnyRuntimeJava JAR."
	local dafny_runtime_java="${S}/Source/DafnyRuntime/DafnyRuntimeJava"
	mkdir -p "${dafny_runtime_java}/build/libs/" || die
	pushd "${dafny_runtime_java}/build" || die

	ejavac -d ./ $(find "${dafny_runtime_java}/src/main" -type f -name "*.java")
	edo jar cvf "DafnyRuntime-4.6.0.jar" dafny/*

	cp "DafnyRuntime-4.6.0.jar" "${dafny_runtime_java}/build/libs/" || die
	popd || die

	# Build main dotnet package.
	dotnet-pkg_src_compile

	if use test ; then
		# Build "TestDafny" without saving artifacts.
		edotnet build										\
				--configuration Debug						\
				--no-self-contained							\
				-maxCpuCount:$(makeopts_jobs)				\
				"${S}/Source/TestDafny/TestDafny.csproj"
	fi
}

src_test() {
	# Dafny GOLang transpiler tests need "goimports" from "/usr/lib/go/bin".
	local -x PATH="${EPREFIX}/usr/lib/go/bin:${PATH}"

	einfo "Installing bignumber.js package required for tests using NodeJS."
	local -a npm_opts=(
		--audit false
		--color false
		--foreground-scripts
		--offline
		--progress false
		--verbose
	)
	edob npm "${npm_opts[@]}" install "${DISTDIR}/bignumber.js-9.1.2.tgz"

	einfo "Starting tests using the lit test tool."
	local -a lit_opts=(
		--order=lexical
		--time-tests
		--timeout 1800          # Let one test take no mere than half a hour.
		--verbose
		--workers="$(makeopts_jobs)"
	)
	edo lit "${lit_opts[@]}" "${TEST_S}"
}

src_install() {
	dotnet-pkg-base_install

	local -a dafny_exes=(
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

pkg_postinst() {
	optfeature "Dafny GO language backend" dev-go/go-tools
	optfeature "Dafny Rust language backend" virtual/rust
}
