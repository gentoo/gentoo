# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson linux-info

DESCRIPTION="C library and tools for interacting with the linux GPIO character device"
HOMEPAGE="https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/"
SRC_URI="https://mirrors.edge.kernel.org/pub/software/libs/libgpiod/${P}.tar.xz"

LICENSE="LGPL-2.1"
# Reflects the ABI of libgpiod.so
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="cxx dbus introspection glib python static-libs +tools test"
REQUIRED_USE="introspection? ( glib )"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dbus? (
		>=dev-libs/glib-2.80
		dev-libs/libgudev
	)
	glib? (
		>=dev-libs/glib-2.80
	)
	tools? (
		dev-libs/libedit
	)
"
RDEPEND="
	${COMMON_DEPEND}
	dbus? (
		sys-apps/dbus
	)
"
DEPEND="
	${COMMON_DEPEND}
	introspection? (
		dev-libs/gobject-introspection
	)
	test? (
		>=dev-libs/glib-2.80
		>=sys-apps/kmod-18
		>=sys-apps/util-linux-2.33.1
		>=virtual/libudev-215
		cxx? (
			<dev-cpp/catch-3.5:0
		)
	)
"
BDEPEND="
	sys-apps/help2man
	dbus? (
		>=dev-util/glib-utils-2.80
		>=dev-util/gdbus-codegen-2.80
	)
	glib? (
		>=dev-util/glib-utils-2.80
	)
	introspection? (
		dev-libs/gobject-introspection
	)
"

pkg_setup() {
	CONFIG_CHECK="~GPIO_CDEV_V1"
	linux-info_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_feature test tests)
		$(meson_feature tools)
		$(meson_feature tools gpioset-interactive)
		$(meson_feature cxx bindings-cxx)
		$(meson_feature python bindings-python)
		$(meson_feature dbus)
		$(meson_feature glib bindings-glib)
		$(meson_feature introspection)
		-Dexamples=enabled
		-Dbindings-rust=disabled
		-Dprofiling=false
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	# -Ddefault_library=shared is ignored
	if ! use static-libs; then
		find "${ED}" -name '*.a' -delete || die
	fi
}
