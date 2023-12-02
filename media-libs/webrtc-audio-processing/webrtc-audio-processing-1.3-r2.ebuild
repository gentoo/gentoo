# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson-multilib

DESCRIPTION="AudioProcessing library from the webrtc.org codebase"
HOMEPAGE="https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing/"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="1"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux"
IUSE="cpu_flags_arm_neon"

RDEPEND="dev-cpp/abseil-cpp:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-1.3-Add-generic-byte-order-and-pointer-size-detection.patch"
	"${FILESDIR}/${PN}-1.3-big-endian-support.patch"
)

DOCS=( AUTHORS NEWS README.md )

multilib_src_configure() {
	local emesonargs=(
		-Dneon=$(usex cpu_flags_arm_neon yes no)
	)
	meson_src_configure
}
