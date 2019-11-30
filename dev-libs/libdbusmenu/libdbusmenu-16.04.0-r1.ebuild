# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.16
VALA_USE_DEPEND=vapigen
VIRTUALX_REQUIRED=manual

inherit autotools flag-o-matic multilib-minimal vala virtualx xdg-utils

DESCRIPTION="Library to pass menu structure across DBus"
HOMEPAGE="https://launchpad.net/libdbusmenu"
SRC_URI="https://launchpad.net/${PN/lib}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="debug gtk gtk3 +introspection test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/dbus-glib-0.100[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.35.4[${MULTILIB_USEDEP}]
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	gtk? ( x11-libs/gtk+:2[introspection?,${MULTILIB_USEDEP}] )
	gtk3? ( >=x11-libs/gtk+-3.2:3[introspection?,${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1 )"
# tests also have optional dep on valgrind which we do not enforce
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	dev-util/glib-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	introspection? ( $(vala_depend) )
	test? (
		>=dev-libs/json-glib-0.13.4[${MULTILIB_USEDEP}]
		>=dev-util/dbus-test-runner-15.04.0_p100
		gtk? ( ${VIRTUALX_DEPEND} )
		gtk3? ( ${VIRTUALX_DEPEND} )
	)"

pkg_setup() {
	xdg_environment_reset
}

src_prepare() {
	if use introspection; then
		vala_src_prepare
		export VALA_API_GEN="${VAPIGEN}"
	fi

	eapply "${FILESDIR}/${P}-configure-fix.patch"
	eapply "${FILESDIR}/${P}-werror.patch"
	eapply_user
	eautoreconf
}

multilib_src_configure() {
	append-flags -Wno-error #414323

	local myconf=(
		--cache-file="${BUILD_DIR}"/config.cache
		--disable-gtk
		--disable-static
		# dumper extra tool is only for GTK+-2.x
		--disable-dumper
		$(multilib_native_use_enable introspection)
		$(multilib_native_use_enable introspection vala)
		$(use_enable debug massivedebugging)
		$(use_enable test tests)
	)
	local ECONF_SOURCE=${S}
	econf "${myconf[@]}"

	GTK_VARIANTS=( $(usex gtk 2 '') $(usex gtk3 3 '') )
	local MULTIBUILD_VARIANTS=( "${GTK_VARIANTS[@]}" )
	local top_builddir=${BUILD_DIR}

	gtk_configure() {
		local gtkconf=(
			"${myconf[@]}"
			--enable-gtk
			--with-gtk="${MULTIBUILD_VARIANT}"
		)
		mkdir -p "${BUILD_DIR}" || die
		cd "${BUILD_DIR}" || die
		econf "${gtkconf[@]}"

		rm -r libdbusmenu-glib || die
		ln -s "${top_builddir}"/libdbusmenu-glib libdbusmenu-glib || die
	}
	[[ ${GTK_VARIANTS[@]} ]] && multibuild_foreach_variant gtk_configure
}

gtk_emake() {
	emake -C "${BUILD_DIR}"/libdbusmenu-gtk "${@}"
	multilib_is_native_abi && \
		emake -C "${BUILD_DIR}"/docs/libdbusmenu-gtk "${@}"
}

multilib_src_compile() {
	emake

	local MULTIBUILD_VARIANTS=( "${GTK_VARIANTS[@]}" )
	[[ ${GTK_VARIANTS[@]} ]] && multibuild_foreach_variant \
		gtk_emake
}

multilib_src_test() {
	emake check

	gtk_test() {
		# please keep the list of GTK+ tests up-to-date
		emake -C "${BUILD_DIR}"/tests check \
			TESTS="test-gtk-objects-test test-gtk-label
				test-gtk-shortcut test-gtk-reorder test-gtk-remove"
	}
	local MULTIBUILD_VARIANTS=( "${GTK_VARIANTS[@]}" )
	[[ ${GTK_VARIANTS[@]} ]] && virtx multibuild_foreach_variant \
		gtk_test
}

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install

	local MULTIBUILD_VARIANTS=( "${GTK_VARIANTS[@]}" )
	[[ ${GTK_VARIANTS[@]} ]] && multibuild_foreach_variant \
		gtk_emake -j1 install DESTDIR="${D}"
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}

pkg_preinst() {
	# kill old symlinks that Portage will preserve and break install
	if [[ -L ${EROOT}/usr/share/gtk-doc/html/libdbusmenu-glib ]]; then
		rm -v "${EROOT}/usr/share/gtk-doc/html/libdbusmenu-glib" || die
	fi
	if [[ -L ${EROOT}/usr/share/gtk-doc/html/libdbusmenu-gtk ]]; then
		rm -v "${EROOT}/usr/share/gtk-doc/html/libdbusmenu-gtk" || die
	fi
}
