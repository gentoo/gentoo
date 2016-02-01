# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"
# Vapigen is needed for the vala binding
# Valac is needed when building from git for the engine
UPSTREAM_VER=

inherit autotools bash-completion-r1 eutils gnome2-utils multilib python-single-r1 readme.gentoo vala virtualx

DESCRIPTION="Intelligent Input Bus for Linux / Unix OS"
HOMEPAGE="https://github.com/ibus/ibus/wiki"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="deprecated gconf gtk +gtk3 +introspection nls +python test vala wayland +X"
REQUIRED_USE="
	|| ( gtk gtk3 X )
	deprecated? ( python )
	vala? ( introspection )
	python? (
		${PYTHON_REQUIRED_USE}
		|| ( deprecated ( gtk3 introspection ) ) )" #342903

[[ -n ${UPSTREAM_VER} ]] && \
	UPSTRAM_PATCHSET_URI="http://dev.gentoo.org/~dlan/distfiles/${P}-upstream-patches-${UPSTREAM_VER}.tar.xz"

SRC_URI="https://github.com/ibus/ibus/releases/download/${PV}/${P}.tar.gz
	${UPSTRAM_PATCHSET_URI}"

COMMON_DEPEND="
	>=dev-libs/glib-2.26:2
	gnome-base/librsvg:2
	sys-apps/dbus[X?]
	app-text/iso-codes
	>=gnome-base/dconf-0.13.4
	x11-libs/libnotify
	gconf? ( >=gnome-base/gconf-2.12:2 )
	gtk? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	python? ( ${PYTHON_DEPS} )
	X? (
		x11-libs/libX11
		x11-libs/gtk+:2 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.8 )
	nls? ( virtual/libintl )
	wayland? ( dev-libs/wayland )"
RDEPEND="${COMMON_DEPEND}
	x11-apps/setxkbmap
	python? (
		dev-python/pyxdg
		deprecated? (
			>=dev-python/dbus-python-0.83
			dev-python/pygobject:2
			dev-python/pygtk:2 )
		gtk3? (
			dev-python/pygobject:3
			x11-libs/gdk-pixbuf:2[introspection]
			x11-libs/pango[introspection]
			x11-libs/gtk+:3[introspection] )
	)"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5.8.1
	dev-util/gtk-doc-am
	dev-util/intltool
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.16.1 )
	vala? ( $(vala_depend) )"

# stress test in bus/ fails
# IBUS-CRITICAL **: bus_test_client_init: assertion `ibus_bus_is_connected (_bus)' failed
RESTRICT="test"

DOCS="AUTHORS ChangeLog NEWS README"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="To use ibus, you should:
1. Get input engines from sunrise overlay.
Run \"emerge -s ibus-\" in your favorite terminal
for a list of packages we already have.

2. Setup ibus:
$ ibus-setup

3. Set the following in your user startup scripts
such as .xinitrc, .xsession or .xprofile:

export XMODIFIERS=\"@im=ibus\"
export GTK_IM_MODULE=\"ibus\"
export QT_IM_MODULE=\"xim\"
ibus-daemon -d -x
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Upstream's patchset
	if [[ -n ${UPSTREAM_VER} ]]; then
		EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" \
		EPATCH_OPTS="-p1" \
			epatch "${WORKDIR}"/patches-upstream
	fi

	# We run "dconf update" in pkg_postinst/postrm to avoid sandbox violations
	sed -e 's/dconf update/:/' \
		-i data/dconf/Makefile.{am,in} || die
	use vala && vala_src_prepare

	eautoreconf
}

src_configure() {
	local python_conf
	if use python; then
		python_conf="PYTHON=${PYTHON}
			$(use_enable deprecated python-library)
			$(use_enable gtk3 setup)"
	else
		python_conf="--disable-python-library --disable-setup"
	fi
	econf \
		--enable-dconf \
		$(use_enable introspection) \
		$(use_enable gconf) \
		$(use_enable gtk gtk2) \
		$(use_enable gtk xim) \
		$(use_enable gtk3) \
		$(use_enable gtk3 ui) \
		$(use_enable nls) \
		$(use_enable test tests) \
		$(use_enable X xim) \
		$(use_enable vala) \
		$(use_enable wayland) \
		${python_conf}
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die
}

src_install() {
	default

	prune_libtool_files --all

	mv "${ED}"/usr/share/bash-completion/completions/ibus.bash "${T}"
	rm -rf "${ED}"/usr/share/bash-completion || die
	newbashcomp "${T}"/ibus.bash ${PN}
	insinto /etc/X11/xinit/xinput.d
	newins xinput-ibus ibus.conf

	keepdir /usr/share/ibus/{engine,icons} #289547

	use deprecated && python_optimize
	use python && use gtk3 && python_optimize

	readme.gentoo_create_doc
}

pkg_preinst() {
	use gconf && gnome2_gconf_savelist
	gnome2_schemas_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	use gconf && gnome2_gconf_install
	use gtk && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
	gnome2_schemas_update
	gnome2_icon_cache_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	use gtk && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
	use gconf && gnome2_schemas_update
	gnome2_icon_cache_update
}
