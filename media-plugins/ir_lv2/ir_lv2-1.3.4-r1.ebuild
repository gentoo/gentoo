# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eapi9-ver toolchain-funcs

DESCRIPTION="LV2 convolver plugin especially for creating reverb effects"
HOMEPAGE="https://tomszilagyi.github.io/plugins/ir.lv2/"
SRC_URI="https://github.com/tomszilagyi/ir.lv2/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN/_/.}-${PV}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="tools"

RDEPEND="media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/lv2
	>=media-libs/zita-convolver-3:=
	>=x11-libs/gtk+-2.16:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-respect-flags.patch
	"${FILESDIR}"/${P}-lv2.patch
)

DOCS=( README.md sshot.png ChangeLog )

src_compile() {
	tc-export CC CXX PKG_CONFIG
	emake
	use tools && emake convert4chan
}

src_install() {
	emake INSTDIR="${D}/usr/$(get_libdir)/lv2" install
	use tools && newbin convert4chan ir_convert4chan
	einstalldocs
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] || ver_replacing -lt 1.3.0; then
		elog "This version works with automation at the expense of introducing extra buffering."
		elog "For zero latency use 1.2* version instead."
	fi
}
