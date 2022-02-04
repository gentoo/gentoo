# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN=github.com/mattn/gom

EGIT_COMMIT=c522e7d
ARCHIVE_URI="https://github.com/mattn/gom/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
inherit golang-build golang-vcs-snapshot

DESCRIPTION="Go Dependency management system similar to bundle for ruby"
HOMEPAGE="https://github.com/mattn/gom"
SRC_URI="${ARCHIVE_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-go/go-colortext:="
RDEPEND="!media-sound/gom"

src_install() {
	dobin gom
	dodoc src/${EGO_PN}/README.mkd
}
