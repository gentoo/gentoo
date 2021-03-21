# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="EGL External Platform interface"
HOMEPAGE="https://github.com/NVIDIA/eglexternalplatform"
SRC_URI="https://github.com/NVIDIA/eglexternalplatform/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	sed -i "/^inc/s@=@=${EPREFIX}@" eglexternalplatform.pc || die
}

src_install() {
	insinto /usr/$(get_libdir)/pkgconfig
	doins eglexternalplatform.pc

	insinto /usr/include/EGL
	doins interface/*.h

	einstalldocs

	docinto examples
	dodoc samples/*.c
}
