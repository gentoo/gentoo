# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font font-ebdftopcf

DESCRIPTION="Monospace bitmap font, primarily aimed at programmers"
HOMEPAGE="https://www.dcmembers.com/jibsen/download/61/"
SRC_URI="https://www.donationcoder.com/forum/index.php?action=dlattach;topic=36049.0;attach=78562 -> ${P}.zip"
S="${WORKDIR}/BDF/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="strip binchecks"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="pcf.gz"

src_compile() {
	font-ebdftopcf_src_compile
}
