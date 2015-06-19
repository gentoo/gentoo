# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/arrayprobe/arrayprobe-2.0-r2.ebuild,v 1.6 2014/03/08 22:26:56 vapier Exp $

EAPI="4"

inherit eutils autotools

DESCRIPTION="CLI utility that reports the status of a HP (Compaq) array controller (both IDA & CCISS supported)"
HOMEPAGE="http://www.strocamp.net/opensource/arrayprobe.php"
SRC_URI="http://www.strocamp.net/opensource/compaq/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/${PV}-malloc-strlen.patch"
	epatch "${FILESDIR}/${PV}-ida_headers.patch"
	eautoreconf
}
