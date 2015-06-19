# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/redshift/redshift-1.9.1-r2.ebuild,v 1.2 2015/04/08 17:27:16 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )

inherit systemd autotools eutils gnome2-utils python-r1

DESCRIPTION="A screen color temperature adjusting software"
HOMEPAGE="http://jonls.dk/redshift/"
SRC_URI="https://github.com/jonls/redshift/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="appindicator geoclue gtk nls"

COMMON_DEPEND=">=x11-libs/libX11-1.4
	x11-libs/libXxf86vm
	x11-libs/libxcb
	x11-libs/libdrm
	geoclue? ( app-misc/geoclue:0 dev-libs/glib:2 )
	gtk? ( ${PYTHON_DEPS} )"
RDEPEND="${COMMON_DEPEND}
	gtk? ( dev-python/pygobject[${PYTHON_USEDEP}]
		x11-libs/gtk+:3[introspection]
		dev-python/pyxdg[${PYTHON_USEDEP}] )"
DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )
	appindicator? ( dev-libs/libappindicator )
"

src_prepare() {
	epatch_user
	eautoreconf
}

src_configure() {
	python_export_best

	econf \
		--disable-silent-rules \
		$(use_enable nls) \
		--enable-drm \
		--enable-randr \
		--enable-vidmode \
		--disable-wingdi \
		$(use_enable geoclue) \
		$(use_enable gtk gui) \
		--with-systemduserunitdir="$(systemd_get_userunitdir)" \
		--disable-ubuntu
}

_impl_specific_src_install() {
	emake DESTDIR="${D}" pythondir="$(python_get_sitedir)" \
			-C src/redshift-gtk install
}

src_install() {
	emake DESTDIR="${D}" UPDATE_ICON_CACHE=/bin/true install

	if use gtk; then
		python_foreach_impl _impl_specific_src_install
		python_replicate_script "${D}"/usr/bin/redshift-gtk
		dosym redshift-gtk /usr/bin/gtk-redshift
	fi
}

pkg_preinst() {
	use gtk && gnome2_icon_savelist
}

pkg_postinst() {
	use gtk && gnome2_icon_cache_update
}

pkg_postrm() {
	use gtk && gnome2_icon_cache_update
}
