# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ketchup/ketchup-9999.ebuild,v 1.2 2011/08/30 10:42:57 psomas Exp $

EAPI="4"

inherit git-2 eutils

DESCRIPTION="tool for updating or switching between versions of the Linux kernel source"
HOMEPAGE="http://github.com/psomas/ketchup"
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
