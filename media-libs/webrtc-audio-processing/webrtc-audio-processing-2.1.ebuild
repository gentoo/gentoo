# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="AudioProcessing library from the webrtc.org codebase"
HOMEPAGE="https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing/"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="cpu_flags_arm_neon cpu_flags_x86_sse"

RDEPEND=">=dev-cpp/abseil-cpp-20240722:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# Backport
	"${FILESDIR}/${P}-gcc15-cstdint.patch"
	# Unmerged
	"${FILESDIR}/${PN}-2.1-abseil-cpp-202508.patch"
)

DOCS=( AUTHORS NEWS README.md )

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature cpu_flags_arm_neon neon)
		$(meson_use cpu_flags_x86_sse inline-sse)
	)
	meson_src_configure
}
