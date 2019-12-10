# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit xdg-utils

DESCRIPTION="Playlist handling library"
HOMEPAGE="http://libspiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/libspiff/${P}.tar.bz2"

LICENSE="BSD LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/expat-2
	>=dev-libs/uriparser-0.7.5"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( >=dev-util/cpptest-1.1 )"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

PATCHES=(
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${P}-gcc47.patch
)

src_prepare() {
	default
	xdg_environment_reset

	# do not install missing files
	sed -e 's/gif,//' -i doc/Makefile* \
		-i bindings/c/doc/Makefile* || die "sed failed"
}

src_configure() {
	econf \
		--disable-doc \
		$(use_enable static-libs static) \
		$(use_enable test)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
