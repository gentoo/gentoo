# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	app-accessibility/at-spi2-atk
	app-crypt/libsecret[crypt]
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/libpng:0/16
	net-print/cups
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libXScrnSaver
	x11-libs/libXtst
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
	fperms +x /opt/${PN}/chrome-sandbox
	fperms -R +x /opt/${PN}/resources/app/out/vs/base/node
	fperms +x /opt/${PN}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg
	dosym "../../opt/${PN}/bin/codium" "usr/bin/vscodium"
	domenu "${FILESDIR}/vscodium.desktop"
	domenu "${FILESDIR}/vscodium-url-handler.desktop"
	newicon "resources/app/resources/linux/code.png" "vscodium.png"
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "When compared to the regular VSCode, VSCodium has a few quirks"
	elog "More information at: https://github.com/VSCodium/vscodium/blob/master/DOCS.md"
}
