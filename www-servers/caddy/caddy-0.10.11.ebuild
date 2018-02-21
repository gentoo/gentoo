# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/mholt/${PN}"

inherit golang-build golang-vcs-snapshot

EGIT_COMMIT="v${PV}"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Fast, cross-platform HTTP/2 web server with automatic HTTPS"
HOMEPAGE="https://github.com/mholt/caddy"

SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	GOPATH="${WORKDIR}/${P}" go install -ldflags "-X github.com/mholt/caddy/caddy/caddymain.gitTag=${PV}" ${EGO_PN}/caddy || die
}

src_install() {
	dobin bin/*
	dodoc src/${EGO_PN}/README.md src/${EGO_PN}/dist/CHANGES.txt
}
