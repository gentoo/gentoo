# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/bluefish/bluefish-2.2.7.ebuild,v 1.1 2015/07/20 08:39:44 amynka Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils fdo-mime python-single-r1

MY_P=${P/_/-}

DESCRIPTION="A GTK HTML editor for the experienced web designer or programmer"
SRC_URI="http://www.bennewitz.com/bluefish/stable/source/${MY_P}.tar.bz2"
HOMEPAGE="http://bluefish.openoffice.nl/"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="gucharmap nls python spell"

RDEPEND="
	x11-libs/gtk+:3
	sys-libs/zlib
	gucharmap? ( gnome-extra/gucharmap:* )
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

S=${WORKDIR}/${MY_P}

# there actually is just some broken manpage checkup -> not bother
RESTRICT="test"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

# Never eautoreconf this package as gettext breaks completely (no translations
# even if it compiles afterwards)!

src_prepare() {
	sed -i 's:gzip -n $< -c:gzip -n -c $<:' data/bflib/Makefile.* || die "Cannot fix makefile"
}

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
	find "${ED}" -name '*.la' -exec rm -f {} +
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	einfo "Adding XML catalog entries..."
	/usr/bin/xmlcatalog  --noout \
		--add 'public' 'Bluefish/DTD/Bflang' 'bflang.dtd' \
		--add 'system' 'http://bluefish.openoffice.nl/DTD/bflang.dtd' 'bflang.dtd' \
		--add 'rewriteURI' 'http://bluefish.openoffice.nl/DTD' '/usr/share/xml/bluefish-unstable' \
		/etc/xml/catalog \
		|| ewarn "Failed to add XML catalog entries."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	einfo "Removing XML catalog entries..."
	/usr/bin/xmlcatalog  --noout \
		--del 'Bluefish/DTD/Bflang' \
		--del 'http://bluefish.openoffice.nl/DTD/bflang.dtd' \
		--del 'http://bluefish.openoffice.nl/DTD' \
		/etc/xml/catalog \
		|| ewarn "Failed to remove XML catalog entries."
}
