# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == 9999 ]]; then
	inherit golang-vcs
else
	inherit golang-vcs-snapshot
	SRC_URI="https://github.com/barnybug/cli53/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Command line tool for Amazon Route 53"
HOMEPAGE="https://github.com/barnybug/cli53"

LICENSE="MIT"
SLOT="0"

EGO_PN="github.com/barnybug/cli53"
S="${WORKDIR}/${P}/src/${EGO_PN}"

src_compile() {
	if [[ ${PV} == 9999 ]]; then
		GOPATH="${WORKDIR}/${P}" emake build
	else
		GOPATH="${WORKDIR}/${P}" emake build version=${PV}
	fi
}

src_test() {
	GOPATH="${WORKDIR}/${P}" go test -v || die
}

src_install() {
	dobin cli53
	dodoc CHANGELOG.md README.md
}
