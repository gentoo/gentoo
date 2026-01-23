# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
MY_PN=browserpass-native

DESCRIPTION="WebExtension host binary for app-admin/pass, a UNIX password manager"
HOMEPAGE="https://github.com/browserpass/browserpass-native"

SRC_URI="https://github.com/browserpass/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~mattst88/distfiles/${P}-deps.tar.xz"
S="${WORKDIR}"/${MY_PN}-${PV}

LICENSE="BSD ISC MIT"
SLOT="0"
KEYWORDS="amd64"
RDEPEND="app-crypt/gnupg"

src_compile() {
	ego build || die

	sed -e "s|%%replace%%|${EPREFIX}/usr/libexec/browserpass-native|" \
		-i browser-files/firefox-host.json browser-files/chromium-host.json || die
}

src_install() {
	exeinto /usr/libexec
	doexe browserpass-native

	insinto /usr/lib/mozilla/native-messaging-hosts
	newins browser-files/firefox-host.json com.github.browserpass.native.json

	insinto /usr/lib64/mozilla/native-messaging-hosts
	newins browser-files/firefox-host.json com.github.browserpass.native.json

	insinto /etc/chromium/native-messaging-hosts
	newins browser-files/chromium-host.json com.github.browserpass.native.json

	insinto /etc/opt/chrome/native-messaging-hosts
	newins browser-files/chromium-host.json com.github.browserpass.native.json

	insinto /etc/opt/vivaldi/native-messaging-hosts
	newins browser-files/chromium-host.json com.github.browserpass.native.json
}
