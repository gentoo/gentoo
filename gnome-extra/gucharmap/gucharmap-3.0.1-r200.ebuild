# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="Unicode character map viewer library"
HOMEPAGE="https://wiki.gnome.org/Apps/Gucharmap"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="cjk debug doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.16.3:2
	>=x11-libs/pango-1.2.1[introspection?]
	>=x11-libs/gtk+-2.14.0:2[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	# .desktop and schema files are only needed for the gucharmap program
	sed -e 's:desktop_DATA\s*=.*:desktop_DATA = :' \
		-e 's:schema_DATA\s*=.*:schema_DATA = :' \
		-i Makefile.* || die "sed Makefile.* failed"

	eapply "${FILESDIR}/${PN}-3.4.1.1-fix-doc.patch" # bug 436710, fixed in 3.6

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-gtk=2.0 \
		--disable-charmap \
		--disable-gconf \
		$(use_enable cjk unihan) \
		$(use_enable debug) \
		$(use_enable introspection)
}

pkg_postinst() {
	gnome2_pkg_postinst
	if ! has_version "gnome-extra/gucharmap:2.90" ; then
		ewarn "Note: ${PF} includes only the gucharmap-2 library."
		ewarn "If you need the gucharmap program, emerge gucharmap:2.90"
	fi
}
