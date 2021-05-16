# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="An Al Bhed translator"
HOMEPAGE="http://liquidchile.net/software/gbhed/"
SRC_URI="http://liquidchile.net/software/gbhed/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

DEPEND="gtk? ( x11-libs/gtk+:2 )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i 's/19/32/' src/gui/translation_fork.c || die
}

src_configure() {
	econf \
		--datadir=/usr/share/${PN} \
		$(use_enable gtk gbhed)
}

src_install() {
	emake -C src DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
	doman doc/abtranslate.1

	if use gtk ; then
		insinto /usr/share/${PN}/pixmaps
		doins pixmaps/*.{jpg,png,xpm}

		newicon pixmaps/gbhed48.png ${PN}.png

		make_desktop_entry gbhed ${PN}
		doman doc/gbhed.1
	fi
}
