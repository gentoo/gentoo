# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit font

MY_P="${PN}-bdf-${PV/_p/-}"
DESCRIPTION="WenQuanYi Unibit CJK font"
HOMEPAGE="http://wenq.org/enindex.cgi"
SRC_URI="mirror://sourceforge/wqy/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="media-gfx/ebdftopcf
	sys-apps/sed"
RDEPEND=""

S="${WORKDIR}/${PN}"
FONT_S="${S}"
FONT_SUFFIX="pcf.gz"
DOCS="AUTHORS ChangeLog README"

# Only installs fonts
RESTRICT="strip binchecks"

src_prepare() {
	sed -i -e "s|$range=shift(ARGV);|$range=shift(@ARGV);|g"  \
		bdfmerge.pl || die
}

src_compile() {
	emake || die
	gzip -9 wqy-unibit.pcf || die
}
