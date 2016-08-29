# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="Indicator plugin for Pidgin"
HOMEPAGE="https://github.com/philipl/pidgin-indicator"
SRC_URI="https://github.com/philipl/pidgin-indicator/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/glib:2
	dev-libs/libappindicator:2
	net-im/pidgin[gtk]
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
}

src_install() {
	default
	find "${D}" -name "*.la" -exec rm {} + || die
}
