# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AVLinux Drumkits"
HOMEPAGE="http://x42-plugins.com/x42/x42-avldrums https://github.com/x42/avldrums.lv2"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/x42/avldrums.lv2.git"
	ROBTK_DIR="robtk/"
else
	ROBTK_PV="0.7.5"
	SRC_URI="
		https://github.com/x42/avldrums.lv2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/x42/robtk/archive/refs/tags/v${ROBTK_PV}.tar.gz -> robtk-${ROBTK_PV}.tar.gz
	"
	KEYWORDS="amd64"
	S="${WORKDIR}/avldrums.lv2-${PV}"
	ROBTK_DIR="${WORKDIR}/robtk-${ROBTK_PV}/"
fi

LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"

RDEPEND="dev-libs/glib
	media-libs/glu
	media-libs/lv2
	x11-libs/cairo[X]
	media-libs/libglvnd[X]
	x11-libs/libX11
	x11-libs/pango
"
DEPEND="${RDEPEND}"

src_compile() {
	emake STRIP="#" RW="${ROBTK_DIR}"
}

src_install() {
	emake RW="${ROBTK_DIR}" DESTDIR="${D}" PREFIX="/usr" LV2DIR="/usr/$(get_libdir)/lv2" install
}
