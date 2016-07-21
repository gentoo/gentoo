# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Tool for updating or switching between versions of the Linux kernel source"
HOMEPAGE="https://git.kernel.org/?p=linux/kernel/git/rostedt/ketchup.git;a=summary"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
