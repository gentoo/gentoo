# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font

DESCRIPTION="Google's font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlei18n/noto-fonts"

COMMIT="d7af81e614086435102cca95961b141b3530a027"
SRC_URI="https://github.com/googlei18n/noto-fonts/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~mips ppc ppc64 sparc x86"
IUSE="cjk"

RDEPEND="cjk? ( media-fonts/noto-cjk )"
RESTRICT="binchecks strip"

S="${WORKDIR}/${PN}-fonts-${COMMIT}"

FONT_SUFFIX="ttf"
FONT_CONF=(
	# From ArchLinux
	"${FILESDIR}/66-noto-serif.conf"
	"${FILESDIR}/66-noto-mono.conf"
	"${FILESDIR}/66-noto-sans.conf"
)

src_install() {
	# Don't install in separate subdirs
	FONT_S="${S}/unhinted/" font_src_install
	FONT_S="${S}/hinted/" font_src_install
}
