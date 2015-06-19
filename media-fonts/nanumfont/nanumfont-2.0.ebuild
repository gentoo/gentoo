# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/nanumfont/nanumfont-2.0.ebuild,v 1.2 2009/11/14 16:09:21 maekke Exp $

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
