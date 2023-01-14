# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit python-single-r1

DESCRIPTION="Library for International Press Telecommunications Council (IPTC) metadata"
HOMEPAGE="https://github.com/ianw/libiptcdata http://libiptcdata.sourceforge.net"
SRC_URI="https://github.com/ianw/${PN}/releases/download/release_1_0_5/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE="doc examples nls python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	nls? ( virtual/libintl )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( >=dev-util/gtk-doc-1 )
	nls? ( >=sys-devel/gettext-0.13.1 )
"

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
