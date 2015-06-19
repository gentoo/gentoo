# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libosmocore/libosmocore-9999.ebuild,v 1.7 2015/04/15 14:25:49 chithanh Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="Utility functions for OsmocomBB, OpenBSC and related projects"
HOMEPAGE="http://bb.osmocom.org/trac/wiki/libosmocore"

if [[ ${PV} == 9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://git.osmocom.org/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="http://cgit.osmocom.org/cgit/libosmocore/snapshot/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-2 LGPL-3"
SLOT="0"
IUSE="embedded pcsc-lite"

RDEPEND="embedded? ( sys-libs/talloc )
	pcsc-lite? ( sys-apps/pcsc-lite )"
DEPEND="${RDEPEND}
	app-doc/doxygen"

src_prepare() {
	# set correct version in pkgconfig files
	sed -i "s/UNKNOWN/${PV}/" git-version-gen || die

	epatch "${FILESDIR}"/${PN}-0.6.0-automake-1.13.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable embedded) \
		$(use_enable pcsc-lite pcsc)
}

src_install() {
	default
	# install to correct documentation directory
	mv "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/doc/${PF} || die
}
