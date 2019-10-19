# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_P="EzraSIL${PV//./}"

DESCRIPTION="SIL Ezra - Unicode Opentype fonts for Biblical Hebrew"
HOMEPAGE="http://scripts.sil.org/EzraSIL_Home"
SRC_URI="mirror://gentoo/${MY_P}.zip"

LICENSE="MIT OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~ppc s390 sh sparc x86"
IUSE="doc"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/EzraSIL${PV}"

DOCS="OFL-FAQ.txt"
FONT_S="${S}"
FONT_SUFFIX="ttf"

src_install() {
	font_src_install
	use doc && dodoc *.pdf
}
