# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Message Digest functions from BSD systems"
HOMEPAGE="https://www.hadrons.org/software/libmd/"
SRC_URI="https://archive.hadrons.org/software/libmd/${P}.tar.xz"

LICENSE="|| ( BSD BSD-2 ISC BEER-WARE public-domain )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

src_configure() {
	econf --disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
