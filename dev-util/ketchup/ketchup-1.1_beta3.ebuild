# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Tool for updating or switching between versions of the Linux kernel source"
HOMEPAGE="https://github.com/psomas/ketchup"
SRC_URI="https://dev.gentoo.org/~psomas/${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

src_install() {
	dobin "${PN}"

	insinto "/etc"
	doins "${PN}rc"

	doman "${PN}.1"
}
