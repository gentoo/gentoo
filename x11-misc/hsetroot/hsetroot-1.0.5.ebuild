# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tool which allows you to compose wallpapers ('root pixmaps') for X"
HOMEPAGE="https://github.com/himdel/hsetroot/"
SRC_URI="https://github.com/himdel/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~riscv x86"

RDEPEND=">=media-libs/imlib2-1.0.6.2003[X]
	x11-libs/libX11
	x11-libs/libXinerama"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.5-XOpenDisplay.patch
)

src_compile() {
	# Avoid the Makefile that replaced autotools
	tc-export CC PKG_CONFIG
	local tgt hsr_comp_args
	for tgt in ${PN} hsr-outputs; do
		hsr_comp_args=(
			${CFLAGS}
			$("${PKG_CONFIG}" --cflags x11 imlib2 xinerama)
			${LDFLAGS}
			${tgt}.c
			$("${PKG_CONFIG}" --libs x11 imlib2 xinerama)
			-o ${tgt}
		)
		echo ${hsr_comp_args[@]}
		"${CC}" ${hsr_comp_args[@]} || die
	done

}

src_install() {
	dobin ${PN} hsr-outputs
	einstalldocs
}
