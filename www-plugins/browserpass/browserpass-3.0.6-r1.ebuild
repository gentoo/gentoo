# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="WebExtension host binary for app-admin/pass, a UNIX password manager"
HOMEPAGE="https://github.com/browserpass/browserpass-native"

EGO_VENDOR=(
	"github.com/mattn/go-zglob a8912a37f9e7" # MIT
	"github.com/sirupsen/logrus v1.4.2" # MIT
	"golang.org/x/sys 6d18c012aee9febd81bbf9806760c8c4480e870d github.com/golang/sys" # BSD
)

MY_PN=browserpass-native
SRC_URI="https://github.com/browserpass/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="BSD ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
DEPEND=""
RDEPEND="app-crypt/gnupg"

S="${WORKDIR}"/${MY_PN}-${PV}

src_compile() {
	go build || die

	sed -e 's|%%replace%%|'${EPREFIX}'/usr/libexec/browserpass-native|' \
		-i browser-files/firefox-host.json browser-files/chromium-host.json || die
}

src_install() {
	exeinto /usr/libexec
	doexe browserpass-native

	insinto /usr/$(get_libdir)/mozilla/native-messaging-hosts
	newins browser-files/firefox-host.json com.github.browserpass.native.json

	insinto /etc/chromium/native-messaging-hosts
	newins browser-files/chromium-host.json com.github.browserpass.native.json

	insinto /etc/opt/chrome/native-messaging-hosts
	newins browser-files/chromium-host.json com.github.browserpass.native.json
}
