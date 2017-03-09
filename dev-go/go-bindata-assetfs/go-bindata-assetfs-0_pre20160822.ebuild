# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/elazarl/go-bindata-assetfs/..."
EGIT_COMMIT="9a6736ed45b44bf3835afeebb3034b57ed329f3e"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Serve embedded files from jteeuwen/go-bindata with net/http"
HOMEPAGE="https://github.com/elazarl/go-bindata-assetfs"
SRC_URI="${ARCHIVE_URI}"
LICENSE="BSD"
SLOT="0/${PVR}"
IUSE=""

RDEPEND="dev-go/go-bindata"

src_install() {
	golang-build_src_install
	dobin bin/*
}
