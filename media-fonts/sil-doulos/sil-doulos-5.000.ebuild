# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/sil-doulos/sil-doulos-5.000.ebuild,v 1.1 2015/03/07 07:58:59 yngwin Exp $

EAPI=5
inherit font

MY_P="DoulosSIL-${PV}"

DESCRIPTION="Serif font for Roman and Cyrillic languages with comprehensive orthographic support"
HOMEPAGE="http://scripts.sil.org/DoulosSILfont"
SRC_URI="http://scripts.sil.org/cms/scripts/render_download.php?format=file&media_id=${MY_P}.zip&filename=${MY_P}.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="app-arch/unzip"

DOCS="OFL-FAQ.txt documentation/*"
S="${WORKDIR}/${MY_P}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
