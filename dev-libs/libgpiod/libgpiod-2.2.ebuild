# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info

DESCRIPTION="C library and tools for interacting with the linux GPIO character device"
HOMEPAGE="https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/"
SRC_URI="https://mirrors.edge.kernel.org/pub/software/libs/libgpiod/${P}.tar.xz"

LICENSE="LGPL-2.1"
# Reflects the ABI of libgpiod.so
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="+tools cxx python test"
RESTRICT="!test? ( test )"

#  --enable-dbus #glib-2.80 masked
#  --enable-tests          enable libgpiod tests [default=no]
#  --enable-bindings-cxx   enable C++ bindings [default=no]
#  --enable-bindings-python
#  --enable-bindings-rust
#  --enable-bindings-glib
DEPEND="
	test? (
		>=dev-libs/glib-2.50
		>=sys-apps/kmod-18
		>=sys-apps/util-linux-2.33.1
		>=virtual/libudev-215
		cxx? ( <dev-cpp/catch-3.5:0 )
	)
"

pkg_setup() {
	CONFIG_CHECK="~GPIO_CDEV_V1"
	linux-info_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable tools)
		$(use_enable cxx bindings-cxx)
		$(use_enable test tests)
		$(use_enable python bindings-python)
		--enable-examples
		--disable-dbus
		--disable-profiling
		--disable-bindings-rust
		--disable-bindings-glib
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -type f -delete || die
	find "${D}" -name "*.a" -delete || die
}
