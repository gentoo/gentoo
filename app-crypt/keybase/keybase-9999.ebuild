# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build systemd git-r3

DESCRIPTION="Client for keybase.io"
HOMEPAGE="https://keybase.io/"
EGIT_REPO_URI="https://github.com/keybase/client.git"

LICENSE="Apache-2.0 BSD BSD-2 LGPL-3 MIT MPL-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="app-crypt/gnupg"

src_unpack() {
	git-r3_src_unpack
	ln -vs "client" "${P}" || die
	mkdir -vp "${S}/src/github.com/keybase" || die
	ln -vs "${S}" "${S}/src/github.com/keybase/client" || die
}

src_compile() {
	EGO_PN="github.com/keybase/client/go/keybase" \
		EGO_BUILD_FLAGS="-tags production -o ${T}/keybase" \
		golang-build_src_compile
}

src_test() {
	EGO_PN="github.com/keybase/client/go/keybase" \
		golang-build_src_test
}

src_install() {
	dobin "${T}/keybase"
	dobin "${S}/packaging/linux/run_keybase"
	systemd_douserunit "${S}/packaging/linux/systemd/keybase.service"
	dodir "/opt/keybase"
	insinto "/opt/keybase"
	doins "${S}/packaging/linux/crypto_squirrel.txt"
}

pkg_postinst() {
	elog "Start/Restart keybase: run_keybase"
	elog "Run the service:       keybase service"
	elog "Run the client:        keybase login"
	ewarn "Note that the user keybasehelper is obsolete and can be removed"
}
