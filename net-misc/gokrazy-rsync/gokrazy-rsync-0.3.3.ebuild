# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="rsync in Go!"
HOMEPAGE="https://github.com/gokrazy/rsync"
SRC_URI="
	https://github.com/gokrazy/rsync/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/gentoo-golang-dist/rsync/releases/download/v${PV}/${P/gokrazy-}-vendor.tar.xz
"
S="${WORKDIR}"/${P/gokrazy-}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-lang/go-1.25.0"

PATCHES=(
	"${FILESDIR}"/${P}-landlock.patch
)

src_configure() {
	export GOBIN="${WORKDIR}"/bin
	mkdir "${GOBIN}" || die
}

src_test() {
	# TestMapFS, TestMapFSLargeFile fail to lchownat w/ EPERM
	ego test -fullpath ./... -skip TestMapFS
}

src_install() {
	einstalldocs

	dobin "${GOBIN}"/gokr-rsync{,d}

	systemd_dounit systemd/gokr-rsyncd.service
	systemd_dounit systemd/gokr-rsyncd.socket
}
