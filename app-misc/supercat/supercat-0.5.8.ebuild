# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A text file colorizer using powerful regular expressions"
HOMEPAGE="http://supercat.nosredna.net"
SRC_URI="http://supercat.nosredna.net/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc64 ~sparc x86"

src_configure() {
	econf --with-system-directory="${EPREFIX}/etc/supercat"
}
