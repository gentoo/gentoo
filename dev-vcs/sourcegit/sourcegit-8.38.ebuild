# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="8.0"
NUGETS="
avalonia.angle.windows.natives@2.1.22045.20230930
avalonia.avaloniaedit@11.1.0
avalonia.buildservices@0.0.29
avalonia.controls.colorpicker@11.1.4
avalonia.controls.datagrid@11.1.4
avalonia.desktop@11.1.4
avalonia.diagnostics@11.1.4
avalonia.fonts.inter@11.1.4
avalonia.freedesktop@11.1.4
avalonia.native@11.1.4
avalonia.remote.protocol@11.1.4
avalonia.skia@11.0.0
avalonia.skia@11.1.4
avalonia.themes.fluent@11.1.4
avalonia.themes.simple@11.1.4
avalonia.win32@11.1.4
avalonia.x11@11.1.4
avalonia@11.1.4
avaloniaedit.textmate@11.1.0
communitytoolkit.mvvm@8.3.2
harfbuzzsharp.nativeassets.linux@2.8.2.3
harfbuzzsharp.nativeassets.linux@7.3.0.2
harfbuzzsharp.nativeassets.macos@2.8.2.3
harfbuzzsharp.nativeassets.macos@7.3.0.2
harfbuzzsharp.nativeassets.webassembly@2.8.2.3
harfbuzzsharp.nativeassets.webassembly@7.3.0.2
harfbuzzsharp.nativeassets.win32@2.8.2.3
harfbuzzsharp.nativeassets.win32@7.3.0.2
harfbuzzsharp@2.8.2.3
harfbuzzsharp@7.3.0.2
livechartscore.skiasharpview.avalonia@2.0.0-rc3.3
livechartscore.skiasharpview@2.0.0-rc3.3
livechartscore@2.0.0-rc3.3
microcom.runtime@0.11.0
onigwrap@1.0.6
skiasharp.harfbuzz@2.88.8
skiasharp.nativeassets.linux@2.88.3
skiasharp.nativeassets.linux@2.88.8
skiasharp.nativeassets.macos@2.88.3
skiasharp.nativeassets.macos@2.88.8
skiasharp.nativeassets.webassembly@2.88.3
skiasharp.nativeassets.webassembly@2.88.8
skiasharp.nativeassets.win32@2.88.3
skiasharp.nativeassets.win32@2.88.8
skiasharp@2.88.3
skiasharp@2.88.8
system.io.pipelines@6.0.0
system.numerics.vectors@4.5.0
system.text.encodings.web@8.0.0
system.text.json@8.0.4
textmatesharp.grammars@1.0.63
textmatesharp@1.0.63
tmds.dbus.protocol@0.16.0
"

inherit check-reqs dotnet-pkg desktop xdg

DESCRIPTION="Open Source Git GUI client using .NET AvaloniaUI"
HOMEPAGE="https://github.com/sourcegit-scm/sourcegit/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sourcegit-scm/${PN}.git"
else
	SRC_URI="https://github.com/sourcegit-scm/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
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
	sed -i "./build/resources/_common/applications/${PN}.desktop"	\
		-e "s|/opt/sourcegit/sourcegit|sourcegit|g"	\
		-e "s|/usr/share/icons/sourcegit.png|sourcegit|g"	\
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
