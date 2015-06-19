# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/qalculate-bases/qalculate-bases-0.9.4-r2.ebuild,v 1.8 2012/08/04 21:42:35 bicatali Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="GTK+ base conversion tool"
HOMEPAGE="http://qalculate.sourceforge.net/"
SRC_URI="mirror://sourceforge/qalculate/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
IUSE="nls"
KEYWORDS="~amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	sci-libs/libqalculate
	x11-libs/gtk+:2
	nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cln-config.patch
	eautoconf
}

src_configure() {
	econf --disable-clntest
}
