# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font font-ebdftopcf

DESCRIPTION="A monospace bitmap font, primarily aimed at programmers"
HOMEPAGE="http://www.donationcoder.com/Software/Jibz/Dina/index.html"
SRC_URI="http://www.donationcoder.com/forum/index.php?action=dlattach;topic=36049.0;attach=78562 -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}/BDF/
FONT_S=${S}/
FONT_SUFFIX="pcf.gz"
RESTRICT="strip binchecks"

src_compile() {
	font-ebdftopcf_src_compile
}
