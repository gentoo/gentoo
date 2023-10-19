# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson-multilib

DESCRIPTION="AudioProcessing library from the webrtc.org codebase"
HOMEPAGE="https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing/"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="1"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="cpu_flags_arm_neon"

RDEPEND="dev-cpp/abseil-cpp:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
)

DOCS=( AUTHORS NEWS README.md )

multilib_src_configure() {
	local emesonargs=(
		-Dneon=$(usex cpu_flags_arm_neon yes no)
	)
	meson_src_configure
}
