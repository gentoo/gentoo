# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Keybase Filesystem (KBFS)"
HOMEPAGE="https://keybase.io/docs/kbfs"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/keybase/client.git"
	inherit git-r3
else
	SRC_URI="https://github.com/keybase/client/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://dev.gentoo.org/~nicolasbock/${P}-deps.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	app-crypt/gnupg
	sys-fs/fuse:0=
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
	pushd ./go/kbfs/kbfsfuse || die
	ego build -tags production -o "${T}/kbfsfuse"
	popd || die
	pushd ./go/kbfs/kbfsgit/git-remote-keybase || die
	ego build -tags production -o "${T}/git-remote-keybase"
	popd || die
	pushd ./go/kbfs/redirector || die
	ego build -tags production -o "${T}/keybase-redirector"
	popd || die
}

src_test() {
	pushd ./go/kbfs/kbfsfuse || die
	ego test
	popd || die
}

src_install() {
	dobin "${T}/kbfsfuse"
	dobin "${T}/git-remote-keybase"
	dobin "${T}/keybase-redirector"
	systemd_douserunit "${S}/packaging/linux/systemd/kbfs.service"
	systemd_douserunit "${S}/packaging/linux/systemd/keybase-redirector.service"
}
