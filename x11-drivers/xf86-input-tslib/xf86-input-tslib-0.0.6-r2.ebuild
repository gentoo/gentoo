# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit xorg-2

PATCHLEVEL=3
DEBSOURCES="${PN}_${PV}-${PATCHLEVEL}.tar.gz"

DESCRIPTION="xorg input driver for use of tslib based touchscreen devices"
HOMEPAGE="http://www.pengutronix.de/software/xf86-input-tslib/index_en.html"
SRC_URI="ftp://cdn.debian.net/debian/pool/main/x/${PN}/${DEBSOURCES}"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE=""

RDEPEND="x11-libs/tslib"
DEPEND="${RDEPEND}
	x11-proto/randrproto"

S=${WORKDIR}/${PN}-trunk

DOCS=( COPYING ChangeLog )

PATCHES=(
	"${FILESDIR}"/fix-overlapped-variable.patch
	"${FILESDIR}"/${PN}-port-ABI-12-r48.patch
)
