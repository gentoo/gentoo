# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGETS="
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.codecoverage@16.2.0
microsoft.csharp@4.0.1
microsoft.dotnet.internalabstractions@1.0.0
microsoft.net.test.sdk@16.2.0
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.testplatform.objectmodel@16.2.0
microsoft.testplatform.testhost@16.2.0
microsoft.win32.primitives@4.0.1
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@4.0.0
microsoft.win32.registry@4.3.0
microsoft.win32.systemevents@6.0.0
netstandard.library@1.6.0
netstandard.library@2.0.0
newtonsoft.json@9.0.1
nunit@3.12.0
nunit3testadapter@3.15.1
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
runtime.native.system.net.http@4.0.1
runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system.security.cryptography@4.0.0
runtime.native.system@4.0.0
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.0
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
system.buffers@4.0.0
system.buffers@4.3.0
system.collections.concurrent@4.0.12
system.collections.immutable@1.2.0
system.collections.nongeneric@4.0.1
system.collections.nongeneric@4.3.0
system.collections.specialized@4.0.1
system.collections.specialized@4.3.0
system.collections@4.0.11
system.collections@4.3.0
system.componentmodel.eventbasedasync@4.0.11
system.componentmodel.eventbasedasync@4.3.0
system.componentmodel.primitives@4.1.0
system.componentmodel.primitives@4.3.0
system.componentmodel.typeconverter@4.1.0
system.componentmodel.typeconverter@4.3.0
system.componentmodel@4.0.1
system.componentmodel@4.3.0
system.configuration.configurationmanager@6.0.0
system.console@4.0.0
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.0.0
system.diagnostics.process@4.1.0
system.diagnostics.process@4.3.0
system.diagnostics.textwritertracelistener@4.0.0
system.diagnostics.tools@4.0.1
system.diagnostics.tracesource@4.0.0
system.diagnostics.tracing@4.1.0
system.diagnostics.tracing@4.3.0
system.drawing.common@6.0.0
system.dynamic.runtime@4.0.11
system.globalization.calendars@4.0.1
system.globalization.extensions@4.0.1
system.globalization.extensions@4.3.0
system.globalization@4.0.11
system.globalization@4.3.0
system.io.compression.zipfile@4.0.1
system.io.compression@4.1.0
system.io.filesystem.primitives@4.0.1
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.0.1
system.io.filesystem@4.3.0
system.io@4.1.0
system.io@4.3.0
system.linq.async@6.0.1
system.linq.expressions@4.1.0
system.linq@4.1.0
system.linq@4.3.0
system.net.http@4.1.0
system.net.nameresolution@4.3.0
system.net.primitives@4.0.11
system.net.sockets@4.1.0
system.objectmodel@4.0.12
system.private.datacontractserialization@4.1.1
system.private.uri@4.3.0
system.reactive@4.4.1
system.reflection.emit.ilgeneration@4.0.1
system.reflection.emit.lightweight@4.0.1
system.reflection.emit@4.0.1
system.reflection.extensions@4.0.1
system.reflection.extensions@4.3.0
system.reflection.metadata@1.3.0
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.1.0
system.reflection.typeextensions@4.3.0
system.reflection@4.1.0
system.reflection@4.3.0
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.runtime.caching@6.0.0
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
system.runtime.serialization.json@4.0.2
system.runtime.serialization.primitives@4.1.1
system.runtime@4.1.0
system.runtime@4.3.0
system.security.accesscontrol@6.0.0
system.security.claims@4.3.0
system.security.cryptography.algorithms@4.2.0
system.security.cryptography.cng@4.2.0
system.security.cryptography.csp@4.0.0
system.security.cryptography.encoding@4.0.0
system.security.cryptography.openssl@4.0.0
system.security.cryptography.primitives@4.0.0
system.security.cryptography.protecteddata@6.0.0
system.security.cryptography.x509certificates@4.1.0
system.security.permissions@6.0.0
system.security.principal.windows@4.3.0
system.security.principal@4.3.0
system.text.encoding.extensions@4.0.11
system.text.encoding.extensions@4.3.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.text.regularexpressions@4.1.0
system.text.regularexpressions@4.3.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.thread@4.0.0
system.threading.thread@4.3.0
system.threading.threadpool@4.0.10
system.threading.threadpool@4.3.0
system.threading.timer@4.0.1
system.threading@4.0.11
system.threading@4.3.0
system.windows.extensions@6.0.0
system.xml.readerwriter@4.0.11
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.0.11
system.xml.xmldocument@4.0.1
system.xml.xmldocument@4.3.0
system.xml.xmlserializer@4.0.11
system.xml.xpath.xmldocument@4.0.1
system.xml.xpath.xmldocument@4.3.0
system.xml.xpath@4.0.1
system.xml.xpath@4.3.0
"

inherit check-reqs dotnet-pkg edo multiprocessing

DESCRIPTION="SMT-based program verifier"
HOMEPAGE="https://github.com/boogie-org/boogie/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/boogie-org/${PN}.git"
else
	SRC_URI="https://github.com/boogie-org/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-mathematics/z3
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/lit
		dev-python/OutputCheck
	)
"

PATCHES=( "${FILESDIR}/${PN}-3.0.4-disable-analyzers.patch" )

CHECKREQS_DISK_BUILD="2G"
DOTNET_PKG_PROJECTS=( Source/BoogieDriver/BoogieDriver.csproj )
DOTNET_PKG_BUILD_EXTRA_ARGS=( -p:RollForward=Major )

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
	# Remove bad tests.
	local -a bad_tests=(
		civl/inductive-sequentialization/BroadcastConsensus.bpl
		civl/inductive-sequentialization/PingPong.bpl
		prover/cvc5-offline.bpl
		prover/cvc5.bpl
		prover/exitcode.bpl
		prover/z3-hard-timeout.bpl
		prover/z3mutl.bpl
		test15/CaptureInlineUnroll.bpl
		test2/Timeouts0.bpl
		test21/InterestingExamples4.bpl
	)
	local bad_test
	for bad_test in "${bad_tests[@]}" ; do
		rm "${S}/Test/${bad_test}" || die
	done

	# Update the boogieBinary variable.
	sed "/^boogieBinary/s|= .*|= '${DOTNET_PKG_OUTPUT}/BoogieDriver.dll'|" \
		-i "${S}/Test/lit.site.cfg" || die "failed to update lit.site.cfg"

	dotnet-pkg_src_prepare
}

src_test() {
	einfo "Starting tests using the lit test tool."
	local -a lit_opts=(
		--order=lexical
		--time-tests
		--verbose
		--workers="$(makeopts_jobs)"
	)
	edob lit "${lit_opts[@]}" "${S}/Test"
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/BoogieDriver" boogie

	einstalldocs
}
