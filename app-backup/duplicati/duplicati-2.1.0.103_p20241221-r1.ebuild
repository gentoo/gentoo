# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="8.0"
NUGETS="
aliyun.oss.sdk.netcore@2.13.0
alphavss.native.netcore@2.0.3
alphavss@2.0.3
artalk.xmpp@1.0.5
avalonia.angle.windows.natives@2.1.22045.20230930
avalonia.buildservices@0.0.29
avalonia.controls.colorpicker@11.2.0
avalonia.controls.datagrid@11.2.0
avalonia.desktop@11.2.0
avalonia.diagnostics@11.2.0
avalonia.freedesktop@11.2.0
avalonia.native@11.2.0
avalonia.remote.protocol@11.2.0
avalonia.skia@11.2.0
avalonia.themes.fluent@11.2.0
avalonia.themes.simple@11.2.0
avalonia.win32@11.2.0
avalonia.x11@11.2.0
avalonia@11.2.0
awssdk.core@3.7.107.3
awssdk.core@3.7.400.45
awssdk.identitymanagement@3.7.402.39
awssdk.s3@3.7.405.9
awssdk.secretsmanager.caching@1.0.6
awssdk.secretsmanager@3.7.102.54
azure.core@1.44.1
azure.identity@1.13.0
azure.security.keyvault.secrets@4.7.0
bouncycastle.cryptography@2.4.0
cocol@1.7.1
cocol@1.8.1
crc32.net@1.2.0
dnsclient@1.4.0
duplicati.streamutil@1.0.0
fluentftp@52.0.0
google.api.commonprotos@2.15.0
google.api.gax.grpc@4.8.0
google.api.gax@4.8.0
google.apis.auth@1.67.0
google.apis.core@1.67.0
google.apis@1.67.0
google.cloud.iam.v1@3.2.0
google.cloud.location@2.2.0
google.cloud.secretmanager.v1@2.5.0
google.protobuf@3.25.0
grpc.auth@2.60.0
grpc.core.api@2.60.0
grpc.net.client@2.60.0
grpc.net.common@2.60.0
harfbuzzsharp.nativeassets.linux@7.3.0.2
harfbuzzsharp.nativeassets.macos@7.3.0.2
harfbuzzsharp.nativeassets.webassembly@7.3.0.3-preview.2.2
harfbuzzsharp.nativeassets.win32@7.3.0.2
harfbuzzsharp@7.3.0.2
jose-jwt@5.0.0
mailkit@2.4.1
megaapiclient@1.10.4
meziantou.framework.win32.credentialmanager@1.7.0
microcom.runtime@0.11.0
microsoft.aspnetcore.authentication.jwtbearer@8.0.3
microsoft.aspnetcore.hostfiltering@2.2.0
microsoft.aspnetcore.hosting.abstractions@2.2.0
microsoft.aspnetcore.hosting.server.abstractions@2.2.0
microsoft.aspnetcore.http.abstractions@2.2.0
microsoft.aspnetcore.http.extensions@2.2.0
microsoft.aspnetcore.http.features@2.2.0
microsoft.aspnetcore.http@2.2.0
microsoft.aspnetcore.webutilities@2.2.0
microsoft.azure.keyvault.core@3.0.4
microsoft.azure.keyvault.webkey@3.0.4
microsoft.azure.storage.blob@11.0.1
microsoft.azure.storage.common@11.0.1
microsoft.azure.storage.file@11.0.1
microsoft.azure.storage.queue@11.0.1
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.codecoverage@17.1.0
microsoft.csharp@4.0.1
microsoft.csharp@4.5.0
microsoft.csharp@4.7.0
microsoft.dotnet.analyzers.compatibility@0.2.12-alpha
microsoft.extensions.apidescription.server@6.0.5
microsoft.extensions.caching.abstractions@7.0.0
microsoft.extensions.caching.memory@7.0.0
microsoft.extensions.configuration.abstractions@2.2.0
microsoft.extensions.configuration.abstractions@8.0.0
microsoft.extensions.configuration.binder@8.0.0
microsoft.extensions.configuration@8.0.0
microsoft.extensions.dependencyinjection.abstractions@2.2.0
microsoft.extensions.dependencyinjection.abstractions@6.0.0
microsoft.extensions.dependencyinjection.abstractions@7.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.dependencyinjection@8.0.0
microsoft.extensions.diagnostics.abstractions@8.0.0
microsoft.extensions.diagnostics@8.0.0
microsoft.extensions.fileproviders.abstractions@2.2.0
microsoft.extensions.hosting.abstractions@2.2.0
microsoft.extensions.http@8.0.0
microsoft.extensions.logging.abstractions@2.2.0
microsoft.extensions.logging.abstractions@6.0.0
microsoft.extensions.logging.abstractions@7.0.0
microsoft.extensions.logging.abstractions@8.0.0
microsoft.extensions.logging@8.0.0
microsoft.extensions.objectpool@2.2.0
microsoft.extensions.options.configurationextensions@8.0.0
microsoft.extensions.options@2.2.0
microsoft.extensions.options@7.0.0
microsoft.extensions.options@8.0.0
microsoft.extensions.primitives@2.2.0
microsoft.extensions.primitives@7.0.0
microsoft.extensions.primitives@8.0.0
microsoft.identity.client.extensions.msal@4.65.0
microsoft.identity.client@4.65.0
microsoft.identitymodel.abstractions@6.35.0
microsoft.identitymodel.abstractions@7.1.2
microsoft.identitymodel.abstractions@7.5.0
microsoft.identitymodel.jsonwebtokens@7.5.0
microsoft.identitymodel.logging@7.1.2
microsoft.identitymodel.logging@7.5.0
microsoft.identitymodel.protocols.openidconnect@7.1.2
microsoft.identitymodel.protocols@7.1.2
microsoft.identitymodel.tokens@7.5.0
microsoft.io.recyclablememorystream@3.0.0
microsoft.net.http.headers@2.2.0
microsoft.net.test.sdk@17.1.0
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.platforms@3.1.0
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.openapi@1.2.3
microsoft.rest.clientruntime.azure@3.3.19
microsoft.rest.clientruntime@2.3.24
microsoft.testplatform.objectmodel@17.1.0
microsoft.testplatform.testhost@17.1.0
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@5.0.0
microsoft.win32.systemevents@7.0.0
mimekit@2.4.1
minio@3.1.13
mono.unix@7.1.0-final.1.21458.1
netstandard.library@1.6.1
netstandard.library@2.0.0
netstandard.library@2.0.1
newtonsoft.json@13.0.1
newtonsoft.json@13.0.3
newtonsoft.json@9.0.1
ngettext@0.6.5
nuget.frameworks@5.11.0
nunit3testadapter@4.2.1
nunit@3.13.3
otp.net@1.4.0
portable.bouncycastle@1.8.5
restsharp@106.10.1
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
runtime.native.system.security.cryptography.apple@4.3.1
runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple@4.3.1
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
sharpaescrypt@2.0.2
sharpaescrypt@2.0.3
sharpcompress@0.36.0
sixlabors.fonts@2.0.3
sixlabors.imagesharp.drawing@2.1.3
sixlabors.imagesharp@3.1.5
skiasharp.nativeassets.linux@2.88.8
skiasharp.nativeassets.macos@2.88.8
skiasharp.nativeassets.webassembly@2.88.8
skiasharp.nativeassets.win32@2.88.8
skiasharp@2.88.8
sqlite-net-pcl@1.7.335
sqlitepclraw.bundle_green@2.0.3
sqlitepclraw.core@2.0.3
sqlitepclraw.lib.e_sqlite3@2.0.3
sqlitepclraw.provider.dynamic_cdecl@2.0.3
ssh.net@2024.2.0
stub.system.data.sqlite.core.netstandard@1.0.115
swashbuckle.aspnetcore.swagger@6.5.0
swashbuckle.aspnetcore.swaggergen@6.5.0
swashbuckle.aspnetcore.swaggerui@6.5.0
swashbuckle.aspnetcore@6.5.0
system.appcontext@4.3.0
system.buffers@4.3.0
system.buffers@4.5.0
system.clientmodel@1.1.0
system.codedom@7.0.0
system.codedom@8.0.0
system.collections.concurrent@4.3.0
system.collections@4.0.11
system.collections@4.3.0
system.commandline.namingconventionbinder@2.0.0-beta4.22272.1
system.commandline@2.0.0-beta4.22272.1
system.componentmodel.annotations@4.5.0
system.console@4.3.0
system.data.common@4.3.0
system.data.sqlite.core.duplicati.linux.arm64@1.0.116
system.data.sqlite.core.duplicati.linux.armv7@1.0.116
system.data.sqlite.core.duplicati.macos.arm64@1.0.116.1
system.data.sqlite.core.duplicati.windows.arm64@1.0.116.1
system.data.sqlite.core.msil@1.0.115
system.data.sqlite.core@1.0.115
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.diagnosticsource@6.0.1
system.diagnostics.diagnosticsource@8.0.0
system.diagnostics.eventlog@5.0.0
system.diagnostics.tools@4.0.1
system.diagnostics.tools@4.3.0
system.diagnostics.tracing@4.3.0
system.drawing.common@7.0.0
system.dynamic.runtime@4.0.11
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.0.11
system.globalization@4.3.0
system.identitymodel.tokens.jwt@7.5.0
system.io.compression.zipfile@4.3.0
system.io.compression@4.3.0
system.io.filesystem.accesscontrol@4.7.0
system.io.filesystem.primitives@4.0.1
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.0.1
system.io.filesystem@4.3.0
system.io.pipelines@8.0.0
system.io@4.1.0
system.io@4.3.0
system.linq.expressions@4.1.0
system.linq.expressions@4.3.0
system.linq@4.1.0
system.linq@4.3.0
system.management@7.0.2
system.management@8.0.0
system.memory.data@6.0.0
system.memory@4.5.1
system.memory@4.5.3
system.memory@4.5.5
system.net.http@4.3.0
system.net.http@4.3.4
system.net.nameresolution@4.3.0
system.net.primitives@4.3.0
system.net.security@4.3.2
system.net.sockets@4.3.0
system.numerics.vectors@4.5.0
system.objectmodel@4.0.12
system.objectmodel@4.3.0
system.private.uri@4.3.0
system.reactive.linq@4.3.2
system.reactive@4.3.2
system.reactive@6.0.0
system.reflection.emit.ilgeneration@4.0.1
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.0.1
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.0.1
system.reflection.emit@4.3.0
system.reflection.extensions@4.0.1
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.1.0
system.reflection.typeextensions@4.3.0
system.reflection@4.1.0
system.reflection@4.3.0
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@4.5.1
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.1.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.0.1
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.1.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime.serialization.primitives@4.1.1
system.runtime.serialization.primitives@4.3.0
system.runtime@4.1.0
system.runtime@4.3.0
system.security.accesscontrol@4.7.0
system.security.accesscontrol@5.0.0
system.security.claims@4.3.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.algorithms@4.3.1
system.security.cryptography.cng@4.3.0
system.security.cryptography.cng@4.7.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@4.5.0
system.security.cryptography.x509certificates@4.3.0
system.security.principal.windows@4.3.0
system.security.principal.windows@4.7.0
system.security.principal.windows@5.0.0
system.security.principal@4.3.0
system.serviceprocess.servicecontroller@5.0.0
system.text.encoding.codepages@4.3.0
system.text.encoding.extensions@4.0.11
system.text.encoding.extensions@4.3.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.text.encodings.web@4.5.0
system.text.encodings.web@6.0.0
system.text.json@5.0.2
system.text.json@6.0.10
system.text.regularexpressions@4.1.0
system.text.regularexpressions@4.3.0
system.threading.channels@8.0.0
system.threading.tasks.extensions@4.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.extensions@4.5.3
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.threadpool@4.3.0
system.threading.timer@4.3.0
system.threading@4.0.11
system.threading@4.3.0
system.xml.readerwriter@4.0.11
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.0.11
system.xml.xdocument@4.3.0
tencent.qcloud.cos.sdk@5.4.11
tmds.dbus.protocol@0.20.0
uplink.net.linux@2.13.3484
uplink.net.mac@2.13.3484
uplink.net.win@2.13.3484
uplink.net@2.13.3484
vaultsharp@1.7.0
websocket.client@5.1.2
windowsazure.storage@9.3.3
zstdsharp.port@0.7.4
"

inherit check-reqs dotnet-pkg

DESCRIPTION="Backup client that securely stores encrypted, incremental, compressed backups"
HOMEPAGE="https://duplicati.com/
	https://github.com/duplicati/duplicati/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	MAIN_V="$(ver_cut 1-4)"

	# Set proper upstream version and SLOT.
	if [[ "${PV}" == *_p20241221 ]] ; then
		REAL_V="${MAIN_V}-${MAIN_V}_canary_2024-12-21"
		SLOT="0/canary"
	else
		REAL_V="${PV}"
		SLOT="0"
	fi

	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${REAL_V}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${REAL_V}"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="Apache-2.0 BSD MIT"
IUSE="gui"
RESTRICT="test"  # TODO: Re-enable.

RDEPEND="
	gui? (
		app-arch/brotli
		dev-libs/elfutils
		dev-libs/expat
		dev-libs/libxml2:=
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

CHECKREQS_DISK_BUILD="3G"
DOTNET_PKG_PROJECTS=(
	Executables/net8/Duplicati.CommandLine
	Executables/net8/Duplicati.Server
)
DOTNET_PKG_BAD_PROJECTS=(
	Duplicati/WindowsService/Duplicati.WindowsService.csproj
	Executables/net8/Duplicati.WindowsService/Duplicati.WindowsService.csproj
)

DOCS=( README.ja-JP.md README.md README.zh-CN.md SECURITY.md changelog.txt )

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
	dotnet-pkg_src_prepare

	local -a bad_tests=(
		Duplicati/UnitTest/CompactDisruptionTests.cs
	)
	local bad_test=""
	for bad_test in "${bad_tests[@]}" ; do
		if [[ -e "${S}/${bad_test}" ]] ; then
			rm "${S}/${bad_test}" \
				|| eerror "failed to remove test ${bad_test}"
		else
			ewarn "Test file ${bad_test} does not exist"
		fi
	done
}

src_configure() {
	if use gui ; then
		DOTNET_PKG_PROJECTS+=( Executables/net8/Duplicati.GUI.TrayIcon )
	fi

	dotnet-pkg_src_configure
}

src_test() {
	dotnet-pkg-base_test ./Duplicati/UnitTest/Duplicati.UnitTest.csproj
}

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/Duplicati.CommandLine" duplicati
	dotnet-pkg-base_dolauncher "/usr/share/${P}/Duplicati.Server" duplicati-server

	if use gui ; then
		dotnet-pkg-base_dolauncher "/usr/share/${P}/Duplicati.GUI.TrayIcon" duplicati-gui
	fi

	einstalldocs
}
