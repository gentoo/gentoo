# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGETS="
avalonia@11.0.7
avalonia.angle.windows.natives@2.1.0.2023020321
avalonia.buildservices@0.0.29
avalonia.controls.colorpicker@11.0.4
avalonia.controls.colorpicker@11.0.7
avalonia.controls.datagrid@11.0.7
avalonia.controls.itemsrepeater@11.0.4
avalonia.desktop@11.0.7
avalonia.diagnostics@11.0.7
avalonia.freedesktop@11.0.7
avalonia.markup.xaml.loader@11.0.7
avalonia.native@11.0.7
avalonia.remote.protocol@11.0.4
avalonia.remote.protocol@11.0.7
avalonia.skia@11.0.0
avalonia.skia@11.0.4
avalonia.skia@11.0.7
avalonia.svg@11.0.0.13
avalonia.svg.skia@11.0.0.13
avalonia.themes.simple@11.0.7
avalonia.win32@11.0.7
avalonia.x11@11.0.7
commandlineparser@2.9.1
concentus@1.1.7
discordrichpresence@1.2.1.24
dynamicdata@8.3.27
excss@4.2.3
fluentavaloniaui@2.0.5
fsharp.core@7.0.200
gtksharp.dependencies@1.1.1
harfbuzzsharp@2.8.2.3
harfbuzzsharp@7.3.0
harfbuzzsharp.nativeassets.linux@2.8.2.3
harfbuzzsharp.nativeassets.linux@7.3.0
harfbuzzsharp.nativeassets.macos@2.8.2.3
harfbuzzsharp.nativeassets.macos@7.3.0
harfbuzzsharp.nativeassets.webassembly@2.8.2.3
harfbuzzsharp.nativeassets.webassembly@7.3.0
harfbuzzsharp.nativeassets.win32@2.8.2.3
harfbuzzsharp.nativeassets.win32@7.3.0
libhac@0.19.0
microcom.codegenerator.msbuild@0.11.0
microcom.runtime@0.11.0
microsoft.codeanalysis.analyzers@3.0.0
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.common@3.8.0
microsoft.codeanalysis.common@4.8.0
microsoft.codeanalysis.csharp@3.8.0
microsoft.codeanalysis.csharp@4.8.0
microsoft.codeanalysis.csharp.scripting@3.8.0
microsoft.codeanalysis.scripting.common@3.8.0
microsoft.codecoverage@17.9.0
microsoft.csharp@4.3.0
microsoft.csharp@4.7.0
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.dependencymodel@6.0.0
microsoft.identitymodel.abstractions@7.3.0
microsoft.identitymodel.jsonwebtokens@7.3.0
microsoft.identitymodel.logging@7.3.0
microsoft.identitymodel.tokens@7.3.0
microsoft.io.recyclablememorystream@3.0.0
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@2.0.0
microsoft.netcore.platforms@2.1.2
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.net.test.sdk@17.9.0
microsoft.testplatform.objectmodel@17.9.0
microsoft.testplatform.testhost@17.9.0
microsoft.win32.primitives@4.0.1
microsoft.win32.registry@4.5.0
microsoft.win32.systemevents@8.0.0
msgpack.cli@1.0.1
netcoreserver@8.0.7
netstandard.library@1.6.0
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@13.0.1
nunit@3.13.3
nunit3testadapter@4.1.0
opentk.audio.openal@4.8.2
opentk.core@4.8.2
opentk.graphics@4.8.2
opentk.mathematics@4.8.2
opentk.redist.glfw@3.3.8.39
opentk.windowing.graphicslibraryframework@4.8.2
runtime.any.system.collections@4.3.0
runtime.any.system.diagnostics.tools@4.3.0
runtime.any.system.diagnostics.tracing@4.3.0
runtime.any.system.globalization@4.3.0
runtime.any.system.globalization.calendars@4.3.0
runtime.any.system.io@4.3.0
runtime.any.system.reflection@4.3.0
runtime.any.system.reflection.extensions@4.3.0
runtime.any.system.reflection.primitives@4.3.0
runtime.any.system.resources.resourcemanager@4.3.0
runtime.any.system.runtime@4.3.0
runtime.any.system.runtime.handles@4.3.0
runtime.any.system.runtime.interopservices@4.3.0
runtime.any.system.text.encoding@4.3.0
runtime.any.system.text.encoding.extensions@4.3.0
runtime.any.system.threading.tasks@4.3.0
runtime.any.system.threading.timer@4.3.0
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system@4.0.0
runtime.native.system@4.3.0
runtime.native.system.io.compression@4.1.0
runtime.native.system.net.http@4.0.1
runtime.native.system.security.cryptography@4.0.0
runtime.native.system.security.cryptography.openssl@4.3.0
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
runtime.win.microsoft.win32.primitives@4.3.0
runtime.win.system.console@4.3.0
runtime.win.system.diagnostics.debug@4.3.0
runtime.win.system.io.filesystem@4.3.0
runtime.win.system.net.primitives@4.3.0
runtime.win.system.net.sockets@4.3.0
runtime.win.system.runtime.extensions@4.3.0
ryujinx.atksharp@3.24.24.59-ryujinx
ryujinx.audio.openal.dependencies@1.21.0.1
ryujinx.cairosharp@3.24.24.59-ryujinx
ryujinx.gdksharp@3.24.24.59-ryujinx
ryujinx.giosharp@3.24.24.59-ryujinx
ryujinx.glibsharp@3.24.24.59-ryujinx
ryujinx.graphics.nvdec.dependencies@5.0.3-build14
ryujinx.graphics.vulkan.dependencies.moltenvk@1.2.0
ryujinx.gtksharp@3.24.24.59-ryujinx
ryujinx.pangosharp@3.24.24.59-ryujinx
ryujinx.sdl2-cs@2.30.0-build32
securifybv.propertystore@0.1.0
securifybv.shelllink@0.1.0
shaderc.net@0.1.0
sharpziplib@1.4.2
shimskiasharp@1.0.0.13
silk.net.core@2.16.0
silk.net.vulkan@2.16.0
silk.net.vulkan.extensions.ext@2.16.0
silk.net.vulkan.extensions.khr@2.16.0
sixlabors.fonts@1.0.0
sixlabors.imagesharp@2.1.7
sixlabors.imagesharp.drawing@1.0.0
skiasharp@2.88.3
skiasharp@2.88.6
skiasharp@2.88.7
skiasharp.harfbuzz@2.88.6
skiasharp.nativeassets.linux@2.88.3
skiasharp.nativeassets.linux@2.88.7
skiasharp.nativeassets.macos@2.88.3
skiasharp.nativeassets.macos@2.88.6
skiasharp.nativeassets.macos@2.88.7
skiasharp.nativeassets.webassembly@2.88.3
skiasharp.nativeassets.webassembly@2.88.7
skiasharp.nativeassets.win32@2.88.3
skiasharp.nativeassets.win32@2.88.6
skiasharp.nativeassets.win32@2.88.7
spb@0.0.4-build32
svg.custom@1.0.0.13
svg.model@1.0.0.13
svg.skia@1.0.0.13
system.appcontext@4.1.0
system.buffers@4.0.0
system.buffers@4.3.0
system.buffers@4.5.1
system.codedom@4.4.0
system.codedom@8.0.0
system.collections@4.0.11
system.collections@4.3.0
system.collections.concurrent@4.0.12
system.collections.immutable@5.0.0
system.collections.immutable@7.0.0
system.componentmodel.annotations@4.5.0
system.console@4.0.0
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.0.0
system.diagnostics.tools@4.0.1
system.diagnostics.tracing@4.1.0
system.drawing.common@8.0.2
system.dynamic.runtime@4.3.0
system.globalization@4.0.11
system.globalization@4.3.0
system.globalization.calendars@4.0.1
system.globalization.extensions@4.0.1
system.io@4.1.0
system.io@4.3.0
system.io.compression@4.1.0
system.io.compression.zipfile@4.0.1
system.io.filesystem@4.0.1
system.io.filesystem.primitives@4.0.1
system.io.hashing@8.0.0
system.io.pipelines@6.0.0
system.linq@4.1.0
system.linq@4.3.0
system.linq.expressions@4.1.0
system.linq.expressions@4.3.0
system.management@8.0.0
system.memory@4.5.4
system.memory@4.5.5
system.net.http@4.1.0
system.net.nameresolution@4.3.0
system.net.primitives@4.0.11
system.net.sockets@4.1.0
system.numerics.vectors@4.3.0
system.numerics.vectors@4.4.0
system.numerics.vectors@4.5.0
system.objectmodel@4.0.12
system.objectmodel@4.3.0
system.private.uri@4.3.0
system.reactive@6.0.0
system.reflection@4.1.0
system.reflection@4.3.0
system.reflection.emit@4.0.1
system.reflection.emit@4.3.0
system.reflection.emit.ilgeneration@4.0.1
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.0.1
system.reflection.emit.lightweight@4.3.0
system.reflection.extensions@4.0.1
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.metadata@5.0.0
system.reflection.metadata@7.0.0
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.1.0
system.reflection.typeextensions@4.3.0
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.runtime@4.1.0
system.runtime@4.3.0
system.runtime.compilerservices.unsafe@4.7.1
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.1.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.0.1
system.runtime.handles@4.3.0
system.runtime.interopservices@4.1.0
system.runtime.interopservices@4.3.0
system.runtime.interopservices.runtimeinformation@4.0.0
system.runtime.numerics@4.0.1
system.security.accesscontrol@4.5.0
system.security.claims@4.3.0
system.security.cryptography.algorithms@4.2.0
system.security.cryptography.cng@4.2.0
system.security.cryptography.csp@4.0.0
system.security.cryptography.encoding@4.0.0
system.security.cryptography.openssl@4.0.0
system.security.cryptography.primitives@4.0.0
system.security.cryptography.x509certificates@4.1.0
system.security.principal@4.3.0
system.security.principal.windows@4.3.0
system.security.principal.windows@4.5.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.text.encoding.codepages@4.5.1
system.text.encoding.codepages@5.0.0
system.text.encoding.codepages@7.0.0
system.text.encoding.extensions@4.0.11
system.text.encodings.web@6.0.0
system.text.json@6.0.0
system.text.regularexpressions@4.1.0
system.threading@4.0.11
system.threading@4.3.0
system.threading.overlapped@4.3.0
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks.extensions@4.5.4
system.threading.threadpool@4.3.0
system.threading.timer@4.0.1
system.xml.readerwriter@4.0.11
system.xml.xdocument@4.0.11
tmds.dbus.protocol@0.15.0
unicornengine.unicorn@2.0.2-rc1-fb78016
"

inherit check-reqs desktop dotnet-pkg xdg

DESCRIPTION="Experimental Nintendo Switch Emulator written in C#"
HOMEPAGE="https://www.ryujinx.org/
	https://github.com/Ryujinx/Ryujinx/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN^}/${PN^}.git"
else
	SRC_URI="https://github.com/${PN^}/${PN^}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN^}-${PV}"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

RDEPEND="
	app-arch/brotli
	dev-libs/expat
	dev-libs/icu
	dev-libs/libxml2
	dev-libs/openssl
	dev-libs/wayland
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libglvnd[X]
	media-libs/libpng
	media-libs/libpulse
	media-libs/libsdl2
	media-video/pipewire
	x11-libs/gtk+:3
	x11-libs/libX11
"

CHECKREQS_DISK_BUILD="3G"
DOTNET_PKG_PROJECTS=(
	"src/${PN^}/${PN^}.csproj"
)
PATCHES=(
	"${FILESDIR}/${PN}-1.1.1221-better-defaults.patch"
	"${FILESDIR}/${PN}-1.1.1221-disable-updates.patch"
)

DOCS=( README.md distribution/legal/THIRDPARTY.md )

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
	sed "s|1.0.0-dirty|${PV}|g" -i src/*/*.csproj || die
	dotnet-pkg_src_prepare
}

src_test() {
	dotnet-pkg-base_test src/Ryujinx.Tests.Memory
}

src_install() {
	dotnet-pkg-base_install

	# "Ryujinx.sh" launcher script is only copied for "linux-x64" RID,
	# let's copy it unconditionally. Bug: https://bugs.gentoo.org/923817
	exeinto "/usr/share/${P}"
	doexe "distribution/linux/${PN^}.sh"
	dotnet-pkg-base_dolauncher "/usr/share/${P}/${PN^}.sh"

	newicon distribution/misc/Logo.svg "${PN^}.svg"
	domenu "distribution/linux/${PN^}.desktop"

	insinto /usr/share/mime/packages
	doins "distribution/linux/mime/${PN^}.xml"

	einstalldocs
}
