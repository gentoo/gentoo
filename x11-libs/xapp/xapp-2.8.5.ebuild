# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
VALA_USE_DEPEND="vapigen"

inherit gnome2-utils vala meson python-r1

DESCRIPTION="Cross-desktop libraries and common resources"
HOMEPAGE="https://github.com/linuxmint/xapp/"

SRC_URI="https://github.com/linuxmint/xapp/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3 xfce? ( GPL-3 )"
SLOT="0"

KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="gtk-doc introspection mate vala xfce"
REQUIRED_USE="${PYTHON_REQUIRED_USE} vala? ( introspection )"

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

	introspection? (
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/gdbus-codegen
	dev-util/glib-utils
	sys-apps/dbus
	sys-devel/gettext

	gtk-doc? (
		dev-util/gtk-doc
	)

	introspection? (
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)

	vala? (
		$(vala_depend)
	)
"

PATCHES=(
	# Make introspection/vala optional
	# https://github.com/linuxmint/xapp/pull/184
	"${FILESDIR}"/${PN}-2.8.4-optional-introspection.patch

	# Allow multiple gobject installation targets
	# https://github.com/linuxmint/xapp/pull/183
	"${FILESDIR}"/${PN}-2.8.4-multiple-python-targets.patch

	# Don't install pastebin upload wrapper
	"${FILESDIR}"/0001-don-t-install-pastebin-upload-wrapper.patch
)

src_prepare() {
	use vala && vala_setup

	default

	# Fix meson helpers
	python_setup
	python_fix_shebang .
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc docs)
		$(meson_use introspection)
		$(meson_use mate)
		$(meson_use vala vapi)
		$(meson_use xfce)
	)

	if use introspection; then
		local xapp_python_targets=()

		get_xapp_python_targets() {
			xapp_python_targets+=("${EPYTHON}")
		}
		python_foreach_impl get_xapp_python_targets

		emesonargs+=(
			-Dpython_target="$(echo "${xapp_python_targets[@]}" | tr ' ' ,)"
		)
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	if use introspection; then
		python_foreach_impl python_optimize
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	gnome2_schemas_update
}
