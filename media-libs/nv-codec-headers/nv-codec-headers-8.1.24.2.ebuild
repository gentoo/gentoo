# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="FFmpeg version of headers required to interface with Nvidias codec APIs"
HOMEPAGE="https://git.videolan.org/?p=ffmpeg/nv-codec-headers.git"
SRC_URI="https://github.com/FFmpeg/nv-codec-headers/releases/download/n${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=x11-drivers/nvidia-drivers-390.25[${MULTILIB_USEDEP}]
"

S="${WORKDIR}/${PN}-n${PV}"

src_prepare() {
	multilib_copy_sources
	default
}

multilib_src_compile() {
	emake PREFIX="${EPREFIX}/usr" LIBDIR="$(get_libdir)"
}

multilib_src_install() {
	emake PREFIX="${EPREFIX}/usr" LIBDIR="$(get_libdir)" DESTDIR="${D}" install
}
