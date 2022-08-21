# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build systemd

DESCRIPTION="Keybase Filesystem (KBFS)"
HOMEPAGE="https://keybase.io/docs/kbfs"
SRC_URI="https://github.com/keybase/client/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-crypt/gnupg
	sys-fs/fuse:0=
"

src_unpack() {
	unpack "${P}.tar.gz"
	ln -vs "client-${PV}" "${P}" || die
	mkdir -vp "${S}/src/github.com/keybase" || die
	ln -vs "${S}" "${S}/src/github.com/keybase/client" || die
}

src_compile() {
	EGO_PN="github.com/keybase/client/go/kbfs/kbfsfuse" \
		EGO_BUILD_FLAGS="-tags production -o ${T}/kbfsfuse" \
		golang-build_src_compile
	EGO_PN="github.com/keybase/client/go/kbfs/kbfsgit/git-remote-keybase" \
		EGO_BUILD_FLAGS="-tags production -o ${T}/git-remote-keybase" \
		golang-build_src_compile
	EGO_PN="github.com/keybase/client/go/kbfs/redirector" \
		EGO_BUILD_FLAGS="-tags production -o ${T}/keybase-redirector" \
		golang-build_src_compile
}

src_test() {
	EGO_PN="github.com/keybase/kbfs/kbfsfuse" \
		golang-build_src_test
}

src_install() {
	dobin "${T}/kbfsfuse"
	dobin "${T}/git-remote-keybase"
	dobin "${T}/keybase-redirector"
	systemd_douserunit "${S}/packaging/linux/systemd/kbfs.service"
}
