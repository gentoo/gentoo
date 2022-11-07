# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson-multilib multilib xdg

DESCRIPTION="Image loading library for GTK+"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gdk-pixbuf"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="gtk-doc +introspection jpeg test tiff"
RESTRICT="!test? ( test )"

# TODO: For windows/darwin support: shared-mime-info conditional, native_windows_loaders option review
DEPEND="
	>=dev-libs/glib-2.56.0:2[${MULTILIB_USEDEP}]
	x11-misc/shared-mime-info
	>=media-libs/libpng-1.4:0=[${MULTILIB_USEDEP}]
	jpeg? ( media-libs/libjpeg-turbo:0=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-3.9.2:0[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	gtk-doc? ( >=dev-util/gi-docgen-2021.1 )
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.3
	dev-libs/glib:2
	dev-libs/libxslt
	dev-python/docutils
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gdk-pixbuf-query-loaders$(get_exeext)
)

src_prepare() {
	default
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
		$(meson_native_true man)
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
