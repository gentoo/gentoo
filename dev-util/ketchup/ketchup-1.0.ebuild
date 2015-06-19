# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ketchup/ketchup-1.0.ebuild,v 1.2 2011/05/25 12:05:09 flameeyes Exp $

EAPI=4

inherit eutils

DESCRIPTION="Tool for updating or switching between versions of the Linux kernel source"
HOMEPAGE="http://git.kernel.org/?p=linux/kernel/git/rostedt/ketchup.git;a=summary"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
