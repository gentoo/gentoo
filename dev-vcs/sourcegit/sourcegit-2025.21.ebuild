# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="9.0"
NUGETS="
avalonia.angle.windows.natives@2.1.22045.20230930
avalonia.avaloniaedit@11.2.0
avalonia.buildservices@0.0.31
avalonia.controls.colorpicker@11.2.8
avalonia.controls.datagrid@11.2.8
avalonia.desktop@11.2.8
avalonia.diagnostics@11.2.8
avalonia.fonts.inter@11.2.8
avalonia.freedesktop@11.2.8
avalonia.native@11.2.8
avalonia.remote.protocol@11.2.8
avalonia.skia@11.0.0
avalonia.skia@11.2.8
avalonia.themes.fluent@11.2.8
avalonia.themes.simple@11.2.8
avalonia.win32@11.2.8
avalonia.x11@11.2.8
avalonia@11.0.0
avalonia@11.2.8
avaloniaedit.textmate@11.2.0
azure.ai.openai@2.2.0-beta.4
azure.core@1.44.1
communitytoolkit.mvvm@8.4.0
harfbuzzsharp.nativeassets.linux@7.3.0.3
harfbuzzsharp.nativeassets.macos@7.3.0.3
harfbuzzsharp.nativeassets.webassembly@7.3.0.3
harfbuzzsharp.nativeassets.win32@7.3.0.3
harfbuzzsharp@7.3.0.3
livechartscore.skiasharpview.avalonia@2.0.0-rc5.4
livechartscore.skiasharpview@2.0.0-rc5.4
livechartscore@2.0.0-rc5.4
microcom.runtime@0.11.0
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.extensions.logging.abstractions@6.0.0
onigwrap@1.0.6
openai@2.2.0-beta.4
pfim@0.11.3
skiasharp.harfbuzz@2.88.9
skiasharp.nativeassets.linux@2.88.9
skiasharp.nativeassets.macos@2.88.9
skiasharp.nativeassets.webassembly@2.88.9
skiasharp.nativeassets.win32@2.88.9
skiasharp@2.88.9
system.clientmodel@1.1.0
system.clientmodel@1.2.1
system.clientmodel@1.4.0-beta.1
system.diagnostics.diagnosticsource@6.0.1
system.io.pipelines@8.0.0
system.memory.data@6.0.0
system.memory.data@6.0.1
system.numerics.vectors@4.5.0
system.runtime.compilerservices.unsafe@6.0.0
system.text.encodings.web@6.0.0
system.text.json@6.0.0
system.text.json@6.0.10
system.text.json@8.0.5
system.threading.tasks.extensions@4.5.4
textmatesharp.grammars@1.0.65
textmatesharp.grammars@1.0.66
textmatesharp@1.0.65
textmatesharp@1.0.66
tmds.dbus.protocol@0.20.0
"

inherit check-reqs dotnet-pkg desktop xdg

DESCRIPTION="Open Source Git GUI client using .NET AvaloniaUI"
HOMEPAGE="https://github.com/sourcegit-scm/sourcegit/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sourcegit-scm/${PN}"
else
	SRC_URI="https://github.com/sourcegit-scm/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

RDEPEND="
	app-arch/brotli
	app-arch/bzip2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libpcre2
	dev-vcs/git
	media-gfx/graphite2
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/harfbuzz
	media-libs/libpng
"

CHECKREQS_DISK_BUILD="1G"
DOTNET_PKG_PROJECTS=( src/SourceGit.csproj )
DOTNET_PKG_BUILD_EXTRA_ARGS=( -p:DisableUpdateDetection="true" )

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
	sed -i "./build/resources/_common/applications/${PN}.desktop" \
		-e "s|/opt/sourcegit/sourcegit|sourcegit|g" \
		-e "s|/usr/share/icons/sourcegit.png|sourcegit|g" \
		|| die

	dotnet-pkg_src_prepare
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/SourceGit" "${PN}"

	doicon "./build/resources/_common/icons/${PN}.png"
	domenu "./build/resources/_common/applications/${PN}.desktop"

	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
