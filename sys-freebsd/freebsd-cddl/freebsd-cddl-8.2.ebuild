# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-freebsd/freebsd-cddl/freebsd-cddl-8.2.ebuild,v 1.3 2013/02/07 01:05:36 naota Exp $

inherit bsdmk freebsd flag-o-matic eutils

DESCRIPTION="FreeBSD CDDL (opensolaris/zfs) extra software"
SLOT="0"
KEYWORDS="~x86-fbsd"

IUSE="build"
LICENSE="CDDL GPL-2"

SRC_URI="mirror://gentoo/${P}.tar.bz2
		mirror://gentoo/${CONTRIB}.tar.bz2
		mirror://gentoo/${UBIN}.tar.bz2
		mirror://gentoo/${LIB}.tar.bz2
		mirror://gentoo/${SBIN}.tar.bz2
		mirror://gentoo/${SYS}.tar.bz2
		build? ( mirror://gentoo/${INCLUDE}.tar.bz2 )"

# sys is required.

RDEPEND="=sys-freebsd/freebsd-lib-${RV}*
	=sys-freebsd/freebsd-libexec-${RV}*
	build? ( sys-apps/baselayout )
	dev-libs/libedit
	dev-libs/libelf"

DEPEND="${RDEPEND}
	=sys-freebsd/freebsd-mk-defs-${RV}*
	!build? ( =sys-freebsd/freebsd-sources-${RV}* )"

S="${WORKDIR}/cddl"

PATCHES=( "${FILESDIR}/${PN}-8.0-libpaths.patch" "${FILESDIR}/${PN}-8.2-libpaths.patch" )

src_unpack() {
	freebsd_src_unpack
	# Link in include headers.
	ln -s "/usr/include" "${WORKDIR}/include" || die "Symlinking /usr/include.."
}

src_install() {
	freebsd_src_install
	# Install zfs volinit script.
	newinitd "${FILESDIR}"/zvol.initd zvol
}
