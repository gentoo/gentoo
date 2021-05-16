# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Standard MIDI File format library"
HOMEPAGE="http://libsmf.sourceforge.net/api/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="doc readline"

RDEPEND="
	dev-libs/glib:2
	readline? ( sys-libs/readline:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_configure() {
	econf \
		--disable-static \
		$(use_with readline)
}

src_compile() {
	default

	if use doc; then
		doxygen doxygen.cfg || die
	fi
}

src_install() {
	use doc && local HTML_DOCS=( api )
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
