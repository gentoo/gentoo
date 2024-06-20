# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit flag-o-matic meson python-any-r1 vala virtualx

DESCRIPTION="Flatpak portal library"
HOMEPAGE="https://github.com/flatpak/libportal"
SRC_URI="https://github.com/flatpak/libportal/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-3"
SLOT="0/1-1-1-1" # soname of libportal{,-gtk3,-gtk4,-qt5}.so
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk gtk-doc +introspection qt5 test +vala wayland X"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

RDEPEND="
	>=dev-libs/glib-2.58:2
	introspection? ( dev-libs/gobject-introspection:= )
	gtk? (
		>=x11-libs/gtk+-3.24.41-r1:3[X?,wayland?]
		>=gui-libs/gtk-4.12.5-r2:4[X?,wayland?]
	)
	qt5? (
		dev-qt/qtcore:=
		dev-qt/qtgui:=
		dev-qt/qtx11extras:=
		dev-qt/qtwidgets:=
	)
"
DEPEND="${RDEPEND}
	qt5? (
		test? ( dev-qt/qttest:= )
	)
"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
	qt5? (
		test? ( dev-qt/linguist-tools )
	)
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/dbus-python[${PYTHON_USEDEP}]
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
	)
	vala? ( $(vala_depend) )
"

python_check_deps() {
	python_has_version \
		"dev-python/pytest[${PYTHON_USEDEP}]" \
		"dev-python/dbus-python[${PYTHON_USEDEP}]" \
		"dev-python/python-dbusmock[${PYTHON_USEDEP}]"
}

pkg_setup() {
	if use test; then
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	default
	vala_setup
}

src_configure() {
	# defang automagic dependencies
	use wayland || append-cflags -DGENTOO_GTK_HIDE_WAYLAND
	use X || append-cflags -DGENTOO_GTK_HIDE_X11

	local emesonargs=(
		$(meson_feature gtk backend-gtk3)
		$(meson_feature gtk backend-gtk4)
		$(meson_feature qt5 backend-qt5)
		-Dportal-tests=false
		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc docs)
		$(meson_use test tests)
	)
	meson_src_configure
}

src_test() {
	# Tests only exist for Qt5
	if use qt5; then
		virtx meson_src_test
	else
		# run meson_src_test to notice if tests are added
		meson_src_test
	fi
}

src_install() {
	meson_src_install

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/${PN}-1 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
