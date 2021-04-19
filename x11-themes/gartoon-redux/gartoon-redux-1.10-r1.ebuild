# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils

DESCRIPTION="A massively improved variant of the well-known Gartoon theme"
HOMEPAGE="https://gnome-look.org/content/show.php/?content=74841"
SRC_URI="http://tweenk.artfx.pl/gartoon/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-lang/perl
	dev-perl/Switch
	gnome-base/librsvg
"

RESTRICT="binchecks strip"

PATCHES=(
	"${FILESDIR}"/${PN}-1.10-rsvg-convert.patch
)

src_configure() {
	# perl script, not autotools based
	./configure --prefix=/usr || die
}

src_compile() {
	unset XDG_CACHE_HOME # bug 588708
	emake prepare
	emake
}

src_install() {
	emake icondir="${D}"/usr/share/icons/GartoonRedux install
	dodoc AUTHORS changelog README TODO
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
