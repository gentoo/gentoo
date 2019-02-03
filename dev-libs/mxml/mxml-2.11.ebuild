# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A small XML parsing library that you can use to read XML data files or strings"
HOMEPAGE="https://github.com/michaelrsweet/mxml
	https://www.msweet.org/mxml/"
SRC_URI="https://github.com/michaelrsweet/mxml/releases/download/v${PV}/${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
LICENSE="Mini-XML"
SLOT="0"
IUSE="static-libs test threads"

DEPEND="virtual/pkgconfig"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}"/respect-users-flags.patch )

src_prepare() {
	default

	eautoconf
}

src_configure() {
	local myeconfopts=(
		$(use_enable threads)
	)

	econf "${myeconfopts[@]}"
}

src_compile() {
	emake libmxml.so.1.6 doc/mxml.man mxmldoc
}

src_test() {
	emake testmxml
}

src_install() {
	emake DSTROOT="${ED}" install

	if ! use static-libs; then
		rm "${ED%/}"/usr/$(get_libdir)/libmxml.a || die
	fi
}
