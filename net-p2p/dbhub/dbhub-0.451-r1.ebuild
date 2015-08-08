# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit autotools eutils

DESCRIPTION="Hub software for Direct Connect, fork of opendchub"
HOMEPAGE="http://www.dbhub.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug perl nls switch_user"

DEPEND="perl? ( dev-lang/perl )
	switch_user? ( sys-libs/libcap )"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-gentoo.patch \
		"${FILESDIR}"/${PN}-no-dynaloader.patch \
		"${FILESDIR}"/${PN}-fix-buffer-overflows.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable perl) \
		$(use_enable switch_user) \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die
}
