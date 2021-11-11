# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_PN="NanumGothicCoding"

DESCRIPTION="Korean monospace font distributed by Naver"
HOMEPAGE="https://github.com/naver/nanumfont"
SRC_URI="https://github.com/naver/${PN}/releases/download/VER${PV}/${MY_PN}-${PV}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip binchecks"

BDEPEND="app-arch/unzip"
S="${WORKDIR}"

FONT_SUFFIX="ttf"
