# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font

DESCRIPTION="Google's CJK font family"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlei18n/noto-cjk"

COMMIT="be6c059ac1587e556e2412b27f5155c8eb3ddbe6"
SRC_URI="https://github.com/googlei18n/noto-cjk/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~mips ppc ppc64 sparc x86"
IUSE=""

RESTRICT="binchecks strip"

S="${WORKDIR}/${PN}-${COMMIT}"

FONT_S="${S}"
FONT_SUFFIX="ttc"
FONT_CONF=(
	# From ArchLinux
	"${FILESDIR}/70-noto-cjk.conf"
)
