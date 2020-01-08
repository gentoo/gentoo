# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/FiloSottile/mkcert"

inherit golang-build golang-vcs-snapshot

KEYWORDS="~amd64"

DESCRIPTION="A zero-config tool to make locally trusted development certificates"
HOMEPAGE="https://github.com/FiloSottile/mkcert"
SRC_URI="https://github.com/FiloSottile/mkcert/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go install -v ${EGO_PN} || die
	popd || die
}

src_install() {
	dobin bin/mkcert
	dodoc src/${EGO_PN}/README.md
}
