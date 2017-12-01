# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils autotools

DESCRIPTION="Utility to report status of an HP (Compaq) array controller (both IDA & CCISS)"
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
