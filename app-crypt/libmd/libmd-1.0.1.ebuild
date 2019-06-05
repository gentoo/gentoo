# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib

DESCRIPTION="Message Digest functions from BSD systems"
HOMEPAGE="https://www.hadrons.org/software/libmd/"
SRC_URI="https://archive.hadrons.org/software/libmd/${P}.tar.xz"

LICENSE="|| ( BSD BSD-2 ISC BEER-WARE public-domain )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/libmd.la || die
	fi
}
