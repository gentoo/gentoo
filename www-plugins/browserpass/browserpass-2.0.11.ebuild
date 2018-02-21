# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/dannyvankooten/browserpass

if [[ ${PV} == 9999 ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="WebExtension host binary for pass, a UNIX password manager"
HOMEPAGE="https://github.com/dannyvankooten/browserpass"
LICENSE="MIT"
SLOT="0"
RDEPEND="app-crypt/gnupg"
DEPEND="${RDEPEND}
	dev-go/twofactor:=
	dev-go/zglob:="

DOCS=( CONTRIBUTING.md README.md )

src_compile() {
	EGO_PN="${EGO_PN}/cmd/browserpass" golang-build_src_compile

	pushd "src/${EGO_PN}" >/dev/null || die
	sed -e 's|%%replace%%|'${EPREFIX}'/usr/bin/browserpass|' \
		-i firefox/host.json chrome/host.json || die
	popd >/dev/null || die
}

src_install() {
	dobin browserpass

	pushd "src/${EGO_PN}" >/dev/null || die
	insinto /usr/$(get_libdir)/mozilla/native-messaging-hosts
	newins firefox/host.json com.dannyvankooten.browserpass.json

	insinto /etc/chromium/native-messaging-hosts
	newins chrome/host.json com.dannyvankooten.browserpass.json

	einstalldocs
	popd >/dev/null || die
}
