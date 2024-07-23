# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A library for simplifying the drawing of beautiful curves"
HOMEPAGE="https://github.com/fontforge/libspiro"
SRC_URI="https://github.com/fontforge/libspiro/releases/download/${PV}/libspiro-dist-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
