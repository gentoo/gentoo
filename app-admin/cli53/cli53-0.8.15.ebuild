# Copyright 2016-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]]; then
	inherit golang-vcs
else
	inherit golang-vcs-snapshot
	SRC_URI="https://github.com/barnybug/cli53/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Command line tool for Amazon Route 53"
HOMEPAGE="https://github.com/barnybug/cli53"

LICENSE="Apache-2.0 BSD MIT"

SLOT="0"

EGO_PN="github.com/barnybug/cli53"
S="${WORKDIR}/${P}/src/${EGO_PN}"

src_compile() {
	GOPATH="${WORKDIR}/${P}" emake build
}

src_test() {
	GOPATH="${WORKDIR}/${P}" go test -v || die
}

src_install() {
	dobin cli53
	dodoc CHANGELOG.md README.md
}
