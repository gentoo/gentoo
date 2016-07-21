# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit git-2 eutils

DESCRIPTION="tool for updating or switching between versions of the Linux kernel source"
HOMEPAGE="https://github.com/psomas/ketchup"
SRC_URI=""
EGIT_REPO_URI="git://github.com/psomas/ketchup.git"
EGIT_MASTER="experimental"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	dobin "${PN}"

	insinto "/etc"
	doins "${PN}rc"

	doman "${PN}.1"
}
