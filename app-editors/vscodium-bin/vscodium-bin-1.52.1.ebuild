# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils xdg

MY_PN="${PN/-bin}"

DESCRIPTION="Free/Libre Open Source Software Binaries of VSCode"
HOMEPAGE="https://vscodium.com"

SRC_URI="
	amd64? ( https://github.com/VSCodium/vscodium/releases/download/${PV}/VSCodium-linux-x64-${PV}.tar.gz )
	arm? ( https://github.com/VSCodium/vscodium/releases/download/${PV}/VSCodium-linux-armhf-${PV}.tar.gz )
	arm64? ( https://github.com/VSCodium/vscodium/releases/download/${PV}/VSCodium-linux-arm64-${PV}.tar.gz )"

RESTRICT="strip bindist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64"

RDEPEND="
	app-accessibility/at-spi2-atk
	app-crypt/libsecret[crypt]
	dev-libs/nss
	media-libs/libpng:0/16
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/pango"

QA_PRESTRIPPED="*"

QA_PREBUILT="
	opt/${MY_PN}/codium
	opt/${MY_PN}/libEGL.so
	opt/${MY_PN}/libffmpeg.so
	opt/${MY_PN}/libGLESv2.so
	opt/${MY_PN}/libvk_swiftshader.so
	opt/${MY_PN}/libvulkan.so
	opt/${MY_PN}/swiftshader/libEGL.so
	opt/${MY_PN}/swiftshader/libGLESv2.so"

S="${WORKDIR}"

src_install() {
	pax-mark m codium
	insinto "/opt/${MY_PN}"
	doins -r *
	fperms +x /opt/${MY_PN}/{,bin/}codium
	dosym "../../opt/${MY_PN}/bin/codium" "usr/bin/codium"
	domenu "${FILESDIR}/codium.desktop"
	domenu "${FILESDIR}/codium-url-handler.desktop"
	dodoc resources/app/LICENSE.txt resources/app/ThirdPartyNotices.txt
	newicon resources/app/resources/linux/code.png ${MY_PN}.png
}
