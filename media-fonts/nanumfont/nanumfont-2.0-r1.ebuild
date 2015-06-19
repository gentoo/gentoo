# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/nanumfont/nanumfont-2.0-r1.ebuild,v 1.2 2011/06/14 10:59:00 pva Exp $

EAPI=2
inherit font

MY_P="NanumGothicCoding-${PV}"
DESCRIPTION="Korean monospace font distributed by NHN"
HOMEPAGE="http://dev.naver.com/projects/nanumfont"
SRC_URI="http://dev.naver.com/frs/download.php/441/${MY_P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Only installs fonts
RESTRICT="strip binchecks"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"
FONT_S="${S}"

FONT_SUFFIX="ttf"

src_prepare() {
	# Rename names in cp949 encoding, bug #322041
	mkdir recode || die
	mv *-Bold.ttf recode/${PN}-Bold.ttf || die
	mv *.ttf recode/${PN}.ttf || die
	mv recode/* .
}
