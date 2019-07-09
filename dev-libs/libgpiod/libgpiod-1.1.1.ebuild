# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib multilib-minimal

DESCRIPTION="C library and tools for interacting with the linux GPIO character device"
HOMEPAGE="https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/"
SRC_URI="https://mirrors.edge.kernel.org/pub/software/libs/libgpiod/libgpiod-1.1.1.tar.xz"

LICENSE="LGPL-2.1"
# Reflects the ABI of libgpiod.so
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="static-libs +tools"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable tools)
}

multilib_src_install() {
	default

	if ! use static-libs; then
		find "${D}" -name "*.a" -delete || die
	fi
	find "${D}" -name '*.la' -delete || die
}
