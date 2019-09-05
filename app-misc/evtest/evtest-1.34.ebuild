# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="test program for capturing input device events"
HOMEPAGE="https://cgit.freedesktop.org/evtest/"
SRC_URI="https://cgit.freedesktop.org/evtest/snapshot/${PN}-${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

BDEPEND="virtual/pkgconfig"

DEPEND="app-text/asciidoc
	app-text/xmlto"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	default
	eautoreconf
}
