# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VALA_MIN_API_VERSION=0.16
VALA_USE_DEPEND=vapigen
PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic multilib-minimal python-single-r1 vala

DESCRIPTION="Library to pass menu structure across DBus"
HOMEPAGE="https://launchpad.net/dbusmenu"
SRC_URI="https://launchpad.net/${PN/lib}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug doc gtk gtk3 +introspection test vala"

# Tests are currently known to be broken
# Additionally gtk2 tests require valgrind
RESTRICT="test"

RDEPEND="
	>=dev-libs/json-glib-0.13.4[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.32[${MULTILIB_USEDEP}]
	gtk? ( x11-libs/gtk+:2[introspection?,${MULTILIB_USEDEP}] )
	gtk3? ( >=x11-libs/gtk+-3.2:3[introspection?,${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1 )
	!<${CATEGORY}/${PN}-0.5.1-r200"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	test? ( dev-util/dbus-test-runner )
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	vala? ( $(vala_depend) )"

src_prepare() {
	if use vala; then
		vala_src_prepare
		export VALA_API_GEN="${VAPIGEN}"
	fi
	python_fix_shebang tools

	eapply_user
}

multilib_src_configure() {
	append-flags -Wno-error #414323

	local myconf=(
		--disable-gtk
		$(use_enable doc gtk-doc)
		--disable-static
		--disable-silent-rules
		--disable-dumper
		$(multilib_native_use_enable introspection)
		$(multilib_native_use_enable vala)
		$(use_enable debug massivedebugging)
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

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install

	local MULTIBUILD_VARIANTS=( "${GTK_VARIANTS[@]}" )
	[[ ${GTK_VARIANTS[@]} ]] && multibuild_foreach_variant \
		gtk_emake -j1 install DESTDIR="${D}"
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
