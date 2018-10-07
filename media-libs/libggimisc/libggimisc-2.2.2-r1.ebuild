# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Adds support for some special graphical target features"
HOMEPAGE="https://ibiblio.org/ggicore/packages/libggimisc.html"
SRC_URI="mirror://sourceforge/ggi/${P}.src.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fbcon svga"

RDEPEND=">=media-libs/libggi-2.2.2
	svga? ( media-libs/svgalib )"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README TODO doc/ggimisc.txt doc/libggimisc{,-functions,-libraries}.txt
	doc/retrace.txt )

src_configure() {
	econf --disable-x --without-x \
		$(use_enable svga svgalib) \
		$(use_enable fbcon fbdev) \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "X extension for ${PN} has been temporarily disabled for this release."
}
