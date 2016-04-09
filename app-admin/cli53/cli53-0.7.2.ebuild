# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGO_PN=github.com/barnybug/cli53
inherit golang-vcs-snapshot

DESCRIPTION="Command line tool for Amazon Route 53"
HOMEPAGE="https://github.com/barnybug/cli53"
SRC_URI="https://github.com/barnybug/cli53/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	cd src/${EGO_PN}
	version_arg="version=${PV}"
	GOPATH="${WORKDIR}/${P}" emake ${version_arg} build
}

src_install() {
	cd src/${EGO_PN}
	dobin cli53
	dodoc {CHANGELOG,README}.md
}
