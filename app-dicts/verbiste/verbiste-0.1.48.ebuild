# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

DESCRIPTION="French conjugation system"
HOMEPAGE="http://sarrazip.com/dev/verbiste.html"
SRC_URI="http://sarrazip.com/dev/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE="gtk"

RDEPEND="
	>=dev-libs/libxml2-2.4.0:2
	gtk? ( >=x11-libs/gtk+-2.6:2 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myeconfargs=(
		--with-console-app
		--without-gnome-app
		--without-gnome-applet
		$(use_with gtk gtk-app)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc HACKING LISEZMOI
	# file is only installed with USE=gnome
	if use gtk; then
		sed -e 's/Exec=.*/Exec=verbiste-gtk/' \
			-i src/gnome/verbiste.desktop || die
		domenu src/gnome/verbiste.desktop
	fi

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	if use gtk; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use gtk; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
