# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit enlightenment

DESCRIPTION="Show enlightenment echievements"

SRC_URI="https://download.enlightenment.org/releases/${P}.tar.bz2"
LICENSE="BSD-2"

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-games/etrophy-0.5.1
	dev-libs/e_dbus
	dev-libs/efl
	x11-wm/enlightenment:0.17="
DEPEND="${RDEPEND}
	virtual/pkgconfig"
