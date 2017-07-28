# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/Masterminds/glide"

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	EGIT_COMMIT="v${PV/_/-}"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="Vendor Package Managment for Golang"
HOMEPAGE="https://github.com/Masterminds/glide"

LICENSE="MIT"
SLOT="0"
IUSE=""

S=${WORKDIR}/${P}/src/${EGO_PN}

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" go build -ldflags="-X main.version=${PV}" -o "bin/glide" glide.go || die
}

src_install() {
	dodoc README.md CHANGELOG.md
	dobin bin/glide
}
