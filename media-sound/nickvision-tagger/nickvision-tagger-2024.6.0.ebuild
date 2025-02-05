# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=9.0
NUGETS="
ace4896.dbus.services.secrets@1.2.0
acoustid.net@1.3.3
fuzzysharp@2.0.2
gettext.net@1.9.14
gircore.adw-1@0.5.0
gircore.cairo-1.0@0.5.0
gircore.freetype2-2.0@0.5.0
gircore.gdk-4.0@0.5.0
gircore.gdkpixbuf-2.0@0.5.0
gircore.gio-2.0@0.5.0
gircore.glib-2.0@0.5.0
gircore.gobject-2.0@0.5.0
gircore.graphene-1.0@0.5.0
gircore.gsk-4.0@0.5.0
gircore.gtk-4.0@0.5.0
gircore.harfbuzz-0.0@0.5.0
gircore.pango-1.0@0.5.0
gircore.pangocairo-1.0@0.5.0
htmlagilitypack@1.11.61
markdig@0.33.0
metabrainz.common.json@6.0.2
metabrainz.common@3.0.0
metabrainz.musicbrainz.coverart@6.0.0
metabrainz.musicbrainz@6.1.0
meziantou.framework.win32.credentialmanager@1.4.5
microsoft.data.sqlite.core@8.0.0
microsoft.netcore.targets@5.0.0
microsoft.win32.systemevents@8.0.0
nickvision.aura@2023.11.4
octokit@9.0.0
sixlabors.imagesharp@3.1.4
sqlitepclraw.bundle_e_sqlcipher@2.1.6
sqlitepclraw.core@2.1.6
sqlitepclraw.lib.e_sqlcipher@2.1.6
sqlitepclraw.provider.e_sqlcipher@2.1.6
system.drawing.common@8.0.0
system.io.pipelines@6.0.0
system.memory@4.5.3
system.memory@4.5.5
system.text.encoding.codepages@8.0.0
tmds.dbus.protocol@0.15.0
tmds.dbus@0.15.0
ude.netstandard@1.2.0
z440.atl.core@5.25.0
"

REAL_PN=Tagger
REAL_PV="${PV}-1"
REAL_P=${REAL_PN}-${REAL_PV}

inherit desktop dotnet-pkg xdg

DESCRIPTION="An easy-to-use music tag (metadata) editor"
HOMEPAGE="https://github.com/NickvisionApps/Tagger"
SRC_URI="https://github.com/NickvisionApps/${REAL_PN}/archive/${REAL_PV}.tar.gz
	-> ${PN}-${REAL_PV}.tar.gz
"
SRC_URI+=" ${NUGET_URIS} "

S="${WORKDIR}"/${REAL_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	dev-libs/glib
	gui-libs/gdk-pixbuf-loader-webp
	gui-libs/gtk:4
	gui-libs/libadwaita:=
"
RDEPEND="
	${DEPEND}
	media-libs/chromaprint[tools]
	x11-themes/adwaita-icon-theme
"
BDEPEND="dev-util/blueprint-compiler"

PATCHES=( "${FILESDIR}"/${PN}-2024.6.0-csproj-net9.patch )

DOTNET_PKG_BAD_PROJECTS=( NickvisionTagger.WinUI/NickvisionTagger.WinUI.csproj )
DOTNET_PKG_PROJECTS=( NickvisionTagger.GNOME/NickvisionTagger.GNOME.csproj )

src_compile() {
	ebegin "Compiling gresources"
	glib-compile-resources --sourcedir NickvisionTagger.GNOME/Resources \
		NickvisionTagger.GNOME/Resources/org.nickvision.tagger.gresource.xml
	eend ${?} || die "failed to compile gresources"

	dotnet-pkg_src_compile
}

src_install() {
	dotnet-pkg-base_install "/usr/share/org.nickvision.tagger"
	dotnet-pkg-base_dolauncher \
		"/usr/share/org.nickvision.tagger/NickvisionTagger.GNOME" \
		org.nickvision.tagger
	dosym org.nickvision.tagger /usr/bin/tagger

	sed -e "s:@EXEC@:/usr/bin/org.nickvision.tagger:" \
		-i NickvisionTagger.Shared/Linux/org.nickvision.tagger.desktop.in \
		|| die
	newmenu "NickvisionTagger.Shared/Linux/org.nickvision.tagger.desktop.in" \
		org.nickvision.tagger.desktop

	insinto /usr/share/icons/hicolor/scalable/apps
	doins NickvisionTagger.Shared/Resources/org.nickvision.tagger{,-devel}.svg

	insinto /usr/share/icons/hicolor/symbolic/apps
	doins NickvisionTagger.Shared/Resources/org.nickvision.tagger-symbolic.svg

	local DOCS=( CONTRIBUTING.md README.md NickvisionTagger.Shared/Docs/yelp )
	local HTML_DOCS=( NickvisionTagger.Shared/Docs/html/* )
	einstalldocs
}
