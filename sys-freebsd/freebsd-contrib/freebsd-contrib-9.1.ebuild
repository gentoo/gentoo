# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit bsdmk freebsd flag-o-matic multilib

DESCRIPTION="Contributed sources for FreeBSD"
SRC_URI="mirror://gentoo/${GNU}.tar.bz2
	mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD GPL-2+ libodialog"
SLOT="0"
KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="=sys-freebsd/freebsd-sources-${RV}*
	=sys-freebsd/freebsd-mk-defs-${RV}*"

S="${WORKDIR}/gnu"

src_unpack() {
	echo ">>> Unpacking needed parts of ${GNU}.tar.bz2 to ${WORKDIR}"
	tar -jxpf "${DISTDIR}/${GNU}.tar.bz2" gnu/lib/libodialog gnu/usr.bin/sort gnu/usr.bin/patch
	echo ">>> Unpacking needed parts of ${CONTRIB}.tar.bz2 to ${WORKDIR}"
	tar -jxpf "${DISTDIR}/${CONTRIB}.tar.bz2" contrib/gnu-sort

	freebsd_do_patches
	freebsd_rename_libraries
}

src_compile() {
	cd "${S}/lib/libodialog"
	freebsd_src_compile

	cd "${S}/usr.bin/sort"
	freebsd_src_compile

	cd "${S}/usr.bin/patch"
	freebsd_src_compile
}

src_install() {
	use profile || mymakeopts="${mymakeopts} NO_PROFILE= "
	mymakeopts="${mymakeopts} NO_MANCOMPRESS= NO_INFOCOMPRESS= "

	cd "${S}/lib/libodialog"
	mkinstall LIBDIR="/usr/$(get_libdir)" || die "libodialog install failed"

	cd "${S}/usr.bin/sort"
	mkinstall BINDIR="/bin/" || die "sort install failed"

	cd "${S}/usr.bin/patch"
	mkinstall BINDIR="/usr/bin/" || die "patch install failed"
}
