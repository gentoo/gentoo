# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="Utility functions for OsmocomBB, OpenBSC and related projects"
HOMEPAGE="http://bb.osmocom.org/trac/wiki/libosmocore"
SRC_URI="http://cgit.osmocom.org/cgit/libosmocore/snapshot/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="embedded"

RDEPEND="embedded? ( sys-libs/talloc )"
DEPEND="${RDEPEND}
	app-doc/doxygen"

src_prepare() {
	# set correct version in pkgconfig files
	sed -i "s/UNKNOWN/${PV}/" git-version-gen || die

	epatch "${FILESDIR}"/${PN}-0.6.0-automake-1.13.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable embedded)
}

src_install() {
	default
	# install to correct documentation directory
	mv "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/doc/${PF} || die
}
