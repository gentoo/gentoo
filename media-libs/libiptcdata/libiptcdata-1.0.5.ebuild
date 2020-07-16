# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit python-single-r1

DESCRIPTION="Library for International Press Telecommunications Council (IPTC) metadata"
HOMEPAGE="https://github.com/ianw/libiptcdata http://libiptcdata.sourceforge.net"
SRC_URI="https://github.com/ianw/${PN}/releases/download/release_1_0_5/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc examples nls python"

RDEPEND="
	nls? ( virtual/libintl )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( >=dev-util/gtk-doc-1 )
	nls? ( >=sys-devel/gettext-0.13.1 )
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure () {
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable python)
		$(use_enable doc gtk-doc)
	)
	econf "${myeconfargs[@]}"
}

src_install () {
	default

	if use examples; then
		dodoc python/README
		dodoc -r python/examples
	fi

	find "${D}" -name '*.la' -delete || die "failed to remove *.la files"
}
