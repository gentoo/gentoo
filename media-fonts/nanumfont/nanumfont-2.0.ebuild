# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font

MY_P="NanumGothicCoding-${PV}"
DESCRIPTION="Korean monospace font distributed by NHN"
HOMEPAGE="http://dev.naver.com/projects/nanumfont"
SRC_URI="http://dev.naver.com/frs/download.php/441/${MY_P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# Only installs fonts
RESTRICT="strip binchecks"

S="${WORKDIR}"
FONT_S="${S}"

FONT_SUFFIX="ttf"
