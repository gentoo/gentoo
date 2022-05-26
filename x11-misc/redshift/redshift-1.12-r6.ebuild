# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit flag-o-matic systemd autotools xdg-utils python-r1

DESCRIPTION="A screen color temperature adjusting software"
HOMEPAGE="http://jonls.dk/redshift/"
SRC_URI="https://github.com/jonls/redshift/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="appindicator geoclue gtk nls"

COMMON_DEPEND=">=x11-libs/libX11-1.4
	x11-libs/libXxf86vm
	x11-libs/libxcb
	x11-libs/libdrm
	appindicator? ( dev-libs/libappindicator:3[introspection] )
	geoclue? ( app-misc/geoclue:2.0 dev-libs/glib:2 )
	gtk? ( ${PYTHON_DEPS} )"
RDEPEND="${COMMON_DEPEND}
	gtk? ( dev-python/pygobject[${PYTHON_USEDEP}]
		x11-libs/gtk+:3[introspection]
		dev-python/pyxdg[${PYTHON_USEDEP}] )"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	nls? ( sys-devel/gettext )
"
REQUIRED_USE="gtk? ( ${PYTHON_REQUIRED_USE} )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use gtk && python_setup

	# Fix compile for Clang (bug #732438)
	append-cflags -fPIE

	econf \
		$(use_enable nls) \
		--enable-drm \
		--enable-randr \
		--enable-vidmode \
		--disable-wingdi \
		\
		--disable-corelocation \
		$(use_enable geoclue geoclue2) \
		\
		$(use_enable gtk gui) \
		--with-systemduserunitdir="$(systemd_get_userunitdir)" \
		--enable-apparmor \
		--disable-quartz \
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

		python_foreach_impl python_optimize

		# https://bugs.gentoo.org/784281
		mv "${D}"/usr/share/{appdata,metainfo}/ || die
	fi
}

pkg_postinst() {
	use gtk && xdg_icon_cache_update
}

pkg_postrm() {
	use gtk && xdg_icon_cache_update
}
