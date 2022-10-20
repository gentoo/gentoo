# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="X11 fonts (meta package)"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="
	media-fonts/font-adobe-100dpi
	media-fonts/font-adobe-75dpi
	media-fonts/font-adobe-utopia-100dpi
	media-fonts/font-adobe-utopia-75dpi
	media-fonts/font-adobe-utopia-type1
	media-fonts/font-arabic-misc
	media-fonts/font-bh-100dpi
	media-fonts/font-bh-75dpi
	media-fonts/font-bh-lucidatypewriter-100dpi
	media-fonts/font-bh-lucidatypewriter-75dpi
	media-fonts/font-bitstream-100dpi
	media-fonts/font-bitstream-75dpi
	media-fonts/font-bitstream-speedo
	media-fonts/font-bitstream-type1
	media-fonts/font-cronyx-cyrillic
	media-fonts/font-cursor-misc
	media-fonts/font-daewoo-misc
	media-fonts/font-dec-misc
	media-fonts/font-ibm-type1
	media-fonts/font-isas-misc
	media-fonts/font-jis-misc
	media-fonts/font-micro-misc
	media-fonts/font-misc-cyrillic
	media-fonts/font-misc-ethiopic
	media-fonts/font-misc-meltho
	media-fonts/font-misc-misc
	media-fonts/font-mutt-misc
	media-fonts/font-schumacher-misc
	media-fonts/font-screen-cyrillic
	media-fonts/font-sony-misc
	media-fonts/font-sun-misc
	media-fonts/font-winitzki-cyrillic
	media-fonts/font-xfree86-type1
"

pkg_postinst() {
	optfeature "Bigelow & Holmes Luxi fonts (non-free)" \
		media-fonts/font-bh-ttf media-fonts/font-bh-type1
}
