# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=browserpass-native
EGO_PN=github.com/browserpass/${MY_PN}

if [[ ${PV} == 9999 ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
#	MY_P="${MY_PN}-${PV}"
#	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/browserpass/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="WebExtension host binary for pass, a UNIX password manager"
HOMEPAGE="https://github.com/browserpass/browserpass-native"
LICENSE="ISC"
SLOT="0"
RDEPEND="app-crypt/gnupg"
DEPEND="${RDEPEND}
	dev-go/logrus:=
	dev-go/zglob:="

src_compile() {
	golang-build_src_compile

	pushd "src/${EGO_PN}" >/dev/null || die
	sed -e 's|%%replace%%|'${EPREFIX}'/usr/libexec/browserpass-native|' \
		-i browser-files/firefox-host.json browser-files/chromium-host.json || die
	popd >/dev/null || die
}

src_install() {
	exeinto /usr/libexec
	doexe browserpass-native

	pushd "src/${EGO_PN}" >/dev/null || die
	insinto /usr/$(get_libdir)/mozilla/native-messaging-hosts
	newins browser-files/firefox-host.json com.github.browserpass.native.json

	insinto /etc/chromium/native-messaging-hosts
	newins browser-files/chromium-host.json com.github.browserpass.native.json

	insinto /etc/opt/chrome/native-messaging-hosts
	newins browser-files/chromium-host.json com.github.browserpass.native.json

	popd >/dev/null || die
}
