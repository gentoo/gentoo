# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/terminology/terminology-9999.ebuild,v 1.1 2015/08/06 10:04:09 vapier Exp $

EAPI="5"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_SUB_PROJECT="core"
	EGIT_URI_APPEND="${PN}"
else
	SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${P}.tar.xz"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="Feature rich terminal emulator using the Enlightenment Foundation Libraries"
HOMEPAGE="http://www.enlightenment.org/p.php?p=about/terminology"

RDEPEND=">=dev-libs/efl-1.13.1
	>=media-libs/elementary-1.13.1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
