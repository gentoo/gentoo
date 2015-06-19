# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/sil-charis/sil-charis-5.000.ebuild,v 1.1 2015/03/07 08:07:56 yngwin Exp $

EAPI=5
inherit font

MY_PN="CharisSIL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Serif typeface for Roman and Cyrillic languages"
HOMEPAGE="http://scripts.sil.org/CharisSILfont"
SRC_URI="http://scripts.sil.org/cms/scripts/render_download.php?format=file&media_id=${MY_P}.zip&filename=${MY_P}.zip -> ${P}.zip
	compact? ( http://scripts.sil.org/cms/scripts/render_download.php?format=file&media_id=CharisSILCompact-${PV}b.zip&filename=CharisSILCompact-${PV}.zip -> ${MY_PN}Compact-${PV}.zip )"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x64-macos"
IUSE="compact"

DEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_PN}-${PV}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="OFL-FAQ.txt documentation/*"

src_prepare() {
	if use compact; then
		mv "${WORKDIR}"/${MY_PN}Compact-${PV}/*.${FONT_SUFFIX} "${FONT_S}" || die
	fi
}
