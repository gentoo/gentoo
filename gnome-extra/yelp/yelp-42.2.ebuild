# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Yelp"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"

RDEPEND="
	app-arch/bzip2:=
	>=app-arch/xz-utils-4.9:=
	dev-db/sqlite:3=
	>=dev-libs/glib-2.67.4:2
	>=dev-libs/libxml2-2.6.5:2
	>=dev-libs/libxslt-1.1.4
	>=gnome-extra/yelp-xsl-41.0
	>=net-libs/webkit-gtk-2.19.2:4
	>=x11-libs/gtk+-3.13.3:3
	>=gui-libs/libhandy-1.5.0:1
	x11-themes/adwaita-icon-theme
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	>=dev-util/gtk-doc-am-1.13
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# Fix compatibility with Gentoo's sys-apps/man
	# https://bugzilla.gnome.org/show_bug.cgi?id=648854
	"${FILESDIR}"/${PN}-3.20.0-man-compatibility.patch # needs eautoreconf
)

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-webkit2gtk-4-0 \
		--enable-bz2 \
		--enable-lzma \
		APPSTREAM_UTIL=$(type -P true)
}

src_install() {
	gnome2_src_install
	exeinto /usr/libexec/
	doexe "${S}"/libyelp/yelp-groff
}
