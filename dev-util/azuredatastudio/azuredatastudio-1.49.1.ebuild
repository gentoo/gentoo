# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="Data management and development tool from Microsoft"
HOMEPAGE="https://learn.microsoft.com/sql/azure-data-studio/
	https://github.com/microsoft/azuredatastudio/"
SRC_URI="
	amd64? (
		https://azuredatastudio-update.azurewebsites.net/${PV}/linux-deb-x64/stable
			-> ${P}-amd64.deb
	)
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="kerberos"
RESTRICT="bindist"

# This is based on VSCode/VSCodium, so just copy their "RDEPEND".
RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-crypt/libsecret[crypt]
	app-misc/ca-certificates
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-util/lttng-ust:0/2.12
	media-libs/alsa-lib
	media-libs/libcanberra[gtk3]
	media-libs/libglvnd
	media-libs/mesa
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	sys-libs/zlib
	sys-process/lsof
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libnotify
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/pango
	x11-misc/xdg-utils
	kerberos? ( app-crypt/mit-krb5 )
"
DEPEND="
	dev-libs/openssl-compat:1.0.0
"
BDEPEND="
	dev-util/patchelf
"

QA_PREBUILT="*"

src_unpack() {
	unpack_deb "${A}"
}

src_prepare() {
	default

	cd "${S}/usr/share" || die

	mv appdata metainfo || die
	mv zsh/vendor-completions zsh/site-functions || die

	cd "${PN}/resources/app" || die

	# Kerberos libs, same issue as VSCode/VSCodium.
	if ! use kerberos ; then
		rm -r node_modules.asar.unpacked/kerberos || die
	fi

	# Patch "System.Security.Cryptography.Native.OpenSsl.so": *.so.10 -> *.so.1.0.0
	local mssql_ext_version="5.0.20240724.1"
	local mssql_ext_lib="libSystem.Security.Cryptography.Native.OpenSsl.so"
	cd "extensions/mssql/sqltoolsservice/Linux/${mssql_ext_version}" || die
	patchelf --add-needed libcrypto.so.1.0.0 "${mssql_ext_lib}" || die
	patchelf --add-needed libssl.so.1.0.0 "${mssql_ext_lib}" || die
	patchelf --remove-needed libcrypto.so.10 "${mssql_ext_lib}" || die
	patchelf --remove-needed libssl.so.10 "${mssql_ext_lib}" || die
}

src_install() {
	cp -r . "${ED}" || die

	dosym -r "/usr/share/${PN}/${PN}" "/usr/bin/${PN}"
}
