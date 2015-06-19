# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-freebsd/freebsd-bin/freebsd-bin-9.1.ebuild,v 1.1 2013/01/27 21:24:08 aballier Exp $

inherit bsdmk freebsd

DESCRIPTION="FreeBSD /bin tools"
SLOT="0"
KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"

IUSE=""

SRC_URI="mirror://gentoo/${BIN}.tar.bz2
		mirror://gentoo/${UBIN}.tar.bz2
		mirror://gentoo/${SBIN}.tar.bz2
		mirror://gentoo/${LIB}.tar.bz2"

RDEPEND="=sys-freebsd/freebsd-lib-${RV}*
	>=dev-libs/libedit-20120311.3.0-r1
	sys-libs/ncurses
	sys-apps/ed
	!app-misc/realpath
	!<sys-freebsd/freebsd-ubin-8"
DEPEND="${RDEPEND}
	=sys-freebsd/freebsd-mk-defs-${RV}*
	>=sys-devel/flex-2.5.31-r2"

S=${WORKDIR}/bin

# csh and tcsh are provided by tcsh package, rmail is sendmail stuff.
REMOVE_SUBDIRS="csh rmail ed"

pkg_setup() {
	mymakeopts="${mymakeopts} WITHOUT_TCSH= WITHOUT_SENDMAIL= WITHOUT_RCMDS= "
}
