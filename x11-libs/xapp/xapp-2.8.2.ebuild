# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..12} )
VALA_USE_DEPEND="vapigen"

inherit gnome2-utils vala meson python-r1

DESCRIPTION="Cross-desktop libraries and common resources"
HOMEPAGE="https://github.com/linuxmint/xapp/"
LICENSE="LGPL-3 xfce? ( GPL-3 )"

SRC_URI="https://github.com/linuxmint/xapp/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv x86"

SLOT="0"
IUSE="gtk-doc introspection mate xfce"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	>=dev-libs/glib-2.44.0:2
	dev-libs/libdbusmenu[gtk3]
	gnome-base/libgnomekbd:=
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.22.0:2[introspection?]
	>=x11-libs/gtk+-3.22.0:3[introspection?]
	x11-libs/libxkbfile
	x11-libs/libX11
	x11-libs/pango
"
RDEPEND="
	${PYTHON_DEPS}
	${DEPEND}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
"
BDEPEND="
	${PYTHON_DEPS}
	$(vala_depend)
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-util/gdbus-codegen
	dev-util/glib-utils
	sys-apps/dbus
	sys-devel/gettext

	gtk-doc? (
		dev-util/gtk-doc
	)
"

PATCHES=(
	# Make desktop environment integrations optional
	# https://github.com/linuxmint/xapp/pull/176
	"${FILESDIR}"/${PN}-optional-de-options.patch
)

src_prepare() {
	vala_src_prepare
	default

	# don't install pastebin upload wrapper
	sed -iE "s/'(pastebin|upload-system-info)',//" scripts/meson.build || die

	# Fix meson helpers
	python_setup
	python_fix_shebang .
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc docs)
		$(meson_use mate)
		$(meson_use xfce)
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
		mkdir -p "${D}/${PYTHON_GI_OVERRIDESDIR}/" || die
		cp -r "${D}"/pygobject/* "${D}/${PYTHON_GI_OVERRIDESDIR}/" || die
		python_optimize "${D}/${PYTHON_GI_OVERRIDESDIR}/"
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
