# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 )

DOTNET_PKG_COMPAT=6.0
NUGETS="
discordrichpresence@1.1.3.18
linguini.bundle@0.5.0
linguini.shared@0.5.0
linguini.syntax@0.5.0
microsoft.extensions.dependencymodel@6.0.0
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.1.0
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@5.0.0
mono.nat@3.0.4
mp3sharp@1.0.5
newtonsoft.json@13.0.1
nuget.commandline@4.4.1
nvorbis@0.10.5
openra-eluant@1.0.22
openra-freetype6@1.0.11
openra-fuzzylogiclibrary@1.0.1
openra-openal-cs@1.0.22
openra-sdl2-cs@1.0.40
pfim@0.11.2
rix0rrr.beaconlib@1.0.2
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
sharpziplib@1.4.2
stylecop.analyzers.unstable@1.2.0.435
stylecop.analyzers@1.2.0-beta.435
system.buffers@4.3.0
system.buffers@4.5.1
system.collections.concurrent@4.3.0
system.collections@4.3.0
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.tracing@4.3.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io@4.3.0
system.linq@4.3.0
system.memory@4.5.3
system.memory@4.5.4
system.net.http@4.3.4
system.net.primitives@4.3.0
system.private.uri@4.3.0
system.reflection.primitives@4.3.0
system.reflection@4.3.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.loader@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.3.0
system.security.accesscontrol@5.0.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.x509certificates@4.3.0
system.security.principal.windows@5.0.0
system.text.encoding.extensions@4.3.0
system.text.encoding@4.3.0
system.text.encodings.web@6.0.0
system.text.json@6.0.0
system.threading.channels@6.0.0
system.threading.tasks@4.3.0
system.threading@4.3.0
system.valuetuple@4.5.0
taglibsharp@2.3.0
"

inherit check-reqs dotnet-pkg lua-single xdg

DESCRIPTION="A free RTS engine supporting games like Command & Conquer, Red Alert and Dune2k"
HOMEPAGE="https://www.openra.net/
	https://github.com/OpenRA/OpenRA/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/OpenRA/OpenRA.git"
else
	SRC_URI="https://github.com/OpenRA/OpenRA/archive/release-${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/OpenRA-release-${PV}"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

# Engine is GPL-3, dependent DLLs are mixed.
LICENSE="GPL-3 Apache-2.0 BSD GPL-2 MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	app-misc/ca-certificates
	media-libs/freetype:2
	media-libs/libsdl2[opengl,video]
	media-libs/openal
"
BDEPEND="
	${RDEPEND}
"

CHECKREQS_DISK_BUILD="2G"
PATCHES=(
	"${FILESDIR}/${PN}-20231010-configure-system-libraries.patch"
	"${FILESDIR}/${PN}-20231010-makefile.patch"
	"${FILESDIR}/${PN}-20231010-packaging-functions.patch"
)

DOCS=( AUTHORS CODE_OF_CONDUCT.md CONTRIBUTING.md README.md )

pkg_setup() {
	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
	lua-single_pkg_setup
}

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_compile() {
	emake VERSION="release-${PV}" version
	emake RUNTIME=net6
}

src_install() {
	local openra_home="/usr/lib/${PN}"

	# We compiled to "bin", not standard "dotnet-pkg" path.
	mkdir -p "${ED}/usr/share" || die
	cp -r bin "${ED}/usr/share/${P}" || die

	# This is used by "linux-shortcuts" (see below make-install).
	dotnet-pkg-base_launcherinto "${openra_home}"
	dotnet-pkg-base_dolauncher "/usr/share/${P}/OpenRA" OpenRA
	dotnet-pkg-base_dolauncher "/usr/share/${P}/OpenRA.Server" OpenRA.Server

	emake DESTDIR="${ED}" RUNTIME=net6 prefix=/usr bindir=/usr/bin \
		  install install-linux-shortcuts install-linux-appdata install-man

	local -a assets=(
		glsl
		mods
		AUTHORS
		COPYING
		VERSION
		'global mix database.dat'
	)
	local asset
	for asset in "${assets[@]}" ; do
		dosym -r "${openra_home}/${asset}" "/usr/share/${P}/${asset}"
	done

	einstalldocs
}
