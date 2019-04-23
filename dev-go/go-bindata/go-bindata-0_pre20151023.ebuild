# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/jteeuwen/go-bindata/..."
EGIT_COMMIT="a0ff2567cfb70903282db057e799fd826784d41d"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 ~arm ~arm64"

DESCRIPTION="A small utility which generates Go code from any file"
HOMEPAGE="https://github.com/jteeuwen/go-bindata"
SRC_URI="${ARCHIVE_URI}"
LICENSE="CC-PD"
SLOT="0/${PVR}"
IUSE=""

src_install() {
	GOBIN=${S}/bin \
		golang-build_src_install
	dobin bin/*
}
