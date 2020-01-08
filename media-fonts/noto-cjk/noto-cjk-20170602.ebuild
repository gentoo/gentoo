# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font

DESCRIPTION="Google's CJK font family"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlei18n/noto-cjk"

COMMIT="32a5844539f2e348ed36b44e990f9b06d7fb89fe"
SRC_URI="https://github.com/googlei18n/noto-cjk/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~mips ppc ppc64 sparc x86"
IUSE=""

RESTRICT="binchecks strip"

S="${WORKDIR}/${PN}-${COMMIT}"

FONT_S="${S}"
FONT_SUFFIX="ttc otf"
FONT_CONF=(
	# From ArchLinux
	"${FILESDIR}/70-noto-cjk.conf"
)
