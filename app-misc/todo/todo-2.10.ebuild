# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit bash-completion-r1

DESCRIPTION="A CLI-based TODO list manager"
HOMEPAGE="http://todotxt.com/"
SRC_URI="https://github.com/ginatrapani/${PN}.txt-cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="app-shells/bash"

S="${WORKDIR}/${PN}.txt-cli-${PV}"

DOCS=( README.textile CONTRIBUTING.md LICENSE todo.cfg )

src_test() {
	make test || die "tests failed"
}

src_install() {
	newbin "${PN}.sh" "${PN}"
	newbashcomp "${PN}_completion" "${PN}"
	einstalldocs
}
