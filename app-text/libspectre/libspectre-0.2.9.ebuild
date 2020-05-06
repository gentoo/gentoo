# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library for rendering Postscript documents"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libspectre"
SRC_URI="https://libspectre.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="debug doc"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND=">=app-text/ghostscript-gpl-9.24"
DEPEND="${RDEPEND}"

# does not actually test anything, see bug 362557
RESTRICT="test"

PATCHES=( "${FILESDIR}"/${PN}-0.2.0-interix.patch )

src_prepare() {
	default
	eautoreconf # need new libtool for interix
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug asserts)
		$(use_enable debug checks)
		--disable-test
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake
	if use doc; then
		doxygen || die
	fi
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )
	default
	find "${D}" -name '*.la' -type f -delete || die
}
