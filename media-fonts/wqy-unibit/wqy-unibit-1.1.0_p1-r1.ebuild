# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="WenQuanYi Unibit CJK font"
HOMEPAGE="http://wenq.org/wqy2/index.cgi https://sourceforge.net/projects/wqy/"
SRC_URI="mirror://sourceforge/wqy/${PN}-bdf-${PV/_p/-}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

# Only installs fonts
RESTRICT="strip binchecks"

BDEPEND="media-gfx/ebdftopcf"

DOCS=( AUTHORS ChangeLog README )

FONT_SUFFIX="pcf.gz"

src_prepare() {
	default
	sed -i -e "s|$range=shift(ARGV);|$range=shift(@ARGV);|g" bdfmerge.pl || die
}

src_compile() {
	emake
	gzip -9 wqy-unibit.pcf || die
}
