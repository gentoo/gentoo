# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
VALA_USE_DEPEND="vapigen"

inherit gnome2-utils vala meson python-r1 xdg-utils

DESCRIPTION="Cross-desktop libraries and common resources"
HOMEPAGE="https://github.com/linuxmint/xapp/"
LICENSE="GPL-3"

SRC_URI="https://github.com/linuxmint/xapp/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/xapp-${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"

SLOT="0"
IUSE="gtk-doc introspection static-libs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.44.0:2
	dev-libs/gobject-introspection:0=
	dev-libs/libdbusmenu[gtk3]
	gnome-base/libgnomekbd
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.22.0:2[introspection?]
	>=x11-libs/gtk+-3.16.0:3[introspection?]
	x11-libs/libxkbfile
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	$(vala_depend)
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=dev-util/intltool-0.40.6
	sys-devel/gettext

	gtk-doc? ( dev-util/gtk-doc )
"

src_prepare() {
	vala_src_prepare
	default

	# don't install distro specific tools
	sed -i "/subdir('scripts')/d" meson.build || die

	# Fix meson helpers
	python_setup
	python_fix_shebang meson-scripts
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc docs)
		-Dpy-overrides-dir="/pygobject"
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# copy pygobject files to each active python target
	# work-around for "py-overrides-dir" only supporting a single target
	install_pygobject_override() {
		PYTHON_GI_OVERRIDESDIR=$("${EPYTHON}" -c 'import gi;print(gi._overridesdir)' || die)
		einfo "gobject overrides directory: ${PYTHON_GI_OVERRIDESDIR}"
		mkdir -p "${ED}/${PYTHON_GI_OVERRIDESDIR}/" || die
		cp -r "${D}"/pygobject/* "${ED}/${PYTHON_GI_OVERRIDESDIR}/" || die
		python_optimize "${ED}/${PYTHON_GI_OVERRIDESDIR}/"
	}
	python_foreach_impl install_pygobject_override
	rm -r "${D}/pygobject" || die
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	gnome2_schemas_update
}
