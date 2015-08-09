# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils libtool flag-o-matic

DESCRIPTION="Standard GNU database libraries"
HOMEPAGE="http://www.gnu.org/software/gdbm/gdbm.html"
SRC_URI="mirror://gnu/gdbm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="berkdb"

DEPEND="berkdb? ( sys-libs/db )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-fix-install-ownership.patch #24178
	epatch "${FILESDIR}"/${P}-compat-linking.patch #165263
	epatch "${FILESDIR}"/${P}-build.patch #209730
	elibtoolize
	append-lfs-flags
}

src_compile() {
	use berkdb || export ac_cv_lib_dbm_main=no ac_cv_lib_ndbm_main=no
	econf \
		--includedir=/usr/include/gdbm \
		--disable-dependency-tracking \
		--enable-fast-install \
		|| die
	emake || die
}

src_install() {
	emake -j1 INSTALL_ROOT="${D}" install install-compat || die
	mv "${D}"/usr/include/gdbm/gdbm.h "${D}"/usr/include/ || die
	dodoc ChangeLog NEWS README
}

pkg_preinst() {
	preserve_old_lib libgdbm.so.2 #32510
}

pkg_postinst() {
	preserve_old_lib_notify libgdbm.so.2 #32510

	ewarn "32bit systems might have to rebuild all gdbm databases due to"
	ewarn "LFS changes in the gdbm format.  You can either delete the db"
	ewarn "and regenerate it from scratch, or use the converter:"
	ewarn "http://bugs.gentoo.org/attachment.cgi?id=215326"
	ewarn
	ewarn "See this comment for information on how to use it:"
	ewarn "http://bugs.gentoo.org/299390#c15"
	ewarn
	ewarn "You should be able to locate most gdbm db's on your system with:"
	ewarn "find /etc /var -type f -exec file {} + | grep 'GNU dbm 1.x or ndbm database'"
	ewarn
	ewarn "You could also try using this helper script:"
	ewarn "http://bugs.gentoo.org/attachment.cgi?id=222581"
}
