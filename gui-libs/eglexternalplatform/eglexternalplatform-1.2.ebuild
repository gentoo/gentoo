# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="EGL External Platform interface"
HOMEPAGE="https://github.com/NVIDIA/eglexternalplatform/"
SRC_URI="
	https://github.com/NVIDIA/eglexternalplatform/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_install() {
	meson_src_install

	# header-only and we need it found for both 32bit and 64bit
	mv -- "${ED}"/usr/{$(get_libdir),share}/pkgconfig || die
}
