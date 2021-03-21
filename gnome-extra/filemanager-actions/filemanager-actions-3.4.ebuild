# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="File manager extension which offers user configurable context menu actions"
HOMEPAGE="https://gitlab.gnome.org/GNOME/filemanager-actions"

LICENSE="GPL-2+ FDL-1.3"
SLOT="3"
KEYWORDS="amd64 ~x86"
IUSE="caja +nautilus nemo"
REQUIRED_USE="|| ( caja nautilus nemo )"

RDEPEND="
	>=x11-libs/gtk+-3.4.1:3
	>=dev-libs/glib-2.32.1:2
	>=gnome-base/libgtop-2.28.4:2
	>=dev-libs/libxml2-2.7.8:2
	sys-apps/util-linux
	nautilus? ( >=gnome-base/nautilus-3.4.1 )
	nemo? ( >=gnome-extra/nemo-1.8 )
	caja? ( >=mate-base/caja-1.16.0 )
	x11-libs/gdk-pixbuf:2
"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.50.2
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/fix-desktop-file.patch
	"${FILESDIR}"/fix-help-file.patch
)

src_prepare() {
	# install docs in /usr/share/doc/${PF}, not ${P}
	sed -i -e "s:/doc/@PACKAGE@-@VERSION@:/doc/${PF}:g" \
		Makefile.{am,in} \
		docs/Makefile.{am,in} \
		docs/manual/Makefile.{am,in} || die
	# Don't install HTML manual, there's already ghelp manual in /usr/share/gnome/help, opened in yelp via F1
	sed -i -e "s|install-data-local: install-manuals|install-data-local:|g" docs/manual/Makefile.{am,in} || die
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-docs \
		--enable-deprecated \
		--disable-gconf \
		$(use_with caja) \
		$(use_with nautilus) \
		$(use_with nemo)
}

src_install() {
	gnome2_src_install
	# Do not install files we don't really want in docdir
	rm -v "${ED}usr/share/doc/${PF}"/COPYING* || die
	rm -v "${ED}usr/share/doc/${PF}"/INSTALL* || die
	rm -v "${ED}usr/share/doc/${PF}"/objects-hierarchy.odg* || die
	# Currently empty AUTHORS (but newline including, so it doesn't get automatically deleted) - this is not the case in next release after 3.4
	rm -v "${ED}usr/share/doc/${PF}"/AUTHORS* || die
}
