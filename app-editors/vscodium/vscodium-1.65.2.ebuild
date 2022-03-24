# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop pax-utils xdg

DESCRIPTION="A community-driven, freely-licensed binary distribution of Microsoft's VSCode"
HOMEPAGE="https://vscodium.com/"
SRC_URI="
	amd64? ( https://github.com/VSCodium/${PN}/releases/download/${PV}/VSCodium-linux-x64-${PV}.tar.gz -> ${P}-amd64.tar.gz )
	arm? ( https://github.com/VSCodium/${PN}/releases/download/${PV}/VSCodium-linux-armhf-${PV}.tar.gz -> ${P}-arm.tar.gz )
	arm64? ( https://github.com/VSCodium/${PN}/releases/download/${PV}/VSCodium-linux-arm64-${PV}.tar.gz -> ${P}-arm64.tar.gz )
"

RESTRICT="mirror strip bindist"

LICENSE="
	Apache-2.0
	BSD
	BSD-1
	BSD-2
	BSD-4
	CC-BY-4.0
	ISC
	LGPL-2.1+
	MIT
	MPL-2.0
	openssl
	PYTHON
	TextMate-bundle
	Unlicense
	UoI-NCSA
	W3C
"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64"
IUSE=""

RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	app-crypt/libsecret[crypt]
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libxshmfence
	x11-libs/pango
"

QA_PREBUILT="
	/opt/vscodium/codium
	/opt/vscodium/libEGL.so
	/opt/vscodium/libffmpeg.so
	/opt/vscodium/libGLESv2.so
	/opt/vscodium/libvulkan.so*
	/opt/vscodium/chrome-sandbox
	/opt/vscodium/libvk_swiftshader.so
	/opt/vscodium/swiftshader/libEGL.so
	/opt/vscodium/swiftshader/libGLESv2.so
	/opt/vscodium/resources/app/extensions/*
	/opt/vscodium/resources/app/node_modules.asar.unpacked/*
"

S="${WORKDIR}"

src_install() {
	# Cleanup
	rm "${S}/resources/app/LICENSE.txt" || die

	# Install
	pax-mark m codium
	insinto "/opt/${PN}"
	doins -r *
	fperms +x /opt/${PN}/{,bin/}codium
	fperms 4711 /opt/${PN}/chrome-sandbox
	fperms 755 /opt/${PN}/resources/app/extensions/git/dist/askpass.sh
	fperms 755 /opt/${PN}/resources/app/extensions/git/dist/askpass-empty.sh
	fperms -R +x /opt/${PN}/resources/app/out/vs/base/node
	fperms +x /opt/${PN}/resources/app/node_modules.asar.unpacked/@vscode/ripgrep/bin/rg
	dosym "../../opt/${PN}/bin/codium" "usr/bin/vscodium"
	dosym "../../opt/${PN}/bin/codium" "usr/bin/codium"
	domenu "${FILESDIR}/vscodium.desktop"
	domenu "${FILESDIR}/vscodium-url-handler.desktop"
	domenu "${FILESDIR}/vscodium-wayland.desktop"
	domenu "${FILESDIR}/vscodium-url-handler-wayland.desktop"
	newicon "resources/app/resources/linux/code.png" "vscodium.png"
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "When compared to the regular VSCode, VSCodium has a few quirks"
	elog "More information at: https://github.com/VSCodium/vscodium/blob/master/DOCS.md"

	if has_version -r ">=gui-libs/wlroots-0.15"; then
		elog
		elog "The wayland backend of vscodium crashes with >=gui-libs/wlroots-0.15"
		elog "This will be fixed upstream in a later release"
		elog "Please run the xwayland version for now, on wlroots based DEs."
		elog "For more information, see https://bugs.gentoo.org/834082"
	fi
}
