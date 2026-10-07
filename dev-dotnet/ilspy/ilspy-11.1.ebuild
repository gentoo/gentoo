# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGET_APIS=(
	"https://api.nuget.org/v3-flatcontainer"
	"https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-tools/nuget/v3/flat2"
	"https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet10-transport/nuget/v3/flat2"
)
NUGETS="
microsoft.netcore.app.ref@8.0.0
avalonia.angle.windows.natives@2.1.27548.20260419
avalonia.avaloniaedit@12.0.0
avalonia.buildservices@11.3.2
avalonia.desktop@12.1.2
avalonia.freedesktop.atspi@12.1.2
avalonia.freedesktop@12.1.2
avalonia.harfbuzz@12.1.2
avalonia.native@12.1.2
avalonia.remote.protocol@12.1.2
avalonia.skia@12.0.0
avalonia.skia@12.1.2
avalonia.themes.simple@12.1.2
avalonia.win32@12.1.2
avalonia.x11@12.1.2
avalonia@12.1.2
avaloniaedit.textmate@12.0.0
avaloniaui.diagnosticssupport@2.2.3
communitytoolkit.mvvm@8.4.2
dock.avalonia.themes.simple@12.1.0.6
dock.avalonia@12.1.0.6
dock.controls.deferredcontentcontrol@12.1.0.6
dock.controls.proportionalstackpanel@12.1.0.6
dock.controls.recycling.model@12.1.0.6
dock.controls.recycling@12.1.0.6
dock.markupextension@12.1.0.6
dock.model.mvvm@12.1.0.6
dock.model@12.1.0.6
dock.serializer.systemtextjson@12.1.0.6
dock.settings@12.1.0.6
excss@4.3.1
harfbuzzsharp.nativeassets.linux@8.3.1.3
harfbuzzsharp.nativeassets.macos@8.3.1.3
harfbuzzsharp.nativeassets.webassembly@8.3.1.3
harfbuzzsharp.nativeassets.win32@8.3.1.3
harfbuzzsharp@8.3.1.3
k4os.compression.lz4@1.3.8
mcmaster.extensions.commandlineutils@5.1.0
mcmaster.extensions.hosting.commandline@5.1.0
microcom.runtime@0.11.6
microsoft.build.tasks.git@10.0.401
microsoft.codeanalysis.analyzers@3.11.0
microsoft.codeanalysis.common@5.0.0
microsoft.codeanalysis.csharp@5.0.0
microsoft.codeanalysis.netanalyzers@10.0.401
microsoft.diasymreader.converter.xml@1.1.0-beta2-22171-02
microsoft.diasymreader.native@17.0.0-beta1.21524.1
microsoft.diasymreader.portablepdb@1.7.0-beta-21525-03
microsoft.diasymreader@1.4.0
microsoft.extensions.configuration.abstractions@10.0.12
microsoft.extensions.configuration.abstractions@10.0.5
microsoft.extensions.configuration.binder@10.0.12
microsoft.extensions.configuration.commandline@10.0.12
microsoft.extensions.configuration.environmentvariables@10.0.12
microsoft.extensions.configuration.fileextensions@10.0.12
microsoft.extensions.configuration.json@10.0.12
microsoft.extensions.configuration.usersecrets@10.0.12
microsoft.extensions.configuration@10.0.12
microsoft.extensions.dependencyinjection.abstractions@10.0.12
microsoft.extensions.dependencyinjection@10.0.12
microsoft.extensions.diagnostics.abstractions@10.0.12
microsoft.extensions.diagnostics.abstractions@10.0.5
microsoft.extensions.diagnostics@10.0.12
microsoft.extensions.fileproviders.abstractions@10.0.12
microsoft.extensions.fileproviders.abstractions@10.0.5
microsoft.extensions.fileproviders.physical@10.0.12
microsoft.extensions.filesystemglobbing@10.0.12
microsoft.extensions.hosting.abstractions@10.0.12
microsoft.extensions.hosting.abstractions@10.0.5
microsoft.extensions.hosting@10.0.12
microsoft.extensions.logging.abstractions@10.0.12
microsoft.extensions.logging.abstractions@10.0.5
microsoft.extensions.logging.abstractions@8.0.0
microsoft.extensions.logging.configuration@10.0.12
microsoft.extensions.logging.console@10.0.12
microsoft.extensions.logging.debug@10.0.12
microsoft.extensions.logging.eventlog@10.0.12
microsoft.extensions.logging.eventsource@10.0.12
microsoft.extensions.logging@10.0.12
microsoft.extensions.options.configurationextensions@10.0.12
microsoft.extensions.options@10.0.12
microsoft.extensions.primitives@10.0.12
microsoft.io.recyclablememorystream@3.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.sbom.targets@4.1.5
microsoft.sourcelink.common@10.0.401
microsoft.sourcelink.github@10.0.401
mono.cecil@0.11.6
netstandard.library@1.6.1
netstandard.library@2.0.3
newtonsoft.json@13.0.3
nuget.common@7.9.0
nuget.configuration@7.9.0
nuget.frameworks@7.9.0
nuget.packaging@7.9.0
nuget.protocol@7.9.0
nuget.versioning@7.9.0
onigwrap@1.0.10
prodatagrid.formulaengine.excel@12.1.0.4
prodatagrid.formulaengine@12.1.0.4
prodatagrid@12.1.0.4
shimskiasharp@5.1.1
skiasharp.nativeassets.linux@3.119.4
skiasharp.nativeassets.macos@3.119.4
skiasharp.nativeassets.webassembly@3.119.4
skiasharp.nativeassets.win32@3.119.4
skiasharp@3.119.2
skiasharp@3.119.4
svg.animation@5.1.1
svg.controls.skia.avalonia@12.0.0.13
svg.custom@5.1.1
svg.model@5.1.1
svg.scenegraph@5.1.1
svg.skia@5.1.1
system.buffers@4.5.1
system.buffers@4.6.0
system.buffers@4.6.1
system.collections.immutable@9.0.0
system.composition.attributedmodel@10.0.12
system.composition.hosting@10.0.12
system.composition.runtime@10.0.12
system.composition.typedparts@10.0.12
system.diagnostics.eventlog@10.0.12
system.formats.nrbf@10.0.12
system.io.hashing@10.0.12
system.memory@4.5.5
system.memory@4.6.0
system.memory@4.6.3
system.numerics.vectors@4.4.0
system.numerics.vectors@4.6.0
system.numerics.vectors@4.6.1
system.reflection.metadata@10.0.12
system.reflection.metadata@9.0.0
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.compilerservices.unsafe@6.1.0
system.runtime.compilerservices.unsafe@6.1.2
system.security.cryptography.pkcs@10.0.12
system.security.cryptography.protecteddata@8.0.0
system.text.encoding.codepages@8.0.0
system.threading.tasks.extensions@4.6.0
textmatesharp.grammars@2.0.3
textmatesharp@2.0.3
tmds.dbus.protocol@0.94.1
tomstoolbox.composition.analyzer@2.24.0
tunnelvisionlabs.referenceassemblyannotator@1.0.0-alpha.160
xaml.behaviors.animations@12.0.7
xaml.behaviors.avalonia@12.0.7
xaml.behaviors.interactions.custom@12.0.7
xaml.behaviors.interactions.draganddrop@12.0.7
xaml.behaviors.interactions.draggable@12.0.7
xaml.behaviors.interactions.events@12.0.7
xaml.behaviors.interactions.responsive@12.0.7
xaml.behaviors.interactions@12.0.7
xaml.behaviors.interactivity@12.0.7
"

inherit check-reqs desktop dotnet-pkg xdg-utils

DESCRIPTION="Cross-platform .NET Decompiler"
HOMEPAGE="https://github.com/icsharpcode/ILSpy/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/icsharpcode/ILSpy.git"
	EGIT_SUBMODULES=()
else
	SRC_URI="https://github.com/icsharpcode/ILSpy/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/ILSpy-${PV}"
	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0 MIT"
SLOT="0"
IUSE="gui"

RDEPEND="
	gui? (
		app-arch/brotli
		dev-libs/elfutils
		dev-libs/expat
		|| (
			<dev-libs/libxml2-2.14
			dev-libs/libxml2-compat
		)
		media-gfx/graphite2
		media-libs/fontconfig
		media-libs/freetype
		media-libs/harfbuzz
		media-libs/libglvnd
		media-libs/libpng
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXcursor
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libdrm
		x11-libs/libxcb
		x11-libs/libxshmfence
	)
"
BDEPEND="
	>=virtual/pwsh-7.6
"

CHECKREQS_DISK_BUILD="2G"
DOCS=( {CONTRIBUTING,README,SECURITY}.md )
DOTNET_PKG_PROJECTS=( ICSharpCode.ILSpyCmd/ICSharpCode.ILSpyCmd.csproj )
DOTNET_PKG_RESTORE_EXTRA_ARGS=( --force-evaluate )

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
	if use gui ; then
		DOTNET_PKG_PROJECTS+=( ILSpy/ILSpy.csproj )
	fi

	rm -f *.sln* || die
	dotnet-pkg_src_prepare
	edotnet new sln --format sln --name ILSpy
	edotnet sln ./ILSpy.sln add ${DOTNET_PKG_PROJECTS[*]}
}

src_install() {
	dotnet-pkg-base_install

	local -a net_exes=( ilspycmd )
	if use gui ; then
		net_exes+=( ILSpy )
	fi
	local net_exe=""
	for net_exe in "${net_exes[@]}" ; do
		dotnet-pkg-base_dolauncher "/usr/share/${P}/${net_exe}" "${net_exe}"
	done

	if use gui ; then
		doicon -s 256 "./BuildTools/packaging/linux/${PN}.png"
		make_desktop_entry ILSpy ILSpy ilspy "System;"
	fi

	einstalldocs
}

pkg_postinst() {
	if use gui ; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi
}

pkg_postrm() {
	if use gui ; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi
}
