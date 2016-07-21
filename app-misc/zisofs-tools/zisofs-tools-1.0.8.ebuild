# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit flag-o-matic

DESCRIPTION="User utilities for zisofs"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/fs/zisofs/"
SRC_URI="mirror://kernel/linux/utils/fs/zisofs/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos"
IUSE="static"

DEPEND=">=sys-libs/zlib-1.1.4"

src_compile() {
	use static && append-ldflags -static
	econf || die
	emake || die
}

src_install() {
	emake INSTALLROOT="${D}" install || die
	dodoc CHANGES INSTALL README
}
