# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
VALA_USE_DEPEND="vapigen"

inherit autotools bash-completion-r1 gnome2-utils ltprune python-r1 vala virtualx

DESCRIPTION="Intelligent Input Bus for Linux / Unix OS"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="+X gconf +gtk +gtk2 +introspection +libnotify nls +python test vala wayland"
REQUIRED_USE="gtk2? ( gtk )
	libnotify? ( gtk )
	python? (
		${PYTHON_REQUIRED_USE}
		gtk
		introspection
	)
	test? ( gtk )
	vala? ( introspection )"

CDEPEND="app-text/iso-codes
	dev-libs/glib:2
	gnome-base/dconf
	gnome-base/librsvg:2
	sys-apps/dbus[X?]
	X? (
		x11-libs/libX11
		!gtk? ( x11-libs/gtk+:2 )
	)
	gconf? ( gnome-base/gconf:2 )
	gtk? (
		x11-libs/gtk+:3
		x11-libs/libX11
		x11-libs/libXi
		gtk2? ( x11-libs/gtk+:2 )
	)
	introspection? ( dev-libs/gobject-introspection )
	libnotify? ( x11-libs/libnotify )
	nls? ( virtual/libintl )
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)
	wayland? (
		dev-libs/wayland
		x11-libs/libxkbcommon
	)"
RDEPEND="${CDEPEND}
	python? (
		gtk? (
			x11-libs/gtk+:3[introspection]
		)
	)"
DEPEND="${CDEPEND}
	$(vala_depend)
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	vala_src_prepare --ignore-use
	# disable emoji
	touch \
		tools/main.vala \
		ui/gtk3/panel.vala
	if ! use libnotify; then
		touch ui/gtk3/panel.vala
	fi
	# for multiple Python implementations
	sed -i "s/^\(PYGOBJECT_DIR =\).*/\1/" bindings/Makefile.am
	# fix for parallel install
	sed -i \
		-e "/^py2_compile/,/^$/d" \
		-e "/^install-data-hook/,/^$/d" \
		bindings/pygobject/Makefile.am
	# require user interaction
	sed -i "/^TESTS += ibus-compose/d" src/tests/Makefile.am

	sed -i "/^bash_completion/d" tools/Makefile.am

	default
	eautoreconf
}

src_configure() {
	local python_conf=()
	if use python; then
		python_setup
		python_conf+=(
			$(use_enable gtk setup)
			--with-python=${EPYTHON}
		)
	else
		python_conf+=( --disable-setup )
	fi

	econf \
		$(use_enable X xim) \
		$(use_enable gconf) \
		$(use_enable gtk gtk3) \
		$(use_enable gtk ui) \
		$(use_enable gtk2) \
		$(use_enable introspection) \
		$(use_enable libnotify) \
		$(use_enable nls) \
		$(use_enable test tests) \
		$(use_enable vala) \
		$(use_enable wayland) \
		--disable-emoji-dict \
		"${python_conf[@]}"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	virtx emake -j1 check
}

src_install() {
	default
	prune_libtool_files --modules

	if use python; then
		python_install() {
			emake -C bindings/pygobject \
				pyoverridesdir="$(${EPYTHON} -c 'import gi; print(gi._overridesdir)')" \
				DESTDIR="${D}" \
				install
		}
		python_foreach_impl python_install
	fi

	keepdir /usr/share/ibus/engine

	newbashcomp tools/${PN}.bash ${PN}

	insinto /etc/X11/xinit/xinput.d
	newins xinput-${PN} ${PN}.conf
}

pkg_preinst() {
	use gconf && gnome2_gconf_savelist
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	use gconf && gnome2_gconf_install
	use gtk && gnome2_query_immodules_gtk3
	use gtk2 && gnome2_query_immodules_gtk2
	gnome2_icon_cache_update
	gnome2_schemas_update
	dconf update
}

pkg_postrm() {
	use gtk && gnome2_query_immodules_gtk3
	use gtk2 && gnome2_query_immodules_gtk2
	gnome2_icon_cache_update
	gnome2_schemas_update
}
