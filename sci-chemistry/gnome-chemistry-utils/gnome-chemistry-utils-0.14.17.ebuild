# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools xdg

DESCRIPTION="Programs and library containing GTK widgets and C++ classes related to chemistry"
HOMEPAGE="http://gchemutils.nongnu.org/"
SRC_URI="http://download.savannah.gnu.org/releases/gchemutils/$(ver_cut 1-2)/${P}.tar.xz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
IUSE="gnumeric"

RDEPEND="
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-libs/glib-2.36.0:2
	>=dev-libs/libxml2-2.4.16:2
	>=gnome-extra/libgsf-1.14.9
	>=sci-chemistry/bodr-5
	>=sci-chemistry/chemical-mime-data-0.1.94
	>=sci-chemistry/openbabel-2.3.0:0
	>=x11-libs/cairo-1.6.0
	>=x11-libs/gdk-pixbuf-2.22.0
	>=x11-libs/goffice-0.10.12
	x11-libs/gtk+:3
	>=x11-libs/libX11-1.0.0
	gnumeric? ( >=app-office/gnumeric-1.12.42 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-doc/doxygen
	gnome-base/gnome-common
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare

	# From Debian
	eapply "${FILESDIR}/${P}-gnumeric.patch"
	eautoreconf
}

src_configure() {
	# lasem is not in the tree
	econf \
		--without-lasem \
		--disable-mozilla-plugin \
		--disable-scrollkeeper \
		--disable-update-databases
}

src_install() {
	default

	mv "${ED}"/usr/share/appdata "${ED}"/usr/share/metainfo || die
	rm -rf "${ED}"/usr/share/mimelnk/ || die

	find "${D}" -name '*.la' -type f -delete || die
}
