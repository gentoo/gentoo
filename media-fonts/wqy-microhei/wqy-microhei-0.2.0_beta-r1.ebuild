# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

MY_P="${P/_/-}"
DESCRIPTION="A droid derived Sans-Serif style CJK font"
HOMEPAGE="http://wqy.sourceforge.net/en/"
SRC_URI="mirror://sourceforge/wqy/${MY_P}.tar.gz
	http://dev.gentoo.org/~dlan/distfiles/${PN}.ttc.xd3"

LICENSE="Apache-2.0 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Only installs fonts
RESTRICT="strip binchecks"

S="${WORKDIR}/${PN}"
FONT_S="${S}"

FONT_SUFFIX="ttc"
DOCS="AUTHORS.txt ChangeLog.txt README.txt"

DEPEND="${DEPEND}
	dev-util/xdelta:3"

src_prepare() {
	xdelta3 -f -d -s "${S}"/wqy-microhei.ttc "${DISTDIR}"/wqy-microhei.ttc.xd3 "${S}"/wqy-microhei.ttc || die
}
