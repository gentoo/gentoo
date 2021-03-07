# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/elazarl/go-bindata-assetfs/..."
EGIT_COMMIT="38087fe4dafb822e541b3f7955075cc1c30bd294"
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
