# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="xml(+)"
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/hughsie.asc
inherit meson-multilib python-any-r1 vala verify-sig

DESCRIPTION="GObject wrapper for libusb"
HOMEPAGE="https://github.com/hughsie/libgusb"
SRC_URI="
	https://github.com/hughsie/libgusb/releases/download/${PV}/${P}.tar.xz
	verify-sig? ( https://github.com/hughsie/libgusb/releases/download/${PV}/${P}.tar.xz.asc )
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

IUSE="gtk-doc +introspection test +vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.44.0:2[${MULTILIB_USEDEP}]
	virtual/libusb:1[udev,${MULTILIB_USEDEP}]
	>=dev-libs/json-glib-1.1.1[${MULTILIB_USEDEP},introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
	sys-apps/hwdata
"
DEPEND="${RDEPEND}
	test? ( >=dev-util/umockdev-0.17.7[${MULTILIB_USEDEP}] )"
BDEPEND="
	$(python_gen_any_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
	gtk-doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
	verify-sig? ( sec-keys/openpgp-keys-hughsie )
	virtual/pkgconfig
"

python_check_deps() {
	python_has_version "dev-python/setuptools[${PYTHON_USEDEP}]"
}

src_prepare() {
	default
	use vala && vala_setup
}

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=shared
		$(meson_use test tests)
		$(meson_native_use_bool vala vapi)
		-Dusb_ids="${EPREFIX}"/usr/share/hwdata/usb.ids
		$(meson_native_use_bool gtk-doc docs)
		$(meson_native_use_bool introspection)
		$(meson_feature test umockdev)

	)
	meson_src_configure
}

multilib_src_install_all() {
	einstalldocs

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/ || die
		mv "${ED}"/usr/share/{doc,gtk-doc}/libgusb || die
	fi
}
