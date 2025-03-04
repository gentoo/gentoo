# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=9.0
NUGETS="
avalonia.angle.windows.natives@2.1.0.2023020321
avalonia.buildservices@0.0.29
avalonia.controls.colorpicker@11.0.13
avalonia.controls.colorpicker@11.0.4
avalonia.controls.datagrid@11.0.13
avalonia.controls.datagrid@11.0.4
avalonia.controls.itemsrepeater@11.0.4
avalonia.desktop@11.0.13
avalonia.diagnostics@11.0.13
avalonia.freedesktop@11.0.13
avalonia.markup.xaml.loader@11.0.13
avalonia.native@11.0.13
avalonia.remote.protocol@11.0.13
avalonia.skia@11.0.0
avalonia.skia@11.0.13
avalonia.skia@11.0.4
avalonia.svg.skia@11.0.0.19
avalonia.svg@11.0.0.19
avalonia.themes.simple@11.0.13
avalonia.win32@11.0.13
avalonia.x11@11.0.13
avalonia@11.0.0
avalonia@11.0.10
avalonia@11.0.13
avalonia@11.0.4
commandlineparser@2.9.1
communitytoolkit.mvvm@8.4.0
concentus@2.2.2
csfastfloat@4.1.5
discordrichpresence@1.2.1.24
dynamicdata@9.0.4
excss@4.2.3
fluentavaloniaui@2.0.5
fsharp.core@7.0.200
gommon@2.7.0.2
harfbuzzsharp.nativeassets.linux@7.3.0
harfbuzzsharp.nativeassets.macos@7.3.0
harfbuzzsharp.nativeassets.macos@7.3.0.2
harfbuzzsharp.nativeassets.webassembly@7.3.0
harfbuzzsharp.nativeassets.win32@7.3.0
harfbuzzsharp.nativeassets.win32@7.3.0.2
harfbuzzsharp@7.3.0
harfbuzzsharp@7.3.0.2
humanizer.core.af@2.14.1
humanizer.core.ar@2.14.1
humanizer.core.az@2.14.1
humanizer.core.bg@2.14.1
humanizer.core.bn-bd@2.14.1
humanizer.core.cs@2.14.1
humanizer.core.da@2.14.1
humanizer.core.de@2.14.1
humanizer.core.el@2.14.1
humanizer.core.es@2.14.1
humanizer.core.fa@2.14.1
humanizer.core.fi-fi@2.14.1
humanizer.core.fr-be@2.14.1
humanizer.core.fr@2.14.1
humanizer.core.he@2.14.1
humanizer.core.hr@2.14.1
humanizer.core.hu@2.14.1
humanizer.core.hy@2.14.1
humanizer.core.id@2.14.1
humanizer.core.is@2.14.1
humanizer.core.it@2.14.1
humanizer.core.ja@2.14.1
humanizer.core.ko-kr@2.14.1
humanizer.core.ku@2.14.1
humanizer.core.lv@2.14.1
humanizer.core.ms-my@2.14.1
humanizer.core.mt@2.14.1
humanizer.core.nb-no@2.14.1
humanizer.core.nb@2.14.1
humanizer.core.nl@2.14.1
humanizer.core.pl@2.14.1
humanizer.core.pt@2.14.1
humanizer.core.ro@2.14.1
humanizer.core.ru@2.14.1
humanizer.core.sk@2.14.1
humanizer.core.sl@2.14.1
humanizer.core.sr-latn@2.14.1
humanizer.core.sr@2.14.1
humanizer.core.sv@2.14.1
humanizer.core.th-th@2.14.1
humanizer.core.tr@2.14.1
humanizer.core.uk@2.14.1
humanizer.core.uz-cyrl-uz@2.14.1
humanizer.core.uz-latn-uz@2.14.1
humanizer.core.vi@2.14.1
humanizer.core.zh-cn@2.14.1
humanizer.core.zh-hans@2.14.1
humanizer.core.zh-hant@2.14.1
humanizer.core@2.14.1
humanizer@2.14.1
jetbrains.annotations@2023.2.0
libhac@0.19.0
microcom.codegenerator.msbuild@0.11.0
microcom.runtime@0.11.0
microsoft.codeanalysis.analyzers@3.0.0
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.common@3.8.0
microsoft.codeanalysis.common@4.9.2
microsoft.codeanalysis.csharp.scripting@3.8.0
microsoft.codeanalysis.csharp@3.8.0
microsoft.codeanalysis.csharp@4.9.2
microsoft.codeanalysis.scripting.common@3.8.0
microsoft.codecoverage@17.9.0
microsoft.csharp@4.3.0
microsoft.csharp@4.7.0
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.dependencymodel@8.0.0
microsoft.identitymodel.abstractions@8.3.0
microsoft.identitymodel.jsonwebtokens@8.3.0
microsoft.identitymodel.logging@8.3.0
microsoft.identitymodel.tokens@8.3.0
microsoft.io.recyclablememorystream@3.0.1
microsoft.net.test.sdk@17.9.0
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@2.0.0
microsoft.netcore.platforms@2.1.2
microsoft.netcore.targets@1.1.0
microsoft.testplatform.objectmodel@17.9.0
microsoft.testplatform.testhost@17.9.0
microsoft.win32.registry@4.5.0
msgpack.cli@1.0.1
netcoreserver@8.0.7
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@13.0.1
nunit3testadapter@4.1.0
nunit@3.13.3
open.nat.core@2.1.0.5
opentk.audio.openal@4.8.2
opentk.core@4.8.2
opentk.graphics@4.8.2
opentk.mathematics@4.8.2
opentk.redist.glfw@3.3.8.39
opentk.windowing.graphicslibraryframework@4.8.2
projektanker.icons.avalonia.fontawesome@9.4.0
projektanker.icons.avalonia.materialdesign@9.4.0
projektanker.icons.avalonia@9.4.0
runtime.any.system.globalization@4.3.0
runtime.any.system.io@4.3.0
runtime.any.system.reflection.primitives@4.3.0
runtime.any.system.reflection@4.3.0
runtime.any.system.resources.resourcemanager@4.3.0
runtime.any.system.runtime@4.3.0
runtime.any.system.text.encoding@4.3.0
runtime.any.system.threading.tasks@4.3.0
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.unix.system.private.uri@4.3.0
runtime.unix.system.runtime.extensions@4.3.0
ryujinx.audio.openal.dependencies@1.21.0.1
ryujinx.graphics.nvdec.dependencies@5.0.3-build14
ryujinx.graphics.vulkan.dependencies.moltenvk@1.2.0
ryujinx.sdl2-cs@2.30.0-build32
securifybv.propertystore@0.1.0
securifybv.shelllink@0.1.0
sep@0.6.0
shaderc.net@0.1.0
sharpmetal@1.0.0-preview21
sharpziplib@1.4.2
shimskiasharp@1.0.0.19
silk.net.core@2.22.0
silk.net.vulkan.extensions.ext@2.22.0
silk.net.vulkan.extensions.khr@2.22.0
silk.net.vulkan@2.22.0
skiasharp.harfbuzz@2.88.8
skiasharp.nativeassets.linux@2.88.7
skiasharp.nativeassets.linux@2.88.9
skiasharp.nativeassets.macos@2.88.8
skiasharp.nativeassets.macos@2.88.9
skiasharp.nativeassets.webassembly@2.88.7
skiasharp.nativeassets.win32@2.88.8
skiasharp.nativeassets.win32@2.88.9
skiasharp@2.88.7
skiasharp@2.88.8
skiasharp@2.88.9
spb@0.0.4-build32
svg.custom@1.0.0.19
svg.model@1.0.0.19
svg.skia@1.0.0.19
system.buffers@4.5.1
system.codedom@4.4.0
system.codedom@9.0.0
system.collections.immutable@5.0.0
system.collections.immutable@8.0.0
system.collections@4.3.0
system.componentmodel.annotations@4.5.0
system.diagnostics.debug@4.3.0
system.dynamic.runtime@4.3.0
system.globalization@4.3.0
system.io.hashing@9.0.0
system.io.pipelines@6.0.0
system.io@4.3.0
system.linq.expressions@4.3.0
system.linq@4.3.0
system.management@9.0.0
system.memory@4.5.4
system.memory@4.5.5
system.numerics.vectors@4.3.0
system.numerics.vectors@4.4.0
system.numerics.vectors@4.5.0
system.objectmodel@4.3.0
system.private.uri@4.3.0
system.reactive@6.0.1
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.3.0
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.metadata@5.0.0
system.reflection.metadata@8.0.0
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.3.0
system.reflection@4.3.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@4.5.2
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@4.7.1
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.3.0
system.runtime.interopservices@4.3.0
system.runtime@4.3.0
system.security.accesscontrol@4.5.0
system.security.principal.windows@4.5.0
system.text.encoding.codepages@4.5.1
system.text.encoding.codepages@8.0.0
system.text.encoding@4.3.0
system.text.encodings.web@8.0.0
system.text.json@8.0.0
system.text.json@8.0.3
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.3.0
system.threading@4.3.0
tmds.dbus.protocol@0.15.0
unicornengine.unicorn@2.0.2-rc1-fb78016
"

inherit check-reqs desktop dotnet-pkg xdg

DESCRIPTION="Experimental Nintendo Switch Emulator written in C#"
HOMEPAGE="https://ryujinx-emulator.com/
	https://github.com/Ryubing/Ryujinx"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/Ryubing/${PN^}.git"
else
	SRC_URI="https://github.com/Ryubing/${PN^}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${P^}"

	KEYWORDS="amd64"
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
DOTNET_PKG_BUILD_EXTRA_ARGS=( -p:ExtraDefineConstants=DISABLE_UPDATER )
DOTNET_PKG_PROJECTS=(
	"src/${PN^}/${PN^}.csproj"
)
PATCHES=(
	"${FILESDIR}/${P}-better-defaults.patch"
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
	# Bug https://bugs.gentoo.org/933075
	# and bug https://github.com/Ryujinx/Ryujinx/issues/5566
	dotnet-pkg-base_append-launchervar "GDK_BACKEND=x11"

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
