# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/mattn/go-sqlite3/..."
EGIT_COMMIT="10876d7dac65f02064c03d7372a2f1dfb90043fe"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Go sqlite3 driver using database/sql"
HOMEPAGE="https://${EGO_PN%/*}"
SRC_URI="${ARCHIVE_URI}"
LICENSE="MIT"
SLOT="0/${PVR}"
IUSE=""

src_compile() {
	GOPATH="${S}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_install() {
	golang_install_pkgs
}

golang_install_pkgs() {
	insinto $(dirname "${EPREFIX}$(get_golibdir)/src/${EGO_PN%/*}")
	rm -rf "${S}"/src/${EGO_PN%/*}/.git*
	doins -r "${S}"/src/${EGO_PN%/*}
	insinto $(dirname "${EPREFIX}$(get_golibdir)/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}")
	doins -r "${S}"/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}{,.a}
}
