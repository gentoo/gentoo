# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/symlinks/symlinks-1.4-r2.ebuild,v 1.1 2012/03/28 12:20:50 jlec Exp $

EAPI=4

inherit flag-o-matic eutils toolchain-funcs

DESCRIPTION="Scans for and fixes broken or messy symlinks"
HOMEPAGE="http://www.ibiblio.org/pub/linux/utils/file/"
SRC_URI="http://www.ibiblio.org/pub/linux/utils/file/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="static"

src_prepare() {
	# could be useful if being used to repair
	# symlinks that are preventing shared libraries from
	# functioning.
	use static && append-flags -static
	append-lfs-flags
	sed 's:-O2::g' -i Makefile || die
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CPPFLAGS} ${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin symlinks
	doman symlinks.8
	dodoc symlinks.lsm
}
