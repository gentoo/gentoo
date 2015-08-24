# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2-utils python-r1

DESCRIPTION="A screen color temperature adjusting software"
HOMEPAGE="http://jonls.dk/redshift/"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geoclue gnome gtk nls"

COMMON_DEPEND=">=x11-libs/libX11-1.4
	x11-libs/libXxf86vm
	x11-libs/libxcb
	geoclue? ( app-misc/geoclue:0 )
	gnome? ( dev-libs/glib:2
		>=gnome-base/gconf-2 )
	gtk? ( ${PYTHON_DEPS} )"
RDEPEND="${COMMON_DEPEND}
	gtk? ( >=dev-python/pygtk-2[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}] )"
DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-make-conditionals.patch
	epatch_user
	eautoreconf
}

src_configure() {
	python_export_best

	econf \
		--disable-silent-rules \
		$(use_enable nls) \
		--enable-randr \
		--enable-vidmode \
		--disable-wingdi \
		$(use_enable gnome gnome-clock) \
		$(use_enable geoclue) \
		$(use_enable gtk gui) \
		--disable-ubuntu
}

_impl_specific_src_install() {
	emake DESTDIR="${D}" pythondir="$(python_get_sitedir)" \
			-C src/gtk-redshift install
}

src_install() {
	default

	if use gtk; then
		python_foreach_impl _impl_specific_src_install
		python_replicate_script "${D}"/usr/bin/gtk-redshift
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
