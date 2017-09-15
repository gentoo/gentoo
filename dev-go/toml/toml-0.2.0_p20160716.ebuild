# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/BurntSushi/toml"

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	EGIT_COMMIT="99064174e013895bbd9b025c31100bd1d9b590ca"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="TOML parser for Golang with reflection"
HOMEPAGE="https://github.com/BurntSushi/toml"

LICENSE="WTFPL-2"
SLOT="0"
IUSE=""

S=${WORKDIR}/${P}/src/${EGO_PN}

RESTRICT="test"

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" go build -o "bin/tomlv" ./cmd/tomlv || die
}

src_install() {
	dodoc README.md
	dobin bin/tomlv
}
