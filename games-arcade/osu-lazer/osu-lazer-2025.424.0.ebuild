# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="8.0"
NUGETS="
automapper@13.0.1
diffplex@1.7.2
discordrichpresence@1.2.1.24
ffmpeg.autogen@4.3.0.1
fody@6.9.1
hidsharpcore@1.2.1.1
htmlagilitypack@1.11.72
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
jetbrains.annotations@2023.3.0
managed-midi@1.10.1
markdig@0.23.0
messagepack.annotations@3.1.3
messagepack@3.1.3
messagepackanalyzer@3.1.3
microsoft.aspnetcore.connections.abstractions@9.0.2
microsoft.aspnetcore.http.connections.client@9.0.2
microsoft.aspnetcore.http.connections.common@9.0.2
microsoft.aspnetcore.signalr.client.core@9.0.2
microsoft.aspnetcore.signalr.client@9.0.2
microsoft.aspnetcore.signalr.common@9.0.2
microsoft.aspnetcore.signalr.protocols.json@9.0.2
microsoft.aspnetcore.signalr.protocols.messagepack@9.0.2
microsoft.aspnetcore.signalr.protocols.newtonsoftjson@9.0.2
microsoft.bcl.asyncinterfaces@9.0.2
microsoft.bcl.timeprovider@9.0.2
microsoft.codeanalysis.bannedapianalyzers@3.3.4
microsoft.csharp@4.5.0
microsoft.data.sqlite.core@9.0.2
microsoft.diagnostics.netcore.client@0.2.61701
microsoft.diagnostics.runtime@2.0.161401
microsoft.dotnet.platformabstractions@2.0.3
microsoft.extensions.configuration.abstractions@9.0.2
microsoft.extensions.dependencyinjection.abstractions@6.0.0
microsoft.extensions.dependencyinjection.abstractions@6.0.0-rc.1.21451.13
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.dependencyinjection.abstractions@9.0.2
microsoft.extensions.dependencyinjection@6.0.0-rc.1.21451.13
microsoft.extensions.dependencyinjection@9.0.2
microsoft.extensions.dependencymodel@2.0.3
microsoft.extensions.features@9.0.2
microsoft.extensions.logging.abstractions@8.0.0
microsoft.extensions.logging.abstractions@9.0.2
microsoft.extensions.logging@9.0.2
microsoft.extensions.objectpool@5.0.11
microsoft.extensions.options@6.0.0
microsoft.extensions.options@9.0.2
microsoft.extensions.primitives@6.0.0
microsoft.extensions.primitives@9.0.2
microsoft.net.stringtools@17.11.4
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@2.0.0
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.toolkit.highperformance@7.1.2
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@4.5.0
microsoft.win32.registry@5.0.0
mongodb.bson@2.21.0
nativelibraryloader@1.0.13
netstandard.library@1.6.1
netstandard.library@2.0.0
newtonsoft.json@13.0.1
newtonsoft.json@13.0.3
nuget.versioning@6.12.1
nunit@3.14.0
opentabletdriver.configurations@0.6.5.1
opentabletdriver.native@0.6.5.1
opentabletdriver.plugin@0.6.5.1
opentabletdriver@0.6.5.1
polysharp@1.10.0
ppy.localisationanalyser@2024.802.0
ppy.managedbass.fx@2022.1216.0
ppy.managedbass.mix@2022.1216.0
ppy.managedbass.wasapi@2022.1216.0
ppy.managedbass@2022.1216.0
ppy.osu.framework.nativelibs@2024.809.1-nativelibs
ppy.osu.framework.sourcegeneration@2024.1128.0
ppy.osu.framework@2025.419.0
ppy.osu.game.resources@2025.321.0
ppy.osutk.ns20@1.0.211
ppy.sdl2-cs@1.0.741-alpha
ppy.sdl3-cs@2025.220.0
ppy.veldrid.metalbindings@4.9.62-gca0239da6b
ppy.veldrid.openglbindings@4.9.62-gca0239da6b
ppy.veldrid.spirv@1.0.15-gfbb03d21c2
ppy.veldrid@4.9.62-gca0239da6b
ppy.vk@1.0.26
realm@20.1.0
remotion.linq@2.2.0
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
runtime.any.system.threading.timer@4.3.0
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system.io.compression@4.3.0
runtime.native.system.net.http@4.3.0
runtime.native.system.net.security@4.3.0
runtime.native.system.security.cryptography.apple@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system@4.0.0
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.unix.microsoft.win32.primitives@4.3.0
runtime.unix.system.console@4.3.0
runtime.unix.system.diagnostics.debug@4.3.0
runtime.unix.system.io.filesystem@4.3.0
runtime.unix.system.net.primitives@4.3.0
runtime.unix.system.net.sockets@4.3.0
runtime.unix.system.private.uri@4.3.0
runtime.unix.system.runtime.extensions@4.3.0
sentry@5.1.1
sharpcompress@0.39.0
sharpfnt@2.0.0
sharpgen.runtime.com@2.0.0-beta.13
sharpgen.runtime@2.0.0-beta.13
sixlabors.imagesharp@3.1.7
sqlitepclraw.bundle_e_sqlite3@2.1.10
sqlitepclraw.core@2.1.10
sqlitepclraw.lib.e_sqlite3@2.1.10
sqlitepclraw.provider.e_sqlite3@2.1.10
stbisharp@1.1.0
system.appcontext@4.1.0
system.appcontext@4.3.0
system.buffers@4.3.0
system.buffers@4.5.1
system.buffers@4.6.0
system.collections.concurrent@4.3.0
system.collections.immutable@1.7.1
system.collections@4.0.11
system.collections@4.3.0
system.componentmodel.annotations@5.0.0
system.console@4.3.0
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.diagnosticsource@9.0.2
system.diagnostics.tools@4.3.0
system.diagnostics.tracing@4.3.0
system.dynamic.runtime@4.0.11
system.dynamic.runtime@4.3.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.0.11
system.globalization@4.3.0
system.io.compression.zipfile@4.3.0
system.io.compression@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.0.1
system.io.filesystem@4.3.0
system.io.packaging@9.0.2
system.io.pipelines@9.0.2
system.io@4.1.0
system.io@4.3.0
system.linq.expressions@4.1.0
system.linq.expressions@4.3.0
system.linq.queryable@4.0.1
system.linq@4.1.0
system.linq@4.3.0
system.memory@4.5.3
system.memory@4.5.4
system.memory@4.5.5
system.net.http@4.3.0
system.net.nameresolution@4.3.0
system.net.primitives@4.3.0
system.net.security@4.3.2
system.net.serversentevents@9.0.2
system.net.sockets@4.3.0
system.net.webheadercollection@4.3.0
system.net.websockets.client@4.3.2
system.net.websockets@4.3.0
system.numerics.tensors@8.0.0
system.objectmodel@4.0.12
system.objectmodel@4.3.0
system.private.uri@4.3.0
system.reflection.emit.ilgeneration@4.0.1
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.0.1
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.0.1
system.reflection.emit@4.3.0
system.reflection.extensions@4.0.1
system.reflection.extensions@4.3.0
system.reflection.metadata@1.8.1
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.1.0
system.reflection.typeextensions@4.3.0
system.reflection@4.1.0
system.reflection@4.3.0
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@4.7.1
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.compilerservices.unsafe@6.0.0-rc.1.21451.13
system.runtime.extensions@4.1.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.0.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.1.0
system.runtime@4.3.0
system.security.accesscontrol@4.5.0
system.security.accesscontrol@5.0.0
system.security.claims@4.3.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.x509certificates@4.3.0
system.security.principal.windows@4.3.0
system.security.principal.windows@4.5.0
system.security.principal.windows@5.0.0
system.security.principal@4.3.0
system.text.encoding.extensions@4.3.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.text.encodings.web@9.0.2
system.text.json@9.0.2
system.text.regularexpressions@4.3.0
system.threading.channels@6.0.0
system.threading.channels@9.0.2
system.threading.tasks.extensions@4.3.0
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.threadpool@4.3.0
system.threading.timer@4.3.0
system.threading@4.0.11
system.threading@4.3.0
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.3.0
taglibsharp@2.3.0
velopack@0.0.1053
vortice.d3dcompiler@2.4.2
vortice.direct3d11@2.4.2
vortice.directx@2.4.2
vortice.dxgi@2.4.2
vortice.mathematics@1.4.25
zstdsharp.port@0.8.4
"

inherit check-reqs desktop dotnet-pkg xdg-utils

DESCRIPTION="A free-to-win rhythm game and a final iteration of the osu! game client"
HOMEPAGE="https://osu.ppy.sh/
	https://github.com/ppy/osu/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ppy/osu"
else
	SRC_URI="https://github.com/ppy/osu/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/osu-${PV}"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

# "all-rights-reserved" - ships a copy of proprietary BASS lib - https://www.un4seen.com
LICENSE="Apache-2.0 BSD-2 LGPL-2.1 LGPL-3+ MIT all-rights-reserved"
SLOT="0"
IUSE="+pipewire"
RESTRICT="test" # > The active test run was aborted. Reason: Test host process crashed

RDEPEND="
	pipewire? (
		media-video/pipewire[pipewire-alsa]
	)
"

CHECKREQS_DISK_BUILD="3G"
DOTNET_PKG_PROJECTS=(
	osu.Desktop/osu.Desktop.csproj
)
DOTNET_PKG_BAD_PROJECTS=(
	osu.Game.Benchmarks
	osu.Game.Rulesets.Catch.Tests{,.Android,.iOS}
	osu.Game.Rulesets.Mania.Tests{,.Android,.iOS}
	osu.Game.Rulesets.Osu.Tests{,.Android,.iOS}
	osu.Game.Rulesets.Taiko.Tests{,.Android,.iOS}
	osu.Game.Tests{,.Android,.iOS}
	osu.Game.Tournament.Tests
	osu.{Android,iOS}
	Templates/Rulesets/ruleset-empty/osu.Game.Rulesets.EmptyFreeform{,.Tests}
	Templates/Rulesets/ruleset-example/osu.Game.Rulesets.Pippidon{,.Tests}
	Templates/Rulesets/ruleset-scrolling-empty/osu.Game.Rulesets.EmptyScrolling{,.Tests}
	Templates/Rulesets/ruleset-scrolling-example/osu.Game.Rulesets.Pippidon{,.Tests}
)

pkg_setup() {
	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
}

src_test() {
	local -a test_projects=(
		osu.Game.Rulesets.Mania.Tests
		osu.Game.Rulesets.Osu.Tests
		osu.Game.Tests
	)
	local test_project=""
	for test_project in "${test_projects[@]}" ; do
		nonfatal \
			dotnet-pkg-base_test "${test_project}"
	done
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_append-launchervar "OSU_EXTERNAL_UPDATE_PROVIDER='1'"
	dotnet-pkg-base_dolauncher "/usr/share/${P}/osu!" "${PN}"

	newicon -s 128 assets/lazer-nuget.png "${PN}.png"
	newicon -s 1024 assets/lazer.png "${PN}.png"
	make_desktop_entry "${PN}"

	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update

	if ! use pipewire ; then
		ewarn "osu!'s sound comes from the BASS driver, such driver requires"
		ewarn "a connection to ALSA. You might not have sound in your game."
	fi

	ewarn "Score submissions are disabled for osu!lazer source builds;"
	ewarn "only official binaries can submit."
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
