# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-ugly

inherit gstreamer-meson

DESCRIPTION="ATSC A/52 audio decoder plugin for GStreamer"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~riscv ~sparc x86"
IUSE="+orc"

RDEPEND="
	>=media-libs/a52dec-0.7.4-r6[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local emesonargs=(
		-Dgpl=enabled
	)

	gstreamer_multilib_src_configure
}
