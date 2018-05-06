# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit gnome2-utils python-single-r1 xdg-utils

MY_P=${P/_/-}

DESCRIPTION="A GTK HTML editor for the experienced web designer or programmer"
SRC_URI="http://www.bennewitz.com/bluefish/stable/source/${MY_P}.tar.bz2"
HOMEPAGE="http://bluefish.openoffice.nl/"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
SLOT="0"
IUSE="nls python spell"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	x11-libs/gtk+:3
	gnome-extra/gucharmap:2.90
	sys-libs/zlib
	python? ( ${PYTHON_DEPS} )
	spell? ( app-text/enchant )"
DEPEND="${RDEPEND}
	>=dev-libs/glib-2.16:2
	dev-libs/libxml2:2
	virtual/pkgconfig
	x11-libs/pango
	nls? (
		sys-devel/gettext
		dev-util/intltool
	)"

S="${WORKDIR}/${MY_P}"

# there actually is just some broken manpage checkup -> not bother
RESTRICT="test"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

# Never eautoreconf this package as gettext breaks completely (no translations
# even if it compiles afterwards)!

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--disable-dependency-tracking \
		--disable-update-databases \
		--disable-xml-catalog-update \
		$(use_enable nls) \
		$(use_enable spell spell-check) \
		$(use_enable python)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

	einfo "Adding XML catalog entries..."
	/usr/bin/xmlcatalog  --noout \
		--add 'public' 'Bluefish/DTD/Bflang' 'bflang.dtd' \
		--add 'system' 'http://bluefish.openoffice.nl/DTD/bflang.dtd' 'bflang.dtd' \
		--add 'rewriteURI' 'http://bluefish.openoffice.nl/DTD' '/usr/share/xml/bluefish-unstable' \
		/etc/xml/catalog \
		|| ewarn "Failed to add XML catalog entries."
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	einfo "Removing XML catalog entries..."
	/usr/bin/xmlcatalog  --noout \
		--del 'Bluefish/DTD/Bflang' \
		--del 'http://bluefish.openoffice.nl/DTD/bflang.dtd' \
		--del 'http://bluefish.openoffice.nl/DTD' \
		/etc/xml/catalog \
		|| ewarn "Failed to remove XML catalog entries."
}
