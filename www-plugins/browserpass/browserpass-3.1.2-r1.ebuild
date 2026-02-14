# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/maxbaz.asc
inherit go-module verify-sig
MY_PN=browserpass-native

DESCRIPTION="WebExtension host binary for app-admin/pass, a UNIX password manager"
HOMEPAGE="https://github.com/browserpass/browserpass-native"
SRC_URI="
	https://github.com/browserpass/browserpass-native/releases/download/v${PV}/${MY_PN}-3.1.2-src.tar.gz
	verify-sig? (
		https://github.com/browserpass/browserpass-native/releases/download/v${PV}/${MY_PN}-3.1.2-src.tar.gz.asc
	)
"
S="${WORKDIR}"/${MY_PN}-${PV}

LICENSE="BSD ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-crypt/gnupg"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-maxbaz )"

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
