# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="9.0"
NUGETS="
benchmarkdotnet.annotations@0.14.0
benchmarkdotnet@0.14.0
commandlineparser@2.9.1
gee.external.capstone@2.3.0
gircore.adw-1@0.6.3
gircore.cairo-1.0@0.6.3
gircore.freetype2-2.0@0.6.3
gircore.gdk-4.0@0.6.3
gircore.gdkpixbuf-2.0@0.6.3
gircore.gio-2.0@0.6.3
gircore.glib-2.0@0.6.3
gircore.gobject-2.0.integration@0.6.3
gircore.gobject-2.0@0.6.3
gircore.graphene-1.0@0.6.3
gircore.gsk-4.0@0.6.3
gircore.gtk-4.0@0.6.3
gircore.harfbuzz-0.0@0.6.3
gircore.pango-1.0@0.6.3
gircore.pangocairo-1.0@0.6.3
iced@1.17.0
microsoft.applicationinsights@2.22.0
microsoft.bcl.asyncinterfaces@1.1.0
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.common@4.8.0
microsoft.codeanalysis.csharp@4.1.0
microsoft.codeanalysis.csharp@4.8.0
microsoft.codecoverage@17.13.0
microsoft.diagnostics.netcore.client@0.2.251802
microsoft.diagnostics.runtime@2.2.332302
microsoft.diagnostics.tracing.traceevent@3.1.8
microsoft.dotnet.platformabstractions@3.1.6
microsoft.extensions.configuration.abstractions@2.1.1
microsoft.extensions.configuration.binder@2.1.1
microsoft.extensions.configuration@2.1.1
microsoft.extensions.dependencyinjection.abstractions@2.1.1
microsoft.extensions.logging.abstractions@2.1.1
microsoft.extensions.logging@2.1.1
microsoft.extensions.options@2.1.1
microsoft.extensions.primitives@2.1.1
microsoft.net.test.sdk@17.13.0
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.platforms@2.0.0
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.testing.extensions.telemetry@1.5.3
microsoft.testing.extensions.trxreport.abstractions@1.5.3
microsoft.testing.extensions.vstestbridge@1.5.3
microsoft.testing.platform.msbuild@1.5.3
microsoft.testing.platform@1.5.3
microsoft.testplatform.objectmodel@17.12.0
microsoft.testplatform.objectmodel@17.13.0
microsoft.testplatform.testhost@17.13.0
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@4.4.0
microsoft.win32.registry@5.0.0
mono.addins.cecilreflector@1.4.2-alpha.4
mono.addins.setup@1.4.2-alpha.4
mono.addins@1.4.2-alpha.4
mono.cecil@0.10.1
newtonsoft.json@13.0.1
ngettext@0.6.7
nunit3testadapter@5.0.0
nunit@4.3.2
paragonclipper@6.4.2
perfolizer@0.3.17
runtime.any.system.collections@4.3.0
runtime.any.system.diagnostics.tracing@4.3.0
runtime.any.system.globalization.calendars@4.3.0
runtime.any.system.globalization@4.3.0
runtime.any.system.io@4.3.0
runtime.any.system.reflection.primitives@4.3.0
runtime.any.system.reflection@4.3.0
runtime.any.system.resources.resourcemanager@4.3.0
runtime.any.system.runtime.handles@4.3.0
runtime.any.system.runtime.interopservices@4.3.0
runtime.any.system.runtime@4.3.0
runtime.any.system.text.encoding.extensions@4.3.0
runtime.any.system.text.encoding@4.3.0
runtime.any.system.threading.tasks@4.3.0
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system.net.http@4.3.0
runtime.native.system.security.cryptography.apple@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.unix.microsoft.win32.primitives@4.3.0
runtime.unix.system.diagnostics.debug@4.3.0
runtime.unix.system.io.filesystem@4.3.0
runtime.unix.system.net.primitives@4.3.0
runtime.unix.system.private.uri@4.3.0
runtime.unix.system.runtime.extensions@4.3.0
sharpziplib@1.3.3
system.buffers@4.3.0
system.codedom@5.0.0
system.collections.concurrent@4.3.0
system.collections.immutable@5.0.0
system.collections.immutable@6.0.0
system.collections.immutable@7.0.0
system.collections.nongeneric@4.3.0
system.collections.specialized@4.3.0
system.collections@4.0.11
system.collections@4.3.0
system.commandline@2.0.0-beta4.22272.1
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.diagnosticsource@5.0.0
system.diagnostics.tracing@4.3.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.filesystem.primitives@4.0.1
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.0.1
system.io.filesystem@4.3.0
system.io@4.1.0
system.io@4.3.0
system.linq@4.3.0
system.management@5.0.0
system.memory@4.5.1
system.net.http@4.3.4
system.net.primitives@4.3.0
system.private.uri@4.3.0
system.reflection.emit@4.7.0
system.reflection.metadata@1.6.0
system.reflection.metadata@7.0.0
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection@4.1.0
system.reflection@4.3.0
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@4.5.1
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.1.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.0.1
system.runtime.handles@4.3.0
system.runtime.interopservices@4.1.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.1.0
system.runtime@4.3.0
system.security.accesscontrol@4.4.0
system.security.accesscontrol@5.0.0
system.security.cryptography.algorithms@4.2.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.csp@4.0.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.0.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.primitives@4.0.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.x509certificates@4.3.0
system.security.principal.windows@4.4.0
system.security.principal.windows@5.0.0
system.text.encoding.extensions@4.3.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.threading.tasks@4.3.0
system.threading@4.0.11
system.threading@4.3.0
tmds.dbus@0.21.2
"

inherit autotools dotnet-pkg xdg

DESCRIPTION="Pinta is a free, open source program for drawing and image editing"
HOMEPAGE="https://www.pinta-project.com/
	https://github.com/PintaProject/Pinta/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/PintaProject/${PN^}"
else
	SRC_URI="https://github.com/PintaProject/${PN^}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${P^}"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

RDEPEND="
	gui-libs/gtk:4[introspection]
	gui-libs/libadwaita:1
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/intltool
"

DOTNET_PKG_BAD_PROJECTS=(
	tests/Pinta.Effects.Tests
	tests/PintaBenchmarks
)

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	# > GLib.GException : Unrecognized image file format
	rm ./tests/Pinta.Core.Tests/FileFormatTests.cs || die

	dotnet-pkg_src_prepare

	eautoreconf
}

src_configure() {
	export TargetFramework="net${DOTNET_PKG_COMPAT}"

	econf

	dotnet-pkg_src_configure
}

src_compile() {
	emake
}

src_install() {
	local pinta_home="/usr/$(get_libdir)/${PN}"

	emake DESTDIR="${ED}" install

	mv "${ED}/usr/bin/pinta" "${ED}/${pinta_home}" || die
	sed -e 's|dotnet|${DOTNET_ROOT}/dotnet|g' \
		-i "${ED}/${pinta_home}/pinta" \
		|| die
	dotnet-pkg-base_dolauncher "${pinta_home}/${PN}" "${PN}"

	rm "${ED}/usr/share/man/man1/${PN}.1.gz" || die
	doman "./xdg/${PN}.1"
}
