# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
avalonia.angle.windows.natives@2.1.25547.20250602
avalonia.avaloniaedit@11.3.0
avalonia.buildservices@11.3.2
avalonia.controls.colorpicker@11.3.9
avalonia.controls.datagrid@11.3.9
avalonia.desktop@11.3.9
avalonia.diagnostics@11.3.9
avalonia.fonts.inter@11.3.9
avalonia.freedesktop@11.3.9
avalonia.native@11.3.9
avalonia.remote.protocol@11.3.9
avalonia.skia@11.0.0
avalonia.skia@11.3.9
avalonia.themes.fluent@11.3.9
avalonia.themes.simple@11.3.9
avalonia.win32@11.3.9
avalonia.x11@11.3.9
avalonia@11.3.9
avaloniaedit.textmate@11.3.0
azure.ai.openai@2.5.0-beta.1
azure.core@1.49.0
bitmiracle.libtiff.net@2.4.660
communitytoolkit.mvvm@8.4.0
harfbuzzsharp.nativeassets.linux@8.3.1.1
harfbuzzsharp.nativeassets.macos@8.3.1.1
harfbuzzsharp.nativeassets.webassembly@8.3.1.1
harfbuzzsharp.nativeassets.win32@8.3.1.1
harfbuzzsharp@7.3.0.3
harfbuzzsharp@8.3.1.1
livechartscore.skiasharpview.avalonia@2.0.0-rc6.1
livechartscore.skiasharpview@2.0.0-rc6.1
livechartscore@2.0.0-rc6.1
microcom.runtime@0.11.0
microsoft.bcl.asyncinterfaces@8.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.2
microsoft.extensions.logging.abstractions@8.0.3
onigwrap@1.0.8
openai@2.5.0
pfim@0.11.3
skiasharp.harfbuzz@2.88.9
skiasharp.nativeassets.linux@2.88.9
skiasharp.nativeassets.macos@2.88.9
skiasharp.nativeassets.webassembly@2.88.9
skiasharp.nativeassets.win32@2.88.9
skiasharp@2.88.9
system.clientmodel@1.6.1
system.clientmodel@1.7.0
system.memory.data@8.0.1
textmatesharp.grammars@1.0.70
textmatesharp@1.0.70
tmds.dbus.protocol@0.21.2
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

dotnet-pkg_force-compat

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

	rm SourceGit.slnx || die

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
