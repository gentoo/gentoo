# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson-multilib multilib xdg plocale

PLOCALES="ab af ang ar as ast az be be@latin bg bn bn_IN br bs ca ca@valencia crh cs csb cy da de dz el en_CA en_GB en@shaw eo es et eu fa fi fr fur ga gl gu he hi hr hu hy ia id io is it ja ka kk km kn ko ku li lt lv mai mi mk ml mn mr ms my nb nds ne nl nn nso oc or pa pl ps pt pt_BR ro ru si sk sl sq sr sr@ije sr@latin sv ta te tg th tk tr tt ug uk uz uz@cyrillic vi wa xh yi zh_CN zh_HK zh_TW"

DESCRIPTION="Image loading library for GTK+"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gdk-pixbuf"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="gtk-doc +introspection jpeg man test tiff"
RESTRICT="!test? ( test )"

# TODO: For windows/darwin support: shared-mime-info conditional, native_windows_loaders option review
DEPEND="
	>=dev-libs/glib-2.56.0:2[${MULTILIB_USEDEP}]
	x11-misc/shared-mime-info
	>=media-libs/libpng-1.4:0=[${MULTILIB_USEDEP}]
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-3.9.2:=[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	gtk-doc? ( >=dev-util/gi-docgen-2021.1 )
	man? (
		app-text/docbook-xsl-stylesheets
		app-text/docbook-xml-dtd:4.3
		dev-libs/libxslt
		dev-python/docutils
	)
	dev-libs/glib:2
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gdk-pixbuf-query-loaders$(get_exeext)
)

src_prepare() {
	default
	plocale_get_locales > po/LINGUAS || die
	xdg_environment_reset
}

multilib_src_configure() {
	local emesonargs=(
		-Dpng=enabled
		$(meson_feature tiff)
		$(meson_feature jpeg)
		-Dbuiltin_loaders=png,jpeg
		-Drelocatable=false
		#native_windows_loaders
		$(meson_use test tests)
		-Dinstalled_tests=false
		-Dgio_sniffing=true
		$(meson_native_use_bool gtk-doc gtk_doc)
		$(meson_native_use_feature introspection)
		$(meson_native_use_bool man)
	)

	meson_src_configure
}

multilib_src_install_all() {
	einstalldocs
	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/gdk-pixbuf "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/gdk-pixdata "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

pkg_preinst() {
	xdg_pkg_preinst

	multilib_pkg_preinst() {
		# Make sure loaders.cache belongs to gdk-pixbuf alone
		local cache="usr/$(get_libdir)/${PN}-2.0/2.10.0/loaders.cache"

		if [[ -e ${EROOT}/${cache} ]]; then
			cp "${EROOT}"/${cache} "${ED}"/${cache} || die
		else
			touch "${ED}"/${cache} || die
		fi
	}

	multilib_foreach_abi multilib_pkg_preinst
	gnome2_gdk_pixbuf_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	multilib_foreach_abi gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	xdg_pkg_postrm

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		rm -f "${EROOT}"/usr/lib*/${PN}-2.0/2.10.0/loaders.cache
	fi
}
