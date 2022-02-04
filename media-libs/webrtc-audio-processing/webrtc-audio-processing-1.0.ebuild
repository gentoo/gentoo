# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="AudioProcessing library from the webrtc.org codebase"
HOMEPAGE="https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing/"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="1"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="cpu_flags_arm_neon"

RDEPEND="dev-cpp/abseil-cpp[-cxx17(+)]" # TODO: resolve cxx14 requirement
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PV}-abseil-cmake.patch
)

DOCS=( AUTHORS NEWS README.md )

src_configure() {
	local emesonargs=(
		-Dneon=$(usex cpu_flags_arm_neon yes no)
	)
	meson_src_configure
}
