# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="FFS/UFS/UFS2 filesystem utilities from FreeBSD"
HOMEPAGE="http://packages.debian.org/source/sid/ufsutils"

SRC_URI="mirror://debian/pool/main/u/${PN}/${PN}_${PV%_*}.orig.tar.gz
	mirror://debian/pool/main/u/${PN}/${PN}_${PV%_*}-${PV##*_p}.debian.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/libbsd
	dev-libs/libedit
	sys-libs/ncurses"

S="${WORKDIR}/${P%_*}"

src_prepare() {
	EPATCH_SOURCE="${WORKDIR}/debian/patches" EPATCH_SUFFIX="patch" \
        	EPATCH_OPTS="-p1" EPATCH_FORCE="yes" epatch

	# growfs is not properly ported
	sed -e "s:sbin/growfs::" -i Makefile

	sed -e "s:^\(prefix = \)\(.*\):\1${EPREFIX}usr:" \
		-e "s:^\(libdir = \$(exec_prefix)\/\)\(.*\):\1$(get_libdir):" \
		-i Makefile.common
}

src_compile(){
	emake -j1
}

src_install() {
	dodir /usr/$(get_libdir)
	dodir /usr/sbin
	dodir /usr/share/man/man8
	emake DESTDIR="${ED}" install
}
