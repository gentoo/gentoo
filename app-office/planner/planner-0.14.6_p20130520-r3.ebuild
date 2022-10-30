# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Project manager for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Planner"
if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://gitlab.gnome.org/World/planner.git"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://dev.gentoo.org/~eva/distfiles/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
fi

SLOT="0"
LICENSE="GPL-2"

IUSE="examples"

RDEPEND="
	>=dev-libs/glib-2.6:2
	>=x11-libs/gtk+-2.24:2
	>=gnome-base/gconf-2.10:2
	>=gnome-base/libgnomecanvas-2.10
	>=gnome-base/libglade-2.4:2.0
	>=dev-libs/libxml2-2.6.27:2
	>=dev-libs/libxslt-1.1.23
"
DEPEND="${RDEPEND}"

BDEPEND="
	dev-util/gtk-doc-am
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.35.5
	gnome-base/gnome-common
	virtual/pkgconfig
	app-text/rarian
"

S="${WORKDIR}/${PN}-0.14.6"
src_configure() {
	# FIXME: disable eds backend for now, it fails, upstream bug #654005
	# FIXME: disable eds for now, bug #784086
	# We need to set compile-warnings to a different value as it doesn't use
	# standard macro: https://bugzilla.gnome.org/703067
	gnome2_src_configure \
		--disable-python \
		--disable-python-plugin \
		--disable-eds \
		--disable-eds-backend \
		--with-database=no \
		--disable-update-mimedb \
		--enable-compile-warnings=yes
}

src_install() {
	MAKEOPTS="${MAKEOPTS} -j1" gnome2_src_install
	mv "${ED}"/usr/share/doc/planner "${ED}"/usr/share/doc/${PF} || die
	if ! use examples; then
		rm -rf "${D}/usr/share/doc/${PF}/examples"
	fi
}
