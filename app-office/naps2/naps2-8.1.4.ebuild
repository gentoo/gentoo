# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="9.0"

# Generated via "gdmt restore", but the *.Mac projects had to be removed from
# the sln manually first. Later they are removed via "DOTNET_PKG_BAD_PROJECTS".
NUGETS="
atksharp@3.24.24.95
autofac@8.0.0
ben.demystifier@0.4.1
cairosharp@3.24.24.95
commandlineparser@2.9.1
embedio@3.5.2
eto.forms@2.8.3
eto.platform.gtk@2.8.3
gdksharp@3.24.24.95
giosharp@3.24.24.95
glibsharp@3.24.24.95
google.protobuf@3.25.1
grpc.core.api@2.59.0
grpc.tools@2.65.0
grpcdotnetnamedpipes@3.0.0
gtksharp@3.24.24.95
isexternalinit@1.0.3
libusbdotnet@3.0.102-alpha
makaretu.dns@2.0.1
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.bcl.asyncinterfaces@8.0.0
microsoft.extensions.configuration.abstractions@8.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.1
microsoft.extensions.dependencyinjection@8.0.0
microsoft.extensions.logging.abstractions@8.0.0
microsoft.extensions.logging.abstractions@8.0.1
microsoft.extensions.logging@8.0.0
microsoft.extensions.options@8.0.0
microsoft.extensions.primitives@8.0.0
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.targets@1.1.0
microsoft.netcore.targets@1.1.3
microsoft.netframework.referenceassemblies.net462@1.0.3
microsoft.netframework.referenceassemblies@1.0.3
microsoft.win32.primitives@4.3.0
microsoft.win32.systemevents@8.0.0
microsoft.win32.systemevents@9.0.3
mimekitlite@4.7.1
naps2.mdns@1.0.1
naps2.ntwain@1.0.0
naps2.pdfium.binaries@1.1.0
naps2.pdfsharp@1.0.1
naps2.tesseract.binaries@1.3.1
naps2.wia@2.0.3
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@13.0.3
nlog.extensions.logging@5.3.11
nlog@5.3.2
pangosharp@3.24.24.95
polyfill@4.9.0
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
sharpziplib@1.4.2
simplebase@1.3.1
sixlabors.fonts@1.0.0-beta17
sixlabors.fonts@1.0.1
sixlabors.imagesharp@3.1.7
standardsocketshttphandler@2.2.0.8
system.buffers@4.3.0
system.buffers@4.4.0
system.buffers@4.5.1
system.collections.concurrent@4.3.0
system.collections.immutable@8.0.0
system.collections@4.3.0
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.diagnosticsource@7.0.2
system.diagnostics.tracing@4.3.0
system.drawing.common@8.0.7
system.drawing.common@9.0.3
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.3.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io@4.3.0
system.linq.async@6.0.1
system.linq@4.3.0
system.memory@4.5.1
system.memory@4.5.3
system.memory@4.5.4
system.memory@4.5.5
system.net.http@4.3.4
system.net.primitives@4.3.0
system.numerics.vectors@4.4.0
system.numerics.vectors@4.5.0
system.private.uri@4.3.0
system.private.uri@4.3.2
system.reflection.metadata@5.0.0
system.reflection.primitives@4.3.0
system.reflection@4.3.0
system.resources.extensions@8.0.0
system.resources.resourcemanager@4.3.0
system.runtime.compilerservices.unsafe@4.5.0
system.runtime.compilerservices.unsafe@4.5.2
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@4.7.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.numerics@4.3.0
system.runtime@4.3.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.cng@4.3.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@8.0.0
system.security.cryptography.x509certificates@4.3.0
system.text.encoding.extensions@4.3.0
system.text.encoding@4.3.0
system.threading.tasks.dataflow@8.0.1
system.threading.tasks.extensions@4.5.2
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.3.0
system.threading@4.3.0
system.valuetuple@4.5.0
unosquare.swan.lite@3.1.0
zxing.net@0.16.9
"

inherit dotnet-pkg desktop xdg

DESCRIPTION="Document scanning application with a focus on simplicity and ease of use"
HOMEPAGE="https://www.naps2.com/
	https://github.com/cyanfish/naps2/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/cyanfish/${PN}.git"
else
	SRC_URI="https://github.com/cyanfish/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="AGPL-3+ Apache-2.0 BSD BSD-2 GPL-2+ LGPL-3+ MIT"
SLOT="0"
RESTRICT="test"

RDEPEND="
	app-text/tesseract
	media-fonts/liberation-fonts
	media-fonts/noto
	media-fonts/noto-cjk
	media-gfx/sane-backends
	x11-libs/gtk+:3
"

DOTNET_PKG_PROJECTS=( NAPS2.App.Gtk )
DOTNET_PKG_BAD_PROJECTS=(
	# For MacOS.
	NAPS2.App.Mac
	NAPS2.Images.Mac
	NAPS2.Lib.Mac

	# For Windows.
	NAPS2.App.Console
	NAPS2.App.WinForms
	NAPS2.App.Worker
	NAPS2.Images.Wpf
	NAPS2.Lib.WinForms

	# Failing tests:
	NAPS2.App.Tests
	NAPS2.Escl.Tests
	NAPS2.Lib.Tests
	NAPS2.Sdk.ScannerTests
	NAPS2.Sdk.Tests
)

DOCS=( CHANGELOG.md README.md )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	dotnet-pkg_src_prepare

	# Having this package reference in a proj file will make dotnet copy
	# the host's libhostpolicy.so and break the Gentoo's mechanism of handling
	# dotnet executables.
	sed -e "/.*NETCore.App.*/d" -i NAPS2.App.Gtk/NAPS2.App.Gtk.csproj || die
}

src_install() {
	dotnet-pkg_src_install

	local linux_dir=""
	case "${ARCH}" in
		arm* )
			linux_dir="/usr/share/${P}/_linuxarm"
			;;
		* )
			linux_dir="/usr/share/${P}/_linux"
			;;
	esac

	# Use system tesseract.
	rm -f "${ED}/${linux_dir}/tesseract" || die
	dosym -r /usr/bin/tesseract "${linux_dir}/tesseract"

	find "${ED}/${linux_dir}" -type f -exec chmod a+rx {} + || die

	newicon --size 128 ./NAPS2.Lib/Icons/scanner-128.png com.naps2.Naps2.png
	domenu ./NAPS2.Setup/config/linux/com.naps2.Naps2.desktop

	insinto /usr/share/metainfo
	doins ./NAPS2.Setup/config/linux/com.naps2.Naps2.metainfo.xml

	einstalldocs
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
