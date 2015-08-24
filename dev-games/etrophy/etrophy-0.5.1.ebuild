# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit enlightenment

DESCRIPTION="Library for managing scores, trophies and unlockables,stores them and provides views to display them"

SRC_URI="https://download.enlightenment.org/releases/${P}.tar.bz2"
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
