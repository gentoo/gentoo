# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ketchup/ketchup-1.1_beta3.ebuild,v 1.1 2011/08/30 08:15:19 psomas Exp $

EAPI=4

inherit eutils

DESCRIPTION="Tool for updating or switching between versions of the Linux kernel source"
HOMEPAGE="http://github.com/psomas/ketchup"
SRC_URI="http://dev.gentoo.org/~psomas/${PF}.tar.gz"

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
