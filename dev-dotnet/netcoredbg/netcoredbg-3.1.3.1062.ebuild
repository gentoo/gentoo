# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-3)-$(ver_cut 4)"
DOTNET_RUNTIME_V="8.0.20"

CMAKE_IN_SOURCE_BUILD="ON"
CMAKE_MAKEFILE_GENERATOR="emake"

DOTNET_PKG_COMPAT="10.0"
NUGETS="
microsoft.codeanalysis.analyzers@1.1.0
microsoft.codeanalysis.common@2.3.0
microsoft.codeanalysis.csharp.scripting@2.3.0
microsoft.codeanalysis.csharp@2.3.0
microsoft.codeanalysis.scripting.common@2.3.0
microsoft.csharp@4.4.0
microsoft.diagnostics.dbgshim.linux-arm64@8.0.532401
microsoft.diagnostics.dbgshim.linux-arm@8.0.532401
microsoft.diagnostics.dbgshim.linux-musl-arm64@8.0.532401
microsoft.diagnostics.dbgshim.linux-musl-arm@8.0.532401
microsoft.diagnostics.dbgshim.linux-musl-x64@8.0.532401
microsoft.diagnostics.dbgshim.linux-x64@8.0.532401
microsoft.diagnostics.dbgshim.osx-arm64@8.0.532401
microsoft.diagnostics.dbgshim.osx-x64@8.0.532401
microsoft.diagnostics.dbgshim.win-arm64@8.0.532401
microsoft.diagnostics.dbgshim.win-arm@8.0.532401
microsoft.diagnostics.dbgshim.win-x64@8.0.532401
microsoft.diagnostics.dbgshim.win-x86@8.0.532401
microsoft.diagnostics.dbgshim@8.0.532401
microsoft.netcore.platforms@1.1.0
microsoft.netcore.targets@1.1.0
netstandard.library@2.0.3
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
runtime.unix.system.console@4.3.0
runtime.unix.system.diagnostics.debug@4.3.0
runtime.unix.system.io.filesystem@4.3.0
runtime.unix.system.private.uri@4.3.0
runtime.unix.system.runtime.extensions@4.3.0
system.appcontext@4.3.0
system.buffers@4.3.0
system.collections.concurrent@4.3.0
system.collections.immutable@1.3.1
system.collections@4.3.0
system.console@4.3.0
system.diagnostics.debug@4.3.0
system.diagnostics.fileversioninfo@4.3.0
system.diagnostics.stacktrace@4.3.0
system.diagnostics.tools@4.3.0
system.diagnostics.tracing@4.3.0
system.dynamic.runtime@4.3.0
system.globalization.calendars@4.3.0
system.globalization@4.3.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io@4.3.0
system.linq.expressions@4.3.0
system.linq@4.3.0
system.objectmodel@4.3.0
system.private.uri@4.3.0
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.3.0
system.reflection.extensions@4.3.0
system.reflection.metadata@1.4.2
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.3.0
system.reflection@4.3.0
system.resources.resourcemanager@4.3.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.3.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.x509certificates@4.3.0
system.text.encoding.codepages@4.3.0
system.text.encoding.extensions@4.3.0
system.text.encoding@4.3.0
system.text.regularexpressions@4.3.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.parallel@4.3.0
system.threading.tasks@4.3.0
system.threading.thread@4.3.0
system.threading@4.3.0
system.valuetuple@4.3.0
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.3.0
system.xml.xmldocument@4.3.0
system.xml.xpath.xdocument@4.3.0
system.xml.xpath@4.3.0
"

inherit check-reqs dotnet-pkg flag-o-matic cmake

DESCRIPTION="NetCoreDbg is a managed code debugger with MI interface for CoreCLR"
HOMEPAGE="https://github.com/Samsung/netcoredbg/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/Samsung/${PN}"
else
	SRC_URI="https://github.com/Samsung/${PN}/archive/refs/tags/${MY_PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"

	KEYWORDS="amd64"
fi

# .NET runtime that would have otherwise be downloaded via git.
SRC_URI+="
	https://github.com/dotnet/runtime/archive/refs/tags/v${DOTNET_RUNTIME_V}.tar.gz
		-> dotnet-runtime-${DOTNET_RUNTIME_V}.gh.tar.gz
"
CORECLR_S="${WORKDIR}/runtime-${DOTNET_RUNTIME_V}/src/coreclr"

SRC_URI+="
	${NUGET_URIS}
"

LICENSE="MIT"
SLOT="0/${MY_PV}"

CHECKREQS_DISK_BUILD="1400M"
DOTNET_PKG_PROJECTS=(
	src/managed/ManagedPart.csproj   # Restore but do not build those projects.
)
PATCHES=( "${FILESDIR}/netcoredbg-3.0.0.1012-compileoptions.patch" )
QA_FLAGS_IGNORED=".*/libdbgshim.so"

DOCS=( README.md docs/{interop,stepping}.md )

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
	# Bump "cmake_minimum_required" to >=3.20.
	sed -i CMakeLists.txt \
		third_party/libelfin/CMakeLists.txt \
		third_party/libelfin/dwarf/CMakeLists.txt \
		third_party/libelfin/elf/CMakeLists.txt \
		third_party/linenoise-ng/CMakeLists.txt \
		-e "/^cmake_minimum_required/s|3.5|3.25|g" \
		|| die

	cmake_src_prepare

	nuget_writeconfig "$(pwd)/"
	cp NuGet.config tools/generrmsg/nuget.xml || die
}

src_configure() {
	INSTALL_PREFIX="/usr/$(get_libdir)/${PN}"
	append-cxxflags -fpermissive
	dotnet-pkg_src_configure

	local -a mycmakeargs=(
		-DBUILD_MANAGED="1"
		-DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}"
		-DCORECLR_DIR="${CORECLR_S}"
		-DDOTNET_DIR="${DOTNET_ROOT}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	dosym -r "${INSTALL_PREFIX}/${PN}" "/usr/bin/${PN}"
	einstalldocs
}
