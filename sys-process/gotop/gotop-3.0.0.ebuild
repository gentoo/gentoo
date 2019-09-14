# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-vcs-snapshot

EGO_PN="github.com/cjbassi/${PN}"

DESCRIPTION="A terminal based graphical activity monitor inspired by gtop and vtop"
HOMEPAGE="https://github.com/cjbassi/gotop"

SRC_URI="https://github.com/cjbassi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	cd "src/${EGO_PN}" || die
	GO111MODULE=on GOPATH="${S}" GOCACHE="${T}/go-cache" go build \
		-v -mod vendor -o "${S}/${PN}" ./ || die
}

src_install() {
	dobin gotop
}
