# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Music player with a waveform progress bar"
HOMEPAGE="https://nulloy.com"

inherit git-r3 xdg
EGIT_REPO_URI="https://github.com/nulloy/nulloy"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="skins"

BDEPEND="dev-qt/linguist-tools"

DEPEND="
	dev-qt/qtcore
	dev-qt/designer
	dev-qt/linguist
	dev-qt/qtscript
	dev-qt/qtx11extras
	media-libs/gstreamer
	media-libs/gst-plugins-base
	media-plugins/gst-plugins-meta
	media-libs/taglib
"
RDEPEND="${DEPEND}"

src_configure() {
	local myconfargs=(
		$(use skins || echo --no-skins)
		--no-update-check
		--prefix "${ED}/usr"
		--libdir $(get_libdir)
	)

	./configure ${myconfargs[@]} || die
}
