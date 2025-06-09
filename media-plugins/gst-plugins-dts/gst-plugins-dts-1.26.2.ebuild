# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="DTS audio decoder plugin for Gstreamer"
KEYWORDS="~amd64 ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="+orc"

RDEPEND="
	>=media-libs/libdca-0.0.7[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.40[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-meson_fix_building-bad_tests_with_disabled_soundtouch.patch
)

multilib_src_configure() {
	local emesonargs=(
		-Dgpl=enabled
	)

	gstreamer_multilib_src_configure
}
