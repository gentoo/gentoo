# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit gnome2-utils xdg

DESCRIPTION="M17N engine for IBus"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://github.com/ibus/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk gtk3 nls"
REQUIRED_USE="?? ( gtk gtk3 )"

DEPEND="app-i18n/ibus
	dev-libs/m17n-lib
	gtk? ( gui-libs/gtk:4 )
	gtk3? ( x11-libs/gtk+:3 )
	nls? ( virtual/libintl )"
RDEPEND="${DEPEND}
	>=dev-db/m17n-db-1.7"
BDEPEND="sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable nls) \
		--with-gtk=$(usex gtk 4.0 $(usex gtk3 3.0 no))
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
