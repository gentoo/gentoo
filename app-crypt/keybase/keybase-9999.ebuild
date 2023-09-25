# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Keybase client"
HOMEPAGE="https://keybase.io/"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/keybase/client.git"
	inherit git-r3
else
	SRC_URI="https://github.com/keybase/client/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://dev.gentoo.org/~nicolasbock/${P}-deps.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="Apache-2.0 BSD BSD-2 LGPL-3 MIT MPL-2.0"
SLOT="0"
IUSE="fuse"

RDEPEND="
	app-crypt/gnupg
	fuse? (
		~app-crypt/kbfs-${PV}
	)
"

src_unpack() {
	default
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		GOMODCACHE="${S}/go/go-mod"
		pushd "${S}/go" || die
		ego mod download
		popd || die
	else
		ln -vs "client-${PV}" "${P}" || die
		mkdir -vp "${S}/src/github.com/keybase" || die
		ln -vs "${S}" "${S}/src/github.com/keybase/client" || die
	fi
}

src_compile() {
	pushd go/keybase || die
	ego build -tags production -o "${T}/keybase"
	popd || die
}

src_test() {
	pushd go/keybase || die
	ego test
	popd || die
}

src_install() {
	dobin "${T}/keybase"
	dobin "${S}/packaging/linux/run_keybase"
	systemd_douserunit "${S}/packaging/linux/systemd/keybase.service"
	insinto "/opt/keybase"
	doins "${S}/packaging/linux/crypto_squirrel.txt"
	dodir "/opt/keybase"
}

pkg_postinst() {
	elog "Start/Restart keybase: run_keybase"
	elog "Run the service:       keybase service"
	elog "Run the client:        keybase login"
	ewarn "Note that the user keybasehelper is obsolete and can be removed"
}
