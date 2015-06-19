# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/etrophy/etrophy-0.5.1.ebuild,v 1.3 2014/02/16 14:10:29 tommy Exp $

EAPI=3

inherit enlightenment

DESCRIPTION="Library for managing scores, trophies and unlockables,stores them and provides views to display them"

SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"
LICENSE="BSD-2"

KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND="dev-libs/efl
	>=media-libs/elementary-1.8.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	MY_ECONF="
		$(use_enable doc)
		"

	enlightenment_src_configure
}
