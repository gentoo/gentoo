# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libbson/libbson-1.1.2.ebuild,v 1.1 2015/03/23 08:59:35 ultrabug Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="A BSON utility library"
HOMEPAGE="https://github.com/mongodb/libbson"
SRC_URI="https://github.com/mongodb/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="debug examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	# https://github.com/mongodb/mongo-c-driver/issues/54
	sed -i -e "s/PTHREAD_LIBS/PTHREAD_CFLAGS/g" src/bson/Makefile.am \
		tests/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf --disable-hardening \
		--disable-optimizations \
		$(use_enable debug) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	doman doc/*.3

	use static-libs || find "${D}" -name '*.la' -delete

	if use examples; then
		insinto /usr/share/${PF}/examples
		doins examples/*.c
	fi
}
