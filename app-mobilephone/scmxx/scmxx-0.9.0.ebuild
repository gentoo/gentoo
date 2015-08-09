# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Exchange data with Siemens phones"
HOMEPAGE="http://www.hendrik-sattler.de/scmxx/"
SRC_URI="mirror://sourceforge/scmxx/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="bluetooth nls"

RDEPEND="bluetooth? ( net-wireless/bluez )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	exeinto /usr/lib/scmxx
	doexe contrib/*

	doman docs/*.1

	rm docs/README_WIN32.txt
	dodoc AUTHORS BUGS CHANGELOG README TODO docs/*.txt
}
