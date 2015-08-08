# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools base eutils gnome2 libtool

DESCRIPTION="A DTP application for the X Window System"
HOMEPAGE="http://www.stacken.kth.se/project/pptout/"
SRC_URI="mirror://gnome/sources/passepartout/0.7/passepartout-0.7.0.tar.bz2"

IUSE="gnome"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEPS="dev-cpp/libxmlpp:2.6
	>=dev-libs/libxml2-2
	dev-cpp/gtkmm:2.4
	dev-cpp/libgnomecanvasmm:2.6
	dev-libs/glib:2
	dev-libs/libsigc++:2
	media-libs/freetype:2
	virtual/fam
	gnome? (
			gnome-base/libgnome
			gnome-base/gnome-vfs
	)
	"

RDEPEND="${COMMON_DEPS}
	dev-libs/libxslt
	app-text/ghostscript-gpl"

DEPEND="${COMMON_DEPS}
	virtual/pkgconfig"

DOCS="AUTHORS BUGS NEWS README"

# GCC-4.2 patch:
# http://bugzilla.gnome.org/477017
# GCC-4.3 patch:
# Snatched from Debian
# http://bugzilla.gnome.org/565131
# include-flags:
# http://bugzilla.gnome.org/464517
# libtoolization:
# http://bugzilla.gnome.org/464567
# libxml-2.6:
# http://bugzilla.gnome.org/449596

# The include and libtoolization patches are needed for
# forced as-needed to work.

PATCHES=(
		"${FILESDIR}/${P}-gcc42.patch"
		"${FILESDIR}/${P}-gcc43.patch"
		"${FILESDIR}/${P}-gcc44.patch"
		"${FILESDIR}/${P}-include-flags.patch"
		"${FILESDIR}/${P}-libtoolization.patch"
		"${FILESDIR}/${P}-safer.patch"
		"${FILESDIR}/${P}-libxmlpp-2.6-depend.patch"
		"${FILESDIR}/${P}-automake-1.13.patch"
	)

src_unpack() {
	base_src_unpack
}

src_prepare() {
	gnome2_omf_fix
	base_src_prepare
	eautoreconf
	elibtoolize
}

src_configure() {
	# Bug 367867: Broken AC_ARG_WITH
	use gnome && G2CONF="--with-gnome"
	gnome2_src_configure
}

src_compile() {
	base_src_compile
}

src_install() {
	gnome2_src_install
	mv "${D}"/usr/share/doc/${PN}/* "${D}/usr/share/doc/${PF}" || die
	rmdir "${D}"/usr/share/doc/${PN}/ || die
	make_desktop_entry "/usr/bin/passepartout" "Passepartout DTP" "" "GNOME;Graphics"
}
