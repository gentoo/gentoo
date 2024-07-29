# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="test program for capturing input device events"
HOMEPAGE="https://cgit.freedesktop.org/evtest/"
#SRC_URI="https://cgit.freedesktop.org/evtest/snapshot/${PN}-${P}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://gitlab.freedesktop.org/libevdev/evtest/-/archive/${P}/${PN}-${P}.tar.bz2"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc x86"

BDEPEND="app-text/asciidoc
	app-text/xmlto"

src_prepare() {
	default

	eautoreconf
}
