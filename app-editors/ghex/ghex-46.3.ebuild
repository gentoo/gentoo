# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="GNOME hexadecimal editor"
HOMEPAGE="https://gitlab.gnome.org/GNOME/ghex"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/ghex.git"
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2+ FDL-1.1+"
SLOT="4"
IUSE="gtk-doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.68.0:2
	>=gui-libs/gtk-4.4.0:4
	>=gui-libs/libadwaita-1.2:1
	dev-libs/gobject-introspection
	!app-editors/ghex:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? ( dev-util/gi-docgen )
	test? (
		dev-util/desktop-file-utils
		dev-libs/appstream-glib
	)
	dev-util/gtk-update-icon-cache
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Ddocdir="${EPREFIX}"/usr/share/gtk-doc/
		-Ddevelopment=false
		-Dmmap-buffer-backend=true
		-Ddirect-buffer-backend=true
		-Dintrospection=enabled
		$(meson_use gtk-doc gtk_doc)
		-Dstatic-html-help=false
		-Dvapi=false
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
