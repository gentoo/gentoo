# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=7.0
PYTHON_COMPAT=( python3_{10..12} )

NUGETS="
ace4896.dbus.services.secrets@1.1.0
docnet.core@2.3.1
fuzzysharp@2.0.2
gettext.net@1.8.7
gircore.adw-1@0.4.0
gircore.cairo-1.0@0.4.0
gircore.freetype2-2.0@0.4.0
gircore.gdk-4.0@0.4.0
gircore.gdkpixbuf-2.0@0.4.0
gircore.gio-2.0@0.4.0
gircore.glib-2.0@0.4.0
gircore.gobject-2.0@0.4.0
gircore.graphene-1.0@0.4.0
gircore.gsk-4.0@0.4.0
gircore.gtk-4.0@0.4.0
gircore.harfbuzz-0.0@0.4.0
gircore.pango-1.0@0.4.0
gircore.pangocairo-1.0@0.4.0
harfbuzzsharp.nativeassets.linux@2.8.2.3
harfbuzzsharp.nativeassets.macos@2.8.2.3
harfbuzzsharp.nativeassets.macos@2.8.2.4-preview.84
harfbuzzsharp.nativeassets.win32@2.8.2.3
harfbuzzsharp.nativeassets.win32@2.8.2.4-preview.84
harfbuzzsharp@2.8.2.3
harfbuzzsharp@2.8.2.4-preview.84
hazzik.qif@1.0.3
livechartscore.skiasharpview@2.0.0-beta.910
livechartscore@2.0.0-beta.910
markdig@0.31.0
meziantou.framework.win32.credentialmanager@1.4.2
microsoft.data.sqlite.core@7.0.11
microsoft.data.sqlite.core@7.0.5
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@5.0.0
microsoft.win32.primitives@4.3.0
netstandard.library@1.6.1
nickvision.aura@2023.9.3
nickvision.girext@2023.7.3
ofxsharp.netstandard@1.0.0
pdfsharpcore@1.3.56
questpdf@2023.5.1
readsharp.ports.sgmlreader.core@1.0.0
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
sharpziplib@1.3.3
sixlabors.fonts@1.0.0-beta17
sixlabors.imagesharp@2.1.3
skiasharp.harfbuzz@2.88.3
skiasharp.harfbuzz@2.88.4-preview.84
skiasharp.nativeassets.linux@2.88.3
skiasharp.nativeassets.macos@2.88.3
skiasharp.nativeassets.macos@2.88.4-preview.84
skiasharp.nativeassets.win32@2.88.3
skiasharp.nativeassets.win32@2.88.4-preview.84
skiasharp@2.88.3
skiasharp@2.88.4-preview.84
sqlitepclraw.bundle_e_sqlcipher@2.1.5
sqlitepclraw.core@2.1.4
sqlitepclraw.core@2.1.5
sqlitepclraw.lib.e_sqlcipher@2.1.5
sqlitepclraw.provider.e_sqlcipher@2.1.5
system.appcontext@4.3.0
system.buffers@4.3.0
system.collections.concurrent@4.3.0
system.collections@4.3.0
system.console@4.3.0
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.tools@4.3.0
system.diagnostics.tracing@4.3.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.compression.zipfile@4.3.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io.pipelines@6.0.0
system.io@4.3.0
system.linq.expressions@4.3.0
system.linq@4.3.0
system.memory@4.5.3
system.net.http@4.3.0
system.net.primitives@4.3.0
system.net.requests@4.3.0
system.net.sockets@4.3.0
system.net.webheadercollection@4.3.0
system.objectmodel@4.3.0
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.3.0
system.reflection.extensions@4.3.0
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.3.0
system.reflection@4.3.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.3.0
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
system.text.encoding.codepages@5.0.0
system.text.encoding.extensions@4.3.0
system.text.encoding@4.3.0
system.text.regularexpressions@4.3.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks@4.3.0
system.threading.timer@4.3.0
system.threading@4.3.0
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.3.0
tmds.dbus.protocol@0.15.0
tmds.dbus@0.15.0
"

inherit check-reqs desktop dotnet-pkg gnome2-utils python-any-r1 xdg

DESCRIPTION="A personal finance manager"
HOMEPAGE="https://github.com/NickvisionApps/Denaro/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/NickvisionApps/${PN^}.git"
else
	SRC_URI="https://github.com/NickvisionApps/${PN^}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${P^}"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=gui-libs/gtk-4.10:4
	app-arch/brotli
	dev-libs/glib
	gui-libs/libadwaita:1
	media-libs/freetype
	media-libs/harfbuzz
"
BDEPEND="
	${PYTHON_DEPS}
	${RDEPEND}
	dev-util/blueprint-compiler
"

CHECKREQS_DISK_BUILD="1G"
DOTNET_PKG_PROJECTS=( NickvisionMoney.GNOME/NickvisionMoney.GNOME.csproj )
DOTNET_PKG_BUILD_EXTRA_ARGS=( -p:WarningLevel=0 )

DOCS=( CONTRIBUTING.md README.md )

pkg_setup() {
	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
	python-any-r1_pkg_setup
}

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_compile() {
	ebegin "Compiling gresources"
	glib-compile-resources --sourcedir NickvisionMoney.GNOME/Resources \
		NickvisionMoney.GNOME/Resources/org.nickvision.money.gresource.xml
	eend ${?} || die "failed to compile gresources"

	dotnet-pkg_src_compile

	cd "${S}/NickvisionMoney.Shared" || die
	cp org.nickvision.money.desktop.in org.nickvision.money.desktop || die
	sed -i "s|@EXEC@|${PN}|" org.nickvision.money.desktop || die
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/NickvisionMoney.GNOME" "${PN}"

	insinto /usr/share/org.nickvision.money
	doins NickvisionMoney.GNOME/Resources/*.gresource

	insinto /usr/share/icons/hicolor/scalable/apps
	doins NickvisionMoney.Shared/Resources/org.*.svg

	insinto /usr/share/icons/hicolor/symbolic/apps
	doins NickvisionMoney.GNOME/Resources/*.svg

	domenu NickvisionMoney.Shared/org.nickvision.money.desktop

	einstalldocs
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}
