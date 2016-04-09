# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Command line tool for Amazon Route 53"
HOMEPAGE="https://github.com/barnybug/cli53"
SRC_URI="https://github.com/barnybug/cli53/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_unpack() {
	EGO_PN="github.com/barnybug/cli53" golang-vcs-snapshot_src_unpack
}

src_compile() {
	EGO_PN="github.com/barnybug/cli53/cmd/cli53" golang-build_src_compile
}

src_install() {
	dobin cli53
	dodoc src/github.com/barnybug/cli53/{CHANGELOG,README}.md
}
