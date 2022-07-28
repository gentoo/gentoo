# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod multilib-minimal

DESCRIPTION="C library and tools for interacting with the linux GPIO character device"
HOMEPAGE="https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/"
SRC_URI="https://mirrors.edge.kernel.org/pub/software/libs/libgpiod/${P}.tar.xz"

LICENSE="LGPL-2.1"
# Reflects the ABI of libgpiod.so
SLOT="0/2"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv x86"
IUSE="static-libs +tools cxx python test"
RESTRICT="!test? ( test )"

#  --enable-tests          enable libgpiod tests [default=no]
#  --enable-bindings-cxx   enable C++ bindings [default=no]
#  --enable-bindings-python

pkg_setup() {
	CONFIG_CHECK="GPIO_CDEV_V1"
	linux-mod_pkg_setup
}

multilib_src_configure() {
	local myconf=(
		$(use_enable tools)
		$(use_enable cxx bindings-cxx)
		$(use_enable test tests)
		$(multilib_native_use_enable python bindings-python)
	)

	if ! multilib_is_native_abi; then
		myconf+=(
			--disable-tools
		)
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	default

	find "${D}" -name '*.la' -type f -delete || die

	if ! use static-libs; then
		find "${D}" -name "*.a" -delete || die
	fi
}
