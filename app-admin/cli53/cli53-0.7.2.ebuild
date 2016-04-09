# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit golang-vcs-snapshot

DESCRIPTION="Command line tool for Amazon Route 53"
HOMEPAGE="https://github.com/barnybug/cli53"
SRC_URI="https://github.com/barnybug/cli53/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

EGO_PN="github.com/barnybug/cli53"

src_compile() {
	cd src/${EGO_PN} || die
	GOPATH="${WORKDIR}/${P}" emake version=${PV} build
}

src_install() {
	cd src/${EGO_PN} || die
	dobin cli53
	dodoc {CHANGELOG,README}.md
}
