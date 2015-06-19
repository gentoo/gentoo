# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/symlinks/symlinks-1.4.ebuild,v 1.9 2011/03/02 01:46:21 ranger Exp $

inherit flag-o-matic eutils toolchain-funcs

DESCRIPTION="Scans for and fixes broken or messy symlinks"
HOMEPAGE="http://www.ibiblio.org/pub/linux/utils/file/"
SRC_URI="http://www.ibiblio.org/pub/linux/utils/file/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86"
IUSE="static"

src_compile() {
	# could be useful if being used to repair
	# symlinks that are preventing shared libraries from
	# functioning.
	use static && append-flags -static
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS} ${LDFLAGS}" || die
}

src_install() {
	dobin symlinks || die
	doman symlinks.8 || die
	dodoc symlinks.lsm || die
}
