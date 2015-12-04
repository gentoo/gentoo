# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VALA_MIN_API_VERSION=0.16
VALA_USE_DEPEND=vapigen
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils flag-o-matic multilib-minimal python-single-r1 vala

DESCRIPTION="Library to pass menu structure across DBus"
HOMEPAGE="https://launchpad.net/dbusmenu"
MY_PV="${PV/_pre/+15.04.}.2"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug gtk gtk3 +introspection json"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

RDEPEND="
	>=dev-libs/dbus-glib-0.100[${MULTILIB_USEDEP}]
	>=dev-libs/json-glib-0.13.4[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.32[${MULTILIB_USEDEP}]
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	gtk? ( x11-libs/gtk+:2[introspection?,${MULTILIB_USEDEP}] )
	gtk3? ( >=x11-libs/gtk+-3.2:3[introspection?,${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1 )
	!<${CATEGORY}/${PN}-0.5.1-r200"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	introspection? ( $(vala_depend) )"

src_prepare() {
	if use introspection; then
		vala_src_prepare
		export VALA_API_GEN="${VAPIGEN}"
	fi
	python_fix_shebang tools

	epatch_user

	eautoreconf
}

multilib_src_configure() {
	append-flags -Wno-error #414323

	local myconf=(
		--disable-gtk
		--disable-static
		--disable-silent-rules
		--disable-scrollkeeper
		$(use_enable json tests)
		--disable-dumper
		$(multilib_native_use_enable introspection)
		$(multilib_native_use_enable introspection vala)
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

src_test() { :; } #440192

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
