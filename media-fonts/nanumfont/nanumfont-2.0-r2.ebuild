# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Korean monospace font distributed by NHN"
HOMEPAGE="https://developers.naver.com/projects/nanumfont"
SRC_URI="http://dev.naver.com/frs/download.php/441/NanumGothicCoding-${PV}.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# Only installs fonts
RESTRICT="strip binchecks"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"

src_prepare() {
	default
	# Rename names in cp949 encoding, bug #322041
	mkdir recode || die
	mv *-Bold.ttf recode/${PN}-Bold.ttf || die
	mv *.ttf recode/${PN}.ttf || die
	mv recode/* . || die
}
