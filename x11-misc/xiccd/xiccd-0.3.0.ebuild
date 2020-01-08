# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A desktop environment-independent bridge between colord and X"
HOMEPAGE="https://github.com/agalakhov/xiccd"
SRC_URI="https://github.com/agalakhov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-libs/glib:2
	x11-apps/xrandr
	x11-misc/colord"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}
