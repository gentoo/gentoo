# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils xdg

DESCRIPTION="Multiplatform Visual Studio Code from Microsoft"
HOMEPAGE="https://code.visualstudio.com"
SRC_URI="
	amd64? ( https://update.code.visualstudio.com/${PV}/linux-x64/stable -> ${P}-amd64.tar.gz )
	arm? ( https://update.code.visualstudio.com/${PV}/linux-armhf/stable -> ${P}-arm.tar.gz )
	arm64? ( https://update.code.visualstudio.com/${PV}/linux-arm64/stable -> ${P}-arm64.tar.gz )
"
S="${WORKDIR}"

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
	Microsoft-vscode
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
	/opt/vscode/code
	/opt/vscode/libEGL.so
	/opt/vscode/libffmpeg.so
	/opt/vscode/libGLESv2.so
	/opt/vscode/libvulkan.so*
	/opt/vscode/chrome-sandbox
	/opt/vscode/libvk_swiftshader.so
	/opt/vscode/swiftshader/libEGL.so
	/opt/vscode/swiftshader/libGLESv2.so
	/opt/vscode/resources/app/extensions/*
	/opt/vscode/resources/app/node_modules.asar.unpacked/*
"

src_install() {
	if use amd64; then
		cd "${WORKDIR}/VSCode-linux-x64" || die
	elif use arm; then
		cd "${WORKDIR}/VSCode-linux-armhf" || die
	elif use arm64; then
		cd "${WORKDIR}/VSCode-linux-arm64" || die
	else
		die "Visual Studio Code only supports amd64, arm and arm64"
	fi

	# Cleanup
	rm -r ./resources/app/LICENSES.chromium.html ./resources/app/LICENSE.rtf ./resources/app/licenses || die

	# Install
	pax-mark m code
	insinto "/opt/${PN}"
	doins -r *
	fperms +x /opt/${PN}/{,bin/}code
	fperms 4711 /opt/${PN}/chrome-sandbox
	fperms 755 /opt/${PN}/resources/app/extensions/git/dist/askpass.sh
	fperms 755 /opt/${PN}/resources/app/extensions/git/dist/askpass-empty.sh
	fperms -R +x /opt/${PN}/resources/app/out/vs/base/node
	fperms +x /opt/${PN}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg
	dosym "../../opt/${PN}/bin/code" "usr/bin/vscode"
	dosym "../../opt/${PN}/bin/code" "usr/bin/code"
	domenu "${FILESDIR}/vscode.desktop"
	domenu "${FILESDIR}/vscode-url-handler.desktop"
	domenu "${FILESDIR}/vscode-wayland.desktop"
	domenu "${FILESDIR}/vscode-url-handler-wayland.desktop"
	newicon "resources/app/resources/linux/code.png" "vscode.png"
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "You may want to install some additional utils, check in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}
