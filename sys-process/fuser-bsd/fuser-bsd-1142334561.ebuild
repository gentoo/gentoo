# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit base bsdmk eutils

MY_P="${PN/-bsd/}-${PV}"

PATCHLEVEL=1
DESCRIPTION="fuser(1) utility for *BSD"
HOMEPAGE="http://mbsd.msk.ru/stas/fuser.html"
SRC_URI="http://mbsd.msk.ru/dist/${MY_P}.tar.bz2
	mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND="sys-freebsd/freebsd-mk-defs"
# virtual/libc needed here for has_version to work.
RDEPEND="virtual/libc
	!sys-process/psmisc"

S="${WORKDIR}/${PN/-bsd/}"

src_prepare() {
	if has_version '>=sys-freebsd/freebsd-lib-8' ; then # any better way to	check it?
		EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
	fi
}

src_install() {
	into /
	dosbin fuser

	doman fuser.1
}
