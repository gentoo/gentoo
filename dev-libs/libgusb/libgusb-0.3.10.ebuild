# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="xml(+)"

inherit meson-multilib python-any-r1 vala

DESCRIPTION="GObject wrapper for libusb"
HOMEPAGE="https://github.com/hughsie/libgusb"
SRC_URI="https://people.freedesktop.org/~hughsient/releases/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

IUSE="gtk-doc +introspection static-libs test +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.44.0:2[${MULTILIB_USEDEP}]
	virtual/libusb:1[udev,${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	sys-apps/hwdata
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_any_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
	gtk-doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/docbook-xml-dtd:4.4
		dev-util/gtk-doc
	)
	vala? ( $(vala_depend) )
	virtual/pkgconfig
"

RESTRICT="!test? ( test )"

python_check_deps() {
	has_version -b "dev-python/setuptools[${PYTHON_USEDEP}]"
}

src_prepare() {
	use vala && vala_src_prepare
	default
}

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		$(meson_use test tests)
		$(meson_native_use_bool vala vapi)
		-Dusb_ids="${EPREFIX}"/usr/share/hwdata/usb.ids
		$(meson_native_use_bool gtk-doc docs)
		$(meson_native_use_bool introspection)

	)
	meson_src_configure
}
